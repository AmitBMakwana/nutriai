// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OnboardingRequestDto _$OnboardingRequestDtoFromJson(
  Map<String, dynamic> json,
) => _OnboardingRequestDto(
  goal: json['goal'] as String,
  gender: json['gender'] as String,
  dateOfBirth: json['date_of_birth'] as String,
  heightCm: (json['height_cm'] as num).toInt(),
  weightKg: (json['weight_kg'] as num).toDouble(),
  targetWeightKg: (json['target_weight_kg'] as num).toDouble(),
  activityLevel: json['activity_level'] as String,
  dietType: json['diet_type'] as String,
  unitSystem: json['unit_system'] as String,
);

Map<String, dynamic> _$OnboardingRequestDtoToJson(
  _OnboardingRequestDto instance,
) => <String, dynamic>{
  'goal': instance.goal,
  'gender': instance.gender,
  'date_of_birth': instance.dateOfBirth,
  'height_cm': instance.heightCm,
  'weight_kg': instance.weightKg,
  'target_weight_kg': instance.targetWeightKg,
  'activity_level': instance.activityLevel,
  'diet_type': instance.dietType,
  'unit_system': instance.unitSystem,
};
