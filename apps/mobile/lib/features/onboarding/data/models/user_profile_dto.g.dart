// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfileDto _$UserProfileDtoFromJson(Map<String, dynamic> json) =>
    _UserProfileDto(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      goal: json['goal'] as String?,
      gender: json['gender'] as String?,
      dateOfBirth: json['date_of_birth'] as String?,
      heightCm: (json['height_cm'] as num?)?.toInt(),
      weightKg: (json['weight_kg'] as num?)?.toDouble(),
      targetWeightKg: (json['target_weight_kg'] as num?)?.toDouble(),
      activityLevel: json['activity_level'] as String?,
      dietType: json['diet_type'] as String?,
      unitSystem: json['unit_system'] as String? ?? 'metric',
      isCompleted: json['is_completed'] as bool? ?? false,
    );

Map<String, dynamic> _$UserProfileDtoToJson(_UserProfileDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'goal': instance.goal,
      'gender': instance.gender,
      'date_of_birth': instance.dateOfBirth,
      'height_cm': instance.heightCm,
      'weight_kg': instance.weightKg,
      'target_weight_kg': instance.targetWeightKg,
      'activity_level': instance.activityLevel,
      'diet_type': instance.dietType,
      'unit_system': instance.unitSystem,
      'is_completed': instance.isCompleted,
    };
