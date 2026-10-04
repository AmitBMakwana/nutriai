import 'package:freezed_annotation/freezed_annotation.dart';

part 'reset_password_request_dto.freezed.dart';
part 'reset_password_request_dto.g.dart';

@freezed
abstract class ResetPasswordRequestDto with _$ResetPasswordRequestDto {
  const factory ResetPasswordRequestDto({
    required String email,
    required String token,
    required String password,
    @JsonKey(name: 'password_confirmation') required String passwordConfirmation,
  }) = _ResetPasswordRequestDto;

  factory ResetPasswordRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestDtoFromJson(json);
}
