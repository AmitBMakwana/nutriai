import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_request_dto.freezed.dart';
part 'onboarding_request_dto.g.dart';

@freezed
abstract class OnboardingRequestDto with _$OnboardingRequestDto {
  const factory OnboardingRequestDto({
    required String goal,
    required String gender,
    @JsonKey(name: 'date_of_birth') required String dateOfBirth,
    @JsonKey(name: 'height_cm') required int heightCm,
    @JsonKey(name: 'weight_kg') required double weightKg,
    @JsonKey(name: 'target_weight_kg') required double targetWeightKg,
    @JsonKey(name: 'activity_level') required String activityLevel,
    @JsonKey(name: 'diet_type') required String dietType,
    @JsonKey(name: 'unit_system') required String unitSystem,
  }) = _OnboardingRequestDto;

  factory OnboardingRequestDto.fromJson(Map<String, dynamic> json) =>
      _$OnboardingRequestDtoFromJson(json);
}
