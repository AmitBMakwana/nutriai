import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

@freezed
abstract class UserDto with _$UserDto {
  const UserDto._();

  const factory UserDto({
    required int id,
    required String name,
    required String email,
    String? avatar,
    String? timezone,
    @JsonKey(name: 'is_onboarding_completed') @Default(false) bool isOnboardingCompleted,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);

  UserEntity toDomain() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      avatar: avatar,
      timezone: timezone,
      isOnboardingCompleted: isOnboardingCompleted,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
    );
  }

  factory UserDto.fromDomain(UserEntity entity) {
    return UserDto(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      avatar: entity.avatar,
      timezone: entity.timezone,
      isOnboardingCompleted: entity.isOnboardingCompleted,
      createdAt: entity.createdAt?.toIso8601String(),
    );
  }
}
