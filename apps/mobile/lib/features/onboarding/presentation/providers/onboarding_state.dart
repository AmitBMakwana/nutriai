import '../../../../core/utils/unit_converter.dart';
import '../../domain/entities/user_profile_entity.dart';

/// State representing user answers and progression through the multi-step onboarding wizard.
class OnboardingState {
  final int currentStep; // 0 to 8
  final String goal;
  final String gender;
  final DateTime dateOfBirth;
  final bool isHeightImperial;
  final double heightCm;
  final int heightFeet;
  final int heightInches;
  final bool isWeightImperial;
  final double weightKg;
  final double weightLbs;
  final double targetWeightKg;
  final double targetWeightLbs;
  final String activityLevel;
  final String dietType;

  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;
  final UserProfileEntity? savedProfile;

  const OnboardingState({
    this.currentStep = 0,
    this.goal = 'lose_weight',
    this.gender = 'male',
    required this.dateOfBirth,
    this.isHeightImperial = false,
    this.heightCm = 172.0,
    this.heightFeet = 5,
    this.heightInches = 8,
    this.isWeightImperial = false,
    this.weightKg = 72.0,
    this.weightLbs = 158.7,
    this.targetWeightKg = 68.0,
    this.targetWeightLbs = 149.9,
    this.activityLevel = 'moderately_active',
    this.dietType = 'everything',
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
    this.savedProfile,
  });

  factory OnboardingState.initial() {
    final now = DateTime.now();
    return OnboardingState(
      currentStep: 0,
      goal: 'lose_weight',
      gender: 'male',
      dateOfBirth: DateTime(now.year - 28, 6, 15),
      isHeightImperial: false,
      heightCm: 172.0,
      heightFeet: 5,
      heightInches: 8,
      isWeightImperial: false,
      weightKg: 72.0,
      weightLbs: UnitConverter.kgToLbs(72.0),
      targetWeightKg: 68.0,
      targetWeightLbs: UnitConverter.kgToLbs(68.0),
      activityLevel: 'moderately_active',
      dietType: 'everything',
      isSubmitting: false,
      isSuccess: false,
      errorMessage: null,
      savedProfile: null,
    );
  }

  int get totalSteps => 8;
  double get progress => ((currentStep + 1) / totalSteps).clamp(0.0, 1.0);

  int get calculatedAge {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  double get targetWeightDiffKg => targetWeightKg - weightKg;

  UserProfileEntity toProfileEntity() {
    return UserProfileEntity(
      goal: goal,
      gender: gender,
      dateOfBirth: dateOfBirth,
      heightCm: heightCm.round(),
      weightKg: double.parse(weightKg.toStringAsFixed(1)),
      targetWeightKg: double.parse(targetWeightKg.toStringAsFixed(1)),
      activityLevel: activityLevel,
      dietType: dietType,
      unitSystem: (isHeightImperial || isWeightImperial) ? 'imperial' : 'metric',
      isCompleted: true,
    );
  }

  OnboardingState copyWith({
    int? currentStep,
    String? goal,
    String? gender,
    DateTime? dateOfBirth,
    bool? isHeightImperial,
    double? heightCm,
    int? heightFeet,
    int? heightInches,
    bool? isWeightImperial,
    double? weightKg,
    double? weightLbs,
    double? targetWeightKg,
    double? targetWeightLbs,
    String? activityLevel,
    String? dietType,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    UserProfileEntity? savedProfile,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      goal: goal ?? this.goal,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      isHeightImperial: isHeightImperial ?? this.isHeightImperial,
      heightCm: heightCm ?? this.heightCm,
      heightFeet: heightFeet ?? this.heightFeet,
      heightInches: heightInches ?? this.heightInches,
      isWeightImperial: isWeightImperial ?? this.isWeightImperial,
      weightKg: weightKg ?? this.weightKg,
      weightLbs: weightLbs ?? this.weightLbs,
      targetWeightKg: targetWeightKg ?? this.targetWeightKg,
      targetWeightLbs: targetWeightLbs ?? this.targetWeightLbs,
      activityLevel: activityLevel ?? this.activityLevel,
      dietType: dietType ?? this.dietType,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      savedProfile: savedProfile ?? this.savedProfile,
    );
  }
}
