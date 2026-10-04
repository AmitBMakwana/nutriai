// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ResetPasswordRequestDto _$ResetPasswordRequestDtoFromJson(
  Map<String, dynamic> json,
) => _ResetPasswordRequestDto(
  email: json['email'] as String,
  token: json['token'] as String,
  password: json['password'] as String,
  passwordConfirmation: json['password_confirmation'] as String,
);

Map<String, dynamic> _$ResetPasswordRequestDtoToJson(
  _ResetPasswordRequestDto instance,
) => <String, dynamic>{
  'email': instance.email,
  'token': instance.token,
  'password': instance.password,
  'password_confirmation': instance.passwordConfirmation,
};
