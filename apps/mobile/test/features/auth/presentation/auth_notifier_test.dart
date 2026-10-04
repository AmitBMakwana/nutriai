import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nutriai/core/errors/exceptions.dart';
import 'package:nutriai/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:nutriai/features/auth/domain/entities/user_entity.dart';
import 'package:nutriai/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:nutriai/features/auth/presentation/providers/auth_provider.dart';
import 'package:nutriai/features/auth/presentation/providers/auth_state.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late ProviderContainer container;

  const testUser = UserEntity(
    id: 1,
    name: 'Amit',
    email: 'amit@example.com',
  );

  setUp(() {
    mockRepository = MockAuthRepository();
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AuthNotifier Tests', () {
    test('initial state is AuthInitial', () {
      final state = container.read(authNotifierProvider);
      expect(state, isA<AuthInitial>());
    });

    test('restoreSession transitions to AuthAuthenticated when user exists', () async {
      when(() => mockRepository.restoreSession()).thenAnswer((_) async => testUser);

      final notifier = container.read(authNotifierProvider.notifier);
      await notifier.restoreSession();

      final state = container.read(authNotifierProvider);
      expect(state, isA<AuthAuthenticated>());
      expect(state.user, testUser);
    });

    test('restoreSession transitions to AuthUnauthenticated when no user exists', () async {
      when(() => mockRepository.restoreSession()).thenAnswer((_) async => null);

      final notifier = container.read(authNotifierProvider.notifier);
      await notifier.restoreSession();

      final state = container.read(authNotifierProvider);
      expect(state, isA<AuthUnauthenticated>());
    });

    test('login transitions to AuthAuthenticated on success', () async {
      when(() => mockRepository.login(
            email: 'amit@example.com',
            password: 'password123',
          )).thenAnswer((_) async => (testUser, '1|token'));

      final notifier = container.read(authNotifierProvider.notifier);
      final success = await notifier.login(
        email: 'amit@example.com',
        password: 'password123',
      );

      expect(success, isTrue);
      final state = container.read(authNotifierProvider);
      expect(state, isA<AuthAuthenticated>());
      expect(state.user, testUser);
    });

    test('login transitions to AuthError on ValidationException with fieldErrors', () async {
      when(() => mockRepository.login(
            email: 'amit@example.com',
            password: 'wrong',
          )).thenThrow(const ValidationException(
        message: 'The given data was invalid.',
        errors: {
          'email': ['These credentials do not match our records.'],
        },
      ));

      final notifier = container.read(authNotifierProvider.notifier);
      final success = await notifier.login(
        email: 'amit@example.com',
        password: 'wrong',
      );

      expect(success, isFalse);
      final state = container.read(authNotifierProvider);
      expect(state, isA<AuthError>());
      expect(state.errorMessage, 'The given data was invalid.');
      expect(state.fieldError('email'), 'These credentials do not match our records.');
    });

    test('register calls repository and auto-logins to AuthAuthenticated', () async {
      when(() => mockRepository.register(
            name: 'Amit',
            email: 'amit@example.com',
            password: 'password123',
            passwordConfirmation: 'password123',
          )).thenAnswer((_) async => testUser);

      when(() => mockRepository.login(
            email: 'amit@example.com',
            password: 'password123',
          )).thenAnswer((_) async => (testUser, '1|token'));

      final notifier = container.read(authNotifierProvider.notifier);
      final success = await notifier.register(
        name: 'Amit',
        email: 'amit@example.com',
        password: 'password123',
        passwordConfirmation: 'password123',
      );

      expect(success, isTrue);
      final state = container.read(authNotifierProvider);
      expect(state, isA<AuthAuthenticated>());
      expect(state.user, testUser);
    });

    test('logout transitions to AuthUnauthenticated', () async {
      when(() => mockRepository.logout()).thenAnswer((_) async {});

      final notifier = container.read(authNotifierProvider.notifier);
      await notifier.logout();

      final state = container.read(authNotifierProvider);
      expect(state, isA<AuthUnauthenticated>());
    });
  });
}
