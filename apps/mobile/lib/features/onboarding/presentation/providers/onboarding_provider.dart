import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/unit_converter.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../nutrition/presentation/providers/nutrition_goal_provider.dart';
import '../../data/repositories/onboarding_repository_impl.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/submit_onboarding_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import 'onboarding_state.dart';

final submitOnboardingUseCaseProvider = Provider<SubmitOnboardingUseCase>((ref) {
  final repo = ref.watch(onboardingRepositoryProvider);
  return SubmitOnboardingUseCase(repo);
});

final getProfileUseCaseProvider = Provider<GetProfileUseCase>((ref) {
  final repo = ref.watch(onboardingRepositoryProvider);
  return GetProfileUseCase(repo);
});

final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>((ref) {
  final repo = ref.watch(onboardingRepositoryProvider);
  return UpdateProfileUseCase(repo);
});

/// Provider for [OnboardingNotifier] managing onboarding state and submission.
final onboardingNotifierProvider =
    NotifierProvider<OnboardingNotifier, OnboardingState>(OnboardingNotifier.new);

class OnboardingNotifier extends Notifier<OnboardingState> {
  @override
  OnboardingState build() {
    return OnboardingState.initial();
  }

  SubmitOnboardingUseCase get _submitUseCase =>
      ref.read(submitOnboardingUseCaseProvider);

  void setStep(int step) {
    state = state.copyWith(currentStep: step.clamp(0, 8));
  }

  void nextStep() {
    if (state.currentStep < 7) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    } else if (state.currentStep == 7) {
      submitOnboarding();
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void setGoal(String goal) {
    state = state.copyWith(goal: goal);
  }

  void setGender(String gender) {
    state = state.copyWith(gender: gender);
  }

  void setDateOfBirth(DateTime dob) {
    state = state.copyWith(dateOfBirth: dob);
  }

  void setHeightMetric(double cm) {
    final imperial = UnitConverter.cmToFeetAndInches(cm);
    state = state.copyWith(
      heightCm: cm,
      heightFeet: imperial.feet,
      heightInches: imperial.inches,
    );
  }

  void setHeightImperial(int feet, int inches) {
    final cm = UnitConverter.feetAndInchesToCm(feet, inches);
    state = state.copyWith(
      heightCm: cm,
      heightFeet: feet,
      heightInches: inches,
    );
  }

  void toggleHeightUnit(bool isImperial) {
    state = state.copyWith(isHeightImperial: isImperial);
  }

  void setWeightMetric(double kg) {
    final lbs = UnitConverter.kgToLbs(kg);
    state = state.copyWith(
      weightKg: kg,
      weightLbs: lbs,
    );
  }

  void setWeightImperial(double lbs) {
    final kg = UnitConverter.lbsToKg(lbs);
    state = state.copyWith(
      weightKg: kg,
      weightLbs: lbs,
    );
  }

  void toggleWeightUnit(bool isImperial) {
    state = state.copyWith(isWeightImperial: isImperial);
  }

  void setTargetWeightMetric(double kg) {
    final lbs = UnitConverter.kgToLbs(kg);
    state = state.copyWith(
      targetWeightKg: kg,
      targetWeightLbs: lbs,
    );
  }

  void setTargetWeightImperial(double lbs) {
    final kg = UnitConverter.lbsToKg(lbs);
    state = state.copyWith(
      targetWeightKg: kg,
      targetWeightLbs: lbs,
    );
  }

  void setActivityLevel(String activity) {
    state = state.copyWith(activityLevel: activity);
  }

  void setDietType(String diet) {
    state = state.copyWith(dietType: diet);
  }

  Future<bool> submitOnboarding() async {
    state = state.copyWith(
      currentStep: 8,
      isSubmitting: true,
      errorMessage: null,
    );

    try {
      final profile = await _submitUseCase(state.toProfileEntity());
      ref.read(authNotifierProvider.notifier).markOnboardingCompleted();

      try {
        await ref.read(nutritionGoalNotifierProvider.notifier).loadActiveGoal();
      } catch (_) {}

      state = state.copyWith(
        isSubmitting: false,
        isSuccess: true,
        savedProfile: profile,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        isSuccess: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }
}
