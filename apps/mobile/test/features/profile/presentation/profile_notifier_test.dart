import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nutriai/core/errors/exceptions.dart';
import 'package:nutriai/features/auth/domain/entities/user_entity.dart';
import 'package:nutriai/features/auth/presentation/providers/auth_provider.dart';
import 'package:nutriai/features/auth/presentation/providers/auth_state.dart';
import 'package:nutriai/features/nutrition/data/repositories/nutrition_repository_impl.dart';
import 'package:nutriai/features/nutrition/domain/entities/nutrition_goal_entity.dart';
import 'package:nutriai/features/nutrition/domain/repositories/nutrition_repository_interface.dart';
import 'package:nutriai/features/onboarding/domain/entities/user_profile_entity.dart';
import 'package:nutriai/features/profile/data/repositories/profile_repository.dart';
import 'package:nutriai/features/profile/presentation/providers/profile_notifier.dart';

class MockProfileRepository extends Mock implements IProfileRepository {}
class MockNutritionRepository extends Mock implements INutritionRepository {}
class FakeFile extends Fake implements File {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockProfileRepository mockRepo;
  late MockNutritionRepository mockNutritionRepo;

  setUpAll(() {
    registerFallbackValue(FakeFile());
  });

  final testUser = UserEntity(
    id: 1,
    name: 'Alice',
    email: 'alice@nutriai.app',
    avatar: 'https://example.com/avatar.jpg',
  );

  final testProfile = UserProfileEntity(
    id: 1,
    userId: 1,
    goal: 'lose_weight',
    gender: 'female',
    dateOfBirth: DateTime(1995, 6, 15),
    heightCm: 168,
    weightKg: 65.0,
    targetWeightKg: 58.0,
    activityLevel: 'moderately_active',
    dietType: 'vegetarian',
    unitSystem: 'metric',
    isCompleted: true,
  );

  const testGoal = NutritionGoalEntity(
    dailyCalories: 1800,
    proteinGrams: 120,
    carbsGrams: 200,
    fatGrams: 60,
    waterMl: 2500,
  );

  setUp(() {
    mockRepo = MockProfileRepository();
    mockNutritionRepo = MockNutritionRepository();
    when(() => mockNutritionRepo.getActiveGoal()).thenAnswer((_) async => testGoal);
  });

  ProviderContainer makeContainer({UserEntity? user}) {
    final container = ProviderContainer(
      overrides: [
        profileRepositoryProvider.overrideWithValue(mockRepo),
        nutritionRepositoryProvider.overrideWithValue(mockNutritionRepo),
        authNotifierProvider.overrideWith(() => FakeAuthNotifier(user ?? testUser)),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('ProfileNotifier', () {
    test('loadProfile fetches profile successfully', () async {
      when(() => mockRepo.getProfile()).thenAnswer((_) async => testProfile);

      final container = makeContainer();
      final notifier = container.read(profileNotifierProvider.notifier);

      await notifier.loadProfile();

      final state = container.read(profileNotifierProvider);
      expect(state.isLoading, false);
      expect(state.profile, testProfile);
      expect(state.user?.name, 'Alice');
      verify(() => mockRepo.getProfile()).called(greaterThanOrEqualTo(1));
    });

    test('updateProfile updates profile and user name on success', () async {
      when(() => mockRepo.getProfile()).thenAnswer((_) async => testProfile);
      final updatedProfile = testProfile.copyWith(weightKg: 63.0, activityLevel: 'very_active');
      when(() => mockRepo.updateProfile(any(), recalculateGoals: any(named: 'recalculateGoals')))
          .thenAnswer((_) async => updatedProfile);

      final container = makeContainer();
      final notifier = container.read(profileNotifierProvider.notifier);

      final result = await notifier.updateProfile({
        'name': 'Alice Wonder',
        'weight_kg': 63.0,
        'activity_level': 'very_active',
      }, recalculateGoals: true);

      expect(result, true);
      final state = container.read(profileNotifierProvider);
      expect(state.isUpdating, false);
      expect(state.profile?.weightKg, 63.0);
      expect(state.user?.name, 'Alice Wonder');
      expect(state.successMessage, isNotNull);
    });

    test('uploadAvatar updates user avatar on success', () async {
      when(() => mockRepo.getProfile()).thenAnswer((_) async => testProfile);
      final updatedUser = testUser.copyWith(avatar: 'https://example.com/new_avatar.jpg');
      when(() => mockRepo.uploadAvatar(any())).thenAnswer((_) async => updatedUser);

      final container = makeContainer();
      final notifier = container.read(profileNotifierProvider.notifier);

      final fakeFile = File('test_avatar.jpg');
      final result = await notifier.uploadAvatar(fakeFile);

      expect(result, true);
      final state = container.read(profileNotifierProvider);
      expect(state.isUploadingAvatar, false);
      expect(state.user?.avatar, 'https://example.com/new_avatar.jpg');
    });

    test('changePassword succeeds with valid credentials', () async {
      when(() => mockRepo.getProfile()).thenAnswer((_) async => testProfile);
      when(() => mockRepo.changePassword(
            currentPassword: any(named: 'currentPassword'),
            newPassword: any(named: 'newPassword'),
            passwordConfirmation: any(named: 'passwordConfirmation'),
          )).thenAnswer((_) async {});

      final container = makeContainer();
      final notifier = container.read(profileNotifierProvider.notifier);

      final result = await notifier.changePassword(
        currentPassword: 'OldPassword123!',
        newPassword: 'NewPassword123!',
        passwordConfirmation: 'NewPassword123!',
      );

      expect(result, true);
      final state = container.read(profileNotifierProvider);
      expect(state.isChangingPassword, false);
      expect(state.successMessage, 'Password changed successfully');
    });

    test('changePassword sets errorMessage on failure', () async {
      when(() => mockRepo.getProfile()).thenAnswer((_) async => testProfile);
      when(() => mockRepo.changePassword(
            currentPassword: any(named: 'currentPassword'),
            newPassword: any(named: 'newPassword'),
            passwordConfirmation: any(named: 'passwordConfirmation'),
          )).thenThrow(const BadRequestException('Current password does not match'));

      final container = makeContainer();
      final notifier = container.read(profileNotifierProvider.notifier);

      final result = await notifier.changePassword(
        currentPassword: 'WrongPassword!',
        newPassword: 'NewPassword123!',
        passwordConfirmation: 'NewPassword123!',
      );

      expect(result, false);
      final state = container.read(profileNotifierProvider);
      expect(state.isChangingPassword, false);
      expect(state.errorMessage, 'Current password does not match');
    });

    test('deleteAccount calls repository and logs out on success', () async {
      when(() => mockRepo.getProfile()).thenAnswer((_) async => testProfile);
      when(() => mockRepo.deleteAccount(
            password: any(named: 'password'),
            confirmation: any(named: 'confirmation'),
          )).thenAnswer((_) async {});

      final container = makeContainer();
      final notifier = container.read(profileNotifierProvider.notifier);

      final result = await notifier.deleteAccount(confirmation: true);

      expect(result, true);
      final state = container.read(profileNotifierProvider);
      expect(state.isDeletingAccount, false);
      verify(() => mockRepo.deleteAccount(password: null, confirmation: true)).called(1);
    });

    test('deleteAccount handles error when repository fails', () async {
      when(() => mockRepo.getProfile()).thenAnswer((_) async => testProfile);
      when(() => mockRepo.deleteAccount(
            password: any(named: 'password'),
            confirmation: any(named: 'confirmation'),
          )).thenThrow(const BadRequestException('Invalid password confirmation'));

      final container = makeContainer();
      final notifier = container.read(profileNotifierProvider.notifier);

      final result = await notifier.deleteAccount(password: 'bad', confirmation: true);

      expect(result, false);
      final state = container.read(profileNotifierProvider);
      expect(state.isDeletingAccount, false);
      expect(state.errorMessage, 'Invalid password confirmation');
    });
  });
}

class FakeAuthNotifier extends AuthNotifier {
  final UserEntity _user;
  FakeAuthNotifier(this._user);

  @override
  AuthState build() => AuthState.authenticated(user: _user);

  @override
  Future<void> logout() async {
    state = const AuthState.unauthenticated();
  }
}
