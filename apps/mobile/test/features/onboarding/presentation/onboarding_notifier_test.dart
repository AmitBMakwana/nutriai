import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutriai/features/auth/domain/entities/user_entity.dart';
import 'package:nutriai/features/auth/presentation/providers/auth_provider.dart';
import 'package:nutriai/features/auth/presentation/providers/auth_state.dart';
import 'package:nutriai/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:nutriai/features/onboarding/domain/entities/user_profile_entity.dart';
import 'package:nutriai/features/onboarding/domain/repositories/onboarding_repository_interface.dart';
import 'package:nutriai/features/onboarding/presentation/providers/onboarding_provider.dart';

class MockOnboardingRepository extends Mock implements IOnboardingRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      UserProfileEntity(
        goal: 'lose_weight',
        gender: 'male',
        dateOfBirth: DateTime(1995, 1, 1),
        heightCm: 175,
        weightKg: 75.0,
        targetWeightKg: 70.0,
        activityLevel: 'moderately_active',
        dietType: 'everything',
      ),
    );
  });

  late MockOnboardingRepository mockRepo;
  late ProviderContainer container;

  setUp(() {
    mockRepo = MockOnboardingRepository();
    container = ProviderContainer(
      overrides: [
        onboardingRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('OnboardingNotifier Tests', () {
    test('initial state has default health-tech baseline values', () {
      final state = container.read(onboardingNotifierProvider);

      expect(state.currentStep, equals(0));
      expect(state.goal, equals('lose_weight'));
      expect(state.gender, equals('male'));
      expect(state.heightCm, equals(172.0));
      expect(state.weightKg, equals(72.0));
      expect(state.targetWeightKg, equals(68.0));
      expect(state.activityLevel, equals('moderately_active'));
      expect(state.dietType, equals('everything'));
      expect(state.isSubmitting, isFalse);
      expect(state.isSuccess, isFalse);
      expect(state.errorMessage, isNull);
    });

    test('step navigation increments and decrements correctly', () {
      final notifier = container.read(onboardingNotifierProvider.notifier);

      notifier.nextStep();
      expect(container.read(onboardingNotifierProvider).currentStep, equals(1));

      notifier.nextStep();
      expect(container.read(onboardingNotifierProvider).currentStep, equals(2));

      notifier.previousStep();
      expect(container.read(onboardingNotifierProvider).currentStep, equals(1));

      notifier.previousStep();
      expect(container.read(onboardingNotifierProvider).currentStep, equals(0));

      // Cannot go below 0
      notifier.previousStep();
      expect(container.read(onboardingNotifierProvider).currentStep, equals(0));
    });

    test('updates basic profile choice properties', () {
      final notifier = container.read(onboardingNotifierProvider.notifier);

      notifier.setGoal('build_muscle');
      expect(container.read(onboardingNotifierProvider).goal, equals('build_muscle'));

      notifier.setGender('female');
      expect(container.read(onboardingNotifierProvider).gender, equals('female'));

      final dob = DateTime(2000, 5, 20);
      notifier.setDateOfBirth(dob);
      expect(container.read(onboardingNotifierProvider).dateOfBirth, equals(dob));

      notifier.setActivityLevel('very_active');
      expect(container.read(onboardingNotifierProvider).activityLevel, equals('very_active'));

      notifier.setDietType('vegan');
      expect(container.read(onboardingNotifierProvider).dietType, equals('vegan'));
    });

    test('height metric and imperial updates keep values synchronized', () {
      final notifier = container.read(onboardingNotifierProvider.notifier);

      notifier.setHeightMetric(180.0);
      final state1 = container.read(onboardingNotifierProvider);
      expect(state1.heightCm, equals(180.0));
      expect(state1.heightFeet, equals(5));
      expect(state1.heightInches, equals(11));

      notifier.setHeightImperial(6, 0);
      final state2 = container.read(onboardingNotifierProvider);
      expect(state2.heightFeet, equals(6));
      expect(state2.heightInches, equals(0));
      expect(state2.heightCm, equals(182.9));

      notifier.toggleHeightUnit(true);
      expect(container.read(onboardingNotifierProvider).isHeightImperial, isTrue);
    });

    test('weight metric and imperial updates keep values synchronized', () {
      final notifier = container.read(onboardingNotifierProvider.notifier);

      notifier.setWeightMetric(80.0);
      final state1 = container.read(onboardingNotifierProvider);
      expect(state1.weightKg, equals(80.0));
      expect(state1.weightLbs, equals(176.4));

      notifier.setWeightImperial(154.3);
      final state2 = container.read(onboardingNotifierProvider);
      expect(state2.weightLbs, equals(154.3));
      expect(state2.weightKg, equals(70.0));

      notifier.setTargetWeightMetric(75.0);
      final state3 = container.read(onboardingNotifierProvider);
      expect(state3.targetWeightKg, equals(75.0));
      expect(state3.targetWeightLbs, equals(165.3));
    });

    test('submitOnboarding sets calculating state, calls repository and updates auth state', () async {
      // Set an initial authenticated user with incomplete onboarding
      final authNotifier = container.read(authNotifierProvider.notifier);
      authNotifier.state = const AuthState.authenticated(
        user: UserEntity(
          id: 1,
          name: 'Jane Doe',
          email: 'jane@example.com',
          isOnboardingCompleted: false,
        ),
      );

      final returnedProfile = UserProfileEntity(
        id: 10,
        userId: 1,
        goal: 'lose_weight',
        gender: 'female',
        dateOfBirth: DateTime(1995, 6, 15),
        heightCm: 168,
        weightKg: 65.0,
        targetWeightKg: 60.0,
        activityLevel: 'moderately_active',
        dietType: 'vegetarian',
        isCompleted: true,
      );

      when(() => mockRepo.submitOnboarding(any()))
          .thenAnswer((_) async => returnedProfile);

      final notifier = container.read(onboardingNotifierProvider.notifier);
      final success = await notifier.submitOnboarding();

      expect(success, isTrue);

      final state = container.read(onboardingNotifierProvider);
      expect(state.currentStep, equals(8));
      expect(state.isSubmitting, isFalse);
      expect(state.isSuccess, isTrue);
      expect(state.savedProfile, equals(returnedProfile));

      // Verifies authNotifier marked onboarding completed
      final authState = container.read(authNotifierProvider);
      expect(authState.user?.isOnboardingCompleted, isTrue);

      verify(() => mockRepo.submitOnboarding(any())).called(1);
    });

    test('submitOnboarding sets error message on repository failure', () async {
      when(() => mockRepo.submitOnboarding(any()))
          .thenThrow(Exception('Network timeout'));

      final notifier = container.read(onboardingNotifierProvider.notifier);
      final success = await notifier.submitOnboarding();

      expect(success, isFalse);

      final state = container.read(onboardingNotifierProvider);
      expect(state.isSubmitting, isFalse);
      expect(state.isSuccess, isFalse);
      expect(state.errorMessage, contains('Network timeout'));
    });
  });
}
