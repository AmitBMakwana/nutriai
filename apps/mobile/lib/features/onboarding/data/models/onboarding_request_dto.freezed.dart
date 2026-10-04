// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OnboardingRequestDto {

 String get goal; String get gender;@JsonKey(name: 'date_of_birth') String get dateOfBirth;@JsonKey(name: 'height_cm') int get heightCm;@JsonKey(name: 'weight_kg') double get weightKg;@JsonKey(name: 'target_weight_kg') double get targetWeightKg;@JsonKey(name: 'activity_level') String get activityLevel;@JsonKey(name: 'diet_type') String get dietType;@JsonKey(name: 'unit_system') String get unitSystem;
/// Create a copy of OnboardingRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingRequestDtoCopyWith<OnboardingRequestDto> get copyWith => _$OnboardingRequestDtoCopyWithImpl<OnboardingRequestDto>(this as OnboardingRequestDto, _$identity);

  /// Serializes this OnboardingRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OnboardingRequestDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingRequestDto&&(identical(other.goal, _this.goal) || other.goal == _this.goal)&&(identical(other.gender, _this.gender) || other.gender == _this.gender)&&(identical(other.dateOfBirth, _this.dateOfBirth) || other.dateOfBirth == _this.dateOfBirth)&&(identical(other.heightCm, _this.heightCm) || other.heightCm == _this.heightCm)&&(identical(other.weightKg, _this.weightKg) || other.weightKg == _this.weightKg)&&(identical(other.targetWeightKg, _this.targetWeightKg) || other.targetWeightKg == _this.targetWeightKg)&&(identical(other.activityLevel, _this.activityLevel) || other.activityLevel == _this.activityLevel)&&(identical(other.dietType, _this.dietType) || other.dietType == _this.dietType)&&(identical(other.unitSystem, _this.unitSystem) || other.unitSystem == _this.unitSystem));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OnboardingRequestDto;
  return Object.hash(runtimeType,_this.goal,_this.gender,_this.dateOfBirth,_this.heightCm,_this.weightKg,_this.targetWeightKg,_this.activityLevel,_this.dietType,_this.unitSystem);
}

@override
String toString() {
  final _this = this as OnboardingRequestDto;
  return 'OnboardingRequestDto(goal: ${_this.goal}, gender: ${_this.gender}, dateOfBirth: ${_this.dateOfBirth}, heightCm: ${_this.heightCm}, weightKg: ${_this.weightKg}, targetWeightKg: ${_this.targetWeightKg}, activityLevel: ${_this.activityLevel}, dietType: ${_this.dietType}, unitSystem: ${_this.unitSystem})';
}


}

/// @nodoc
abstract mixin class $OnboardingRequestDtoCopyWith<$Res>  {
  factory $OnboardingRequestDtoCopyWith(OnboardingRequestDto value, $Res Function(OnboardingRequestDto) _then) = _$OnboardingRequestDtoCopyWithImpl;
@useResult
$Res call({
 String goal, String gender,@JsonKey(name: 'date_of_birth') String dateOfBirth,@JsonKey(name: 'height_cm') int heightCm,@JsonKey(name: 'weight_kg') double weightKg,@JsonKey(name: 'target_weight_kg') double targetWeightKg,@JsonKey(name: 'activity_level') String activityLevel,@JsonKey(name: 'diet_type') String dietType,@JsonKey(name: 'unit_system') String unitSystem
});




}
/// @nodoc
class _$OnboardingRequestDtoCopyWithImpl<$Res>
    implements $OnboardingRequestDtoCopyWith<$Res> {
  _$OnboardingRequestDtoCopyWithImpl(this._self, this._then);

  final OnboardingRequestDto _self;
  final $Res Function(OnboardingRequestDto) _then;

/// Create a copy of OnboardingRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? goal = null,Object? gender = null,Object? dateOfBirth = null,Object? heightCm = null,Object? weightKg = null,Object? targetWeightKg = null,Object? activityLevel = null,Object? dietType = null,Object? unitSystem = null,}) {
  return _then(OnboardingRequestDto(
goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as String,heightCm: null == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as int,weightKg: null == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double,targetWeightKg: null == targetWeightKg ? _self.targetWeightKg : targetWeightKg // ignore: cast_nullable_to_non_nullable
as double,activityLevel: null == activityLevel ? _self.activityLevel : activityLevel // ignore: cast_nullable_to_non_nullable
as String,dietType: null == dietType ? _self.dietType : dietType // ignore: cast_nullable_to_non_nullable
as String,unitSystem: null == unitSystem ? _self.unitSystem : unitSystem // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingRequestDto].
extension OnboardingRequestDtoPatterns on OnboardingRequestDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingRequestDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingRequestDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingRequestDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String goal,  String gender, @JsonKey(name: 'date_of_birth')  String dateOfBirth, @JsonKey(name: 'height_cm')  int heightCm, @JsonKey(name: 'weight_kg')  double weightKg, @JsonKey(name: 'target_weight_kg')  double targetWeightKg, @JsonKey(name: 'activity_level')  String activityLevel, @JsonKey(name: 'diet_type')  String dietType, @JsonKey(name: 'unit_system')  String unitSystem)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingRequestDto() when $default != null:
return $default(_that.goal,_that.gender,_that.dateOfBirth,_that.heightCm,_that.weightKg,_that.targetWeightKg,_that.activityLevel,_that.dietType,_that.unitSystem);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String goal,  String gender, @JsonKey(name: 'date_of_birth')  String dateOfBirth, @JsonKey(name: 'height_cm')  int heightCm, @JsonKey(name: 'weight_kg')  double weightKg, @JsonKey(name: 'target_weight_kg')  double targetWeightKg, @JsonKey(name: 'activity_level')  String activityLevel, @JsonKey(name: 'diet_type')  String dietType, @JsonKey(name: 'unit_system')  String unitSystem)  $default,) {final _that = this;
switch (_that) {
case _OnboardingRequestDto():
return $default(_that.goal,_that.gender,_that.dateOfBirth,_that.heightCm,_that.weightKg,_that.targetWeightKg,_that.activityLevel,_that.dietType,_that.unitSystem);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String goal,  String gender, @JsonKey(name: 'date_of_birth')  String dateOfBirth, @JsonKey(name: 'height_cm')  int heightCm, @JsonKey(name: 'weight_kg')  double weightKg, @JsonKey(name: 'target_weight_kg')  double targetWeightKg, @JsonKey(name: 'activity_level')  String activityLevel, @JsonKey(name: 'diet_type')  String dietType, @JsonKey(name: 'unit_system')  String unitSystem)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingRequestDto() when $default != null:
return $default(_that.goal,_that.gender,_that.dateOfBirth,_that.heightCm,_that.weightKg,_that.targetWeightKg,_that.activityLevel,_that.dietType,_that.unitSystem);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OnboardingRequestDto implements OnboardingRequestDto {
  const _OnboardingRequestDto({required this.goal, required this.gender, @JsonKey(name: 'date_of_birth') required this.dateOfBirth, @JsonKey(name: 'height_cm') required this.heightCm, @JsonKey(name: 'weight_kg') required this.weightKg, @JsonKey(name: 'target_weight_kg') required this.targetWeightKg, @JsonKey(name: 'activity_level') required this.activityLevel, @JsonKey(name: 'diet_type') required this.dietType, @JsonKey(name: 'unit_system') required this.unitSystem});
  factory _OnboardingRequestDto.fromJson(Map<String, dynamic> json) => _$OnboardingRequestDtoFromJson(json);

@override final  String goal;
@override final  String gender;
@override@JsonKey(name: 'date_of_birth') final  String dateOfBirth;
@override@JsonKey(name: 'height_cm') final  int heightCm;
@override@JsonKey(name: 'weight_kg') final  double weightKg;
@override@JsonKey(name: 'target_weight_kg') final  double targetWeightKg;
@override@JsonKey(name: 'activity_level') final  String activityLevel;
@override@JsonKey(name: 'diet_type') final  String dietType;
@override@JsonKey(name: 'unit_system') final  String unitSystem;

/// Create a copy of OnboardingRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingRequestDtoCopyWith<_OnboardingRequestDto> get copyWith => __$OnboardingRequestDtoCopyWithImpl<_OnboardingRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OnboardingRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingRequestDto&&(identical(other.goal, goal) || other.goal == goal)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.targetWeightKg, targetWeightKg) || other.targetWeightKg == targetWeightKg)&&(identical(other.activityLevel, activityLevel) || other.activityLevel == activityLevel)&&(identical(other.dietType, dietType) || other.dietType == dietType)&&(identical(other.unitSystem, unitSystem) || other.unitSystem == unitSystem));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,goal,gender,dateOfBirth,heightCm,weightKg,targetWeightKg,activityLevel,dietType,unitSystem);
}

@override
String toString() {
    return 'OnboardingRequestDto(goal: $goal, gender: $gender, dateOfBirth: $dateOfBirth, heightCm: $heightCm, weightKg: $weightKg, targetWeightKg: $targetWeightKg, activityLevel: $activityLevel, dietType: $dietType, unitSystem: $unitSystem)';
}


}

/// @nodoc
abstract mixin class _$OnboardingRequestDtoCopyWith<$Res> implements $OnboardingRequestDtoCopyWith<$Res> {
  factory _$OnboardingRequestDtoCopyWith(_OnboardingRequestDto value, $Res Function(_OnboardingRequestDto) _then) = __$OnboardingRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 String goal, String gender,@JsonKey(name: 'date_of_birth') String dateOfBirth,@JsonKey(name: 'height_cm') int heightCm,@JsonKey(name: 'weight_kg') double weightKg,@JsonKey(name: 'target_weight_kg') double targetWeightKg,@JsonKey(name: 'activity_level') String activityLevel,@JsonKey(name: 'diet_type') String dietType,@JsonKey(name: 'unit_system') String unitSystem
});




}
/// @nodoc
class __$OnboardingRequestDtoCopyWithImpl<$Res>
    implements _$OnboardingRequestDtoCopyWith<$Res> {
  __$OnboardingRequestDtoCopyWithImpl(this._self, this._then);

  final _OnboardingRequestDto _self;
  final $Res Function(_OnboardingRequestDto) _then;

/// Create a copy of OnboardingRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? goal = null,Object? gender = null,Object? dateOfBirth = null,Object? heightCm = null,Object? weightKg = null,Object? targetWeightKg = null,Object? activityLevel = null,Object? dietType = null,Object? unitSystem = null,}) {
  return _then(_OnboardingRequestDto(
goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as String,heightCm: null == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as int,weightKg: null == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double,targetWeightKg: null == targetWeightKg ? _self.targetWeightKg : targetWeightKg // ignore: cast_nullable_to_non_nullable
as double,activityLevel: null == activityLevel ? _self.activityLevel : activityLevel // ignore: cast_nullable_to_non_nullable
as String,dietType: null == dietType ? _self.dietType : dietType // ignore: cast_nullable_to_non_nullable
as String,unitSystem: null == unitSystem ? _self.unitSystem : unitSystem // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
