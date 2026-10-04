import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nutriai/core/errors/exceptions.dart';
import 'package:nutriai/core/storage/secure_storage.dart';
import 'package:nutriai/features/auth/data/datasources/auth_api.dart';
import 'package:nutriai/features/auth/data/models/auth_response_dto.dart';
import 'package:nutriai/features/auth/data/models/forgot_password_request_dto.dart';
import 'package:nutriai/features/auth/data/models/login_request_dto.dart';
import 'package:nutriai/features/auth/data/models/register_request_dto.dart';
import 'package:nutriai/features/auth/data/models/reset_password_request_dto.dart';
import 'package:nutriai/features/auth/data/models/user_dto.dart';
import 'package:nutriai/features/auth/data/repositories/auth_repository_impl.dart';

class MockAuthApi extends Mock implements AuthApi {}

class MockSecureStorageService extends Mock implements SecureStorageService {}

void main() {
  late MockAuthApi mockAuthApi;
  late MockSecureStorageService mockStorage;
  late AuthRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(const LoginRequestDto(email: 'test@example.com', password: 'password'));
    registerFallbackValue(const RegisterRequestDto(
      name: 'Test',
      email: 'test@example.com',
      password: 'password',
      passwordConfirmation: 'password',
    ));
    registerFallbackValue(const ForgotPasswordRequestDto(email: 'test@example.com'));
    registerFallbackValue(const ResetPasswordRequestDto(
      email: 'test@example.com',
      token: 'tok',
      password: 'password',
      passwordConfirmation: 'password',
    ));
  });

  setUp(() {
    mockAuthApi = MockAuthApi();
    mockStorage = MockSecureStorageService();
    repository = AuthRepositoryImpl(
      authApi: mockAuthApi,
      storage: mockStorage,
    );
  });

  const testUserDto = UserDto(
    id: 1,
    name: 'Amit',
    email: 'amit@example.com',
    avatar: null,
    timezone: 'UTC',
    createdAt: '2026-09-29T12:00:00.000000Z',
  );

  group('AuthRepositoryImpl', () {
    test('login stores token and user details and returns UserEntity with token', () async {
      const authResponse = AuthResponseDto(
        user: testUserDto,
        token: '1|testtoken',
      );

      when(() => mockAuthApi.login(any())).thenAnswer((_) async => authResponse);
      when(() => mockStorage.saveToken(any())).thenAnswer((_) async {});
      when(() => mockStorage.saveUserDetails(
            id: any(named: 'id'),
            name: any(named: 'name'),
            email: any(named: 'email'),
          )).thenAnswer((_) async {});

      final (user, token) = await repository.login(
        email: 'amit@example.com',
        password: 'password123',
      );

      expect(user.id, 1);
      expect(user.name, 'Amit');
      expect(user.email, 'amit@example.com');
      expect(token, '1|testtoken');

      verify(() => mockAuthApi.login(any())).called(1);
      verify(() => mockStorage.saveToken('1|testtoken')).called(1);
      verify(() => mockStorage.saveUserDetails(
            id: '1',
            name: 'Amit',
            email: 'amit@example.com',
          )).called(1);
    });

    test('register calls AuthApi.register and maps to UserEntity', () async {
      when(() => mockAuthApi.register(any())).thenAnswer((_) async => testUserDto);

      final user = await repository.register(
        name: 'Amit',
        email: 'amit@example.com',
        password: 'password123',
        passwordConfirmation: 'password123',
      );

      expect(user.id, 1);
      expect(user.name, 'Amit');
      expect(user.email, 'amit@example.com');
      verify(() => mockAuthApi.register(any())).called(1);
    });

    test('logout calls AuthApi.logout and clears token from storage', () async {
      when(() => mockAuthApi.logout()).thenAnswer((_) async {});
      when(() => mockStorage.deleteToken()).thenAnswer((_) async {});

      await repository.logout();

      verify(() => mockAuthApi.logout()).called(1);
      verify(() => mockStorage.deleteToken()).called(1);
    });

    test('restoreSession returns null if no token is stored', () async {
      when(() => mockStorage.getToken()).thenAnswer((_) async => null);

      final user = await repository.restoreSession();

      expect(user, isNull);
      verify(() => mockStorage.getToken()).called(1);
      verifyNever(() => mockAuthApi.getMe());
    });

    test('restoreSession returns UserEntity when stored token is valid', () async {
      when(() => mockStorage.getToken()).thenAnswer((_) async => 'valid-token');
      when(() => mockAuthApi.getMe()).thenAnswer((_) async => testUserDto);
      when(() => mockStorage.saveUserDetails(
            id: any(named: 'id'),
            name: any(named: 'name'),
            email: any(named: 'email'),
          )).thenAnswer((_) async {});

      final user = await repository.restoreSession();

      expect(user, isNotNull);
      expect(user!.id, 1);
      expect(user.name, 'Amit');
      verify(() => mockStorage.getToken()).called(1);
      verify(() => mockAuthApi.getMe()).called(1);
    });

    test('restoreSession clears token and returns null when getMe fails with 401', () async {
      when(() => mockStorage.getToken()).thenAnswer((_) async => 'expired-token');
      when(() => mockAuthApi.getMe()).thenThrow(const UnauthorizedException());
      when(() => mockStorage.deleteToken()).thenAnswer((_) async {});

      final user = await repository.restoreSession();

      expect(user, isNull);
      verify(() => mockStorage.deleteToken()).called(1);
    });

    test('forgotPassword returns response message', () async {
      when(() => mockAuthApi.forgotPassword(any()))
          .thenAnswer((_) async => 'Reset link sent');

      final message = await repository.forgotPassword(email: 'amit@example.com');

      expect(message, 'Reset link sent');
      verify(() => mockAuthApi.forgotPassword(any())).called(1);
    });

    test('resetPassword returns response message', () async {
      when(() => mockAuthApi.resetPassword(any()))
          .thenAnswer((_) async => 'Password reset successfully');

      final message = await repository.resetPassword(
        email: 'amit@example.com',
        token: 'token123',
        password: 'newpassword123',
        passwordConfirmation: 'newpassword123',
      );

      expect(message, 'Password reset successfully');
      verify(() => mockAuthApi.resetPassword(any())).called(1);
    });
  });
}
