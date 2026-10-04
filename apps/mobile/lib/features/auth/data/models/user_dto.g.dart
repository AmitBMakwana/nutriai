// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserDto _$UserDtoFromJson(Map<String, dynamic> json) => _UserDto(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  email: json['email'] as String,
  avatar: json['avatar'] as String?,
  timezone: json['timezone'] as String?,
  isOnboardingCompleted: json['is_onboarding_completed'] as bool? ?? false,
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$UserDtoToJson(_UserDto instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'avatar': instance.avatar,
  'timezone': instance.timezone,
  'is_onboarding_completed': instance.isOnboardingCompleted,
  'created_at': instance.createdAt,
};
