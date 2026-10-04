import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_profile_entity.dart';

part 'user_profile_dto.freezed.dart';
part 'user_profile_dto.g.dart';

@freezed
abstract class UserProfileDto with _$UserProfileDto {
  const UserProfileDto._();

  const factory UserProfileDto({
    int? id,
    @JsonKey(name: 'user_id') int? userId,
    String? goal,
    String? gender,
    @JsonKey(name: 'date_of_birth') String? dateOfBirth,
    @JsonKey(name: 'height_cm') int? heightCm,
    @JsonKey(name: 'weight_kg') double? weightKg,
    @JsonKey(name: 'target_weight_kg') double? targetWeightKg,
    @JsonKey(name: 'activity_level') String? activityLevel,
    @JsonKey(name: 'diet_type') String? dietType,
    @JsonKey(name: 'unit_system') @Default('metric') String unitSystem,
    @JsonKey(name: 'is_completed') @Default(false) bool isCompleted,
  }) = _UserProfileDto;

  factory UserProfileDto.fromJson(Map<String, dynamic> json) =>
      _$UserProfileDtoFromJson(json);

  UserProfileEntity toDomain() {
    return UserProfileEntity(
      id: id,
      userId: userId,
      goal: goal ?? 'maintain',
      gender: gender ?? 'prefer_not_to_say',
      dateOfBirth: dateOfBirth != null
          ? DateTime.tryParse(dateOfBirth!) ?? DateTime(2000, 1, 1)
          : DateTime(2000, 1, 1),
      heightCm: heightCm ?? 170,
      weightKg: weightKg ?? 70.0,
      targetWeightKg: targetWeightKg ?? 70.0,
      activityLevel: activityLevel ?? 'sedentary',
      dietType: dietType ?? 'everything',
      unitSystem: unitSystem,
      isCompleted: isCompleted,
    );
  }

  factory UserProfileDto.fromDomain(UserProfileEntity entity) {
    return UserProfileDto(
      id: entity.id,
      userId: entity.userId,
      goal: entity.goal,
      gender: entity.gender,
      dateOfBirth: entity.dateOfBirth.toIso8601String().split('T').first,
      heightCm: entity.heightCm,
      weightKg: entity.weightKg,
      targetWeightKg: entity.targetWeightKg,
      activityLevel: entity.activityLevel,
      dietType: entity.dietType,
      unitSystem: entity.unitSystem,
      isCompleted: entity.isCompleted,
    );
  }
}
