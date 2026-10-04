/// Domain entity representing a user's health and nutrition profile.
class UserProfileEntity {
  final int? id;
  final int? userId;
  final String goal;
  final String gender;
  final DateTime dateOfBirth;
  final int heightCm;
  final double weightKg;
  final double targetWeightKg;
  final String activityLevel;
  final String dietType;
  final String unitSystem;
  final bool isCompleted;

  const UserProfileEntity({
    this.id,
    this.userId,
    required this.goal,
    required this.gender,
    required this.dateOfBirth,
    required this.heightCm,
    required this.weightKg,
    required this.targetWeightKg,
    required this.activityLevel,
    required this.dietType,
    this.unitSystem = 'metric',
    this.isCompleted = false,
  });

  UserProfileEntity copyWith({
    int? id,
    int? userId,
    String? goal,
    String? gender,
    DateTime? dateOfBirth,
    int? heightCm,
    double? weightKg,
    double? targetWeightKg,
    String? activityLevel,
    String? dietType,
    String? unitSystem,
    bool? isCompleted,
  }) {
    return UserProfileEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      goal: goal ?? this.goal,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      targetWeightKg: targetWeightKg ?? this.targetWeightKg,
      activityLevel: activityLevel ?? this.activityLevel,
      dietType: dietType ?? this.dietType,
      unitSystem: unitSystem ?? this.unitSystem,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
