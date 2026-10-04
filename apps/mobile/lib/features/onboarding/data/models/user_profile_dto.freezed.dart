// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserProfileDto {

 int? get id;@JsonKey(name: 'user_id') int? get userId; String? get goal; String? get gender;@JsonKey(name: 'date_of_birth') String? get dateOfBirth;@JsonKey(name: 'height_cm') int? get heightCm;@JsonKey(name: 'weight_kg') double? get weightKg;@JsonKey(name: 'target_weight_kg') double? get targetWeightKg;@JsonKey(name: 'activity_level') String? get activityLevel;@JsonKey(name: 'diet_type') String? get dietType;@JsonKey(name: 'unit_system') String get unitSystem;@JsonKey(name: 'is_completed') bool get isCompleted;
/// Create a copy of UserProfileDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileDtoCopyWith<UserProfileDto> get copyWith => _$UserProfileDtoCopyWithImpl<UserProfileDto>(this as UserProfileDto, _$identity);

  /// Serializes this UserProfileDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UserProfileDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfileDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.goal, _this.goal) || other.goal == _this.goal)&&(identical(other.gender, _this.gender) || other.gender == _this.gender)&&(identical(other.dateOfBirth, _this.dateOfBirth) || other.dateOfBirth == _this.dateOfBirth)&&(identical(other.heightCm, _this.heightCm) || other.heightCm == _this.heightCm)&&(identical(other.weightKg, _this.weightKg) || other.weightKg == _this.weightKg)&&(identical(other.targetWeightKg, _this.targetWeightKg) || other.targetWeightKg == _this.targetWeightKg)&&(identical(other.activityLevel, _this.activityLevel) || other.activityLevel == _this.activityLevel)&&(identical(other.dietType, _this.dietType) || other.dietType == _this.dietType)&&(identical(other.unitSystem, _this.unitSystem) || other.unitSystem == _this.unitSystem)&&(identical(other.isCompleted, _this.isCompleted) || other.isCompleted == _this.isCompleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UserProfileDto;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.goal,_this.gender,_this.dateOfBirth,_this.heightCm,_this.weightKg,_this.targetWeightKg,_this.activityLevel,_this.dietType,_this.unitSystem,_this.isCompleted);
}

@override
String toString() {
  final _this = this as UserProfileDto;
  return 'UserProfileDto(id: ${_this.id}, userId: ${_this.userId}, goal: ${_this.goal}, gender: ${_this.gender}, dateOfBirth: ${_this.dateOfBirth}, heightCm: ${_this.heightCm}, weightKg: ${_this.weightKg}, targetWeightKg: ${_this.targetWeightKg}, activityLevel: ${_this.activityLevel}, dietType: ${_this.dietType}, unitSystem: ${_this.unitSystem}, isCompleted: ${_this.isCompleted})';
}


}

/// @nodoc
abstract mixin class $UserProfileDtoCopyWith<$Res>  {
  factory $UserProfileDtoCopyWith(UserProfileDto value, $Res Function(UserProfileDto) _then) = _$UserProfileDtoCopyWithImpl;
@useResult
$Res call({
 int? id,@JsonKey(name: 'user_id') int? userId, String? goal, String? gender,@JsonKey(name: 'date_of_birth') String? dateOfBirth,@JsonKey(name: 'height_cm') int? heightCm,@JsonKey(name: 'weight_kg') double? weightKg,@JsonKey(name: 'target_weight_kg') double? targetWeightKg,@JsonKey(name: 'activity_level') String? activityLevel,@JsonKey(name: 'diet_type') String? dietType,@JsonKey(name: 'unit_system') String unitSystem,@JsonKey(name: 'is_completed') bool isCompleted
});




}
/// @nodoc
class _$UserProfileDtoCopyWithImpl<$Res>
    implements $UserProfileDtoCopyWith<$Res> {
  _$UserProfileDtoCopyWithImpl(this._self, this._then);

  final UserProfileDto _self;
  final $Res Function(UserProfileDto) _then;

/// Create a copy of UserProfileDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? userId = freezed,Object? goal = freezed,Object? gender = freezed,Object? dateOfBirth = freezed,Object? heightCm = freezed,Object? weightKg = freezed,Object? targetWeightKg = freezed,Object? activityLevel = freezed,Object? dietType = freezed,Object? unitSystem = null,Object? isCompleted = null,}) {
  return _then(UserProfileDto(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,goal: freezed == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as String?,heightCm: freezed == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as int?,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double?,targetWeightKg: freezed == targetWeightKg ? _self.targetWeightKg : targetWeightKg // ignore: cast_nullable_to_non_nullable
as double?,activityLevel: freezed == activityLevel ? _self.activityLevel : activityLevel // ignore: cast_nullable_to_non_nullable
as String?,dietType: freezed == dietType ? _self.dietType : dietType // ignore: cast_nullable_to_non_nullable
as String?,unitSystem: null == unitSystem ? _self.unitSystem : unitSystem // ignore: cast_nullable_to_non_nullable
as String,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UserProfileDto].
extension UserProfileDtoPatterns on UserProfileDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfileDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfileDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfileDto value)  $default,){
final _that = this;
switch (_that) {
case _UserProfileDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfileDto value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfileDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id, @JsonKey(name: 'user_id')  int? userId,  String? goal,  String? gender, @JsonKey(name: 'date_of_birth')  String? dateOfBirth, @JsonKey(name: 'height_cm')  int? heightCm, @JsonKey(name: 'weight_kg')  double? weightKg, @JsonKey(name: 'target_weight_kg')  double? targetWeightKg, @JsonKey(name: 'activity_level')  String? activityLevel, @JsonKey(name: 'diet_type')  String? dietType, @JsonKey(name: 'unit_system')  String unitSystem, @JsonKey(name: 'is_completed')  bool isCompleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfileDto() when $default != null:
return $default(_that.id,_that.userId,_that.goal,_that.gender,_that.dateOfBirth,_that.heightCm,_that.weightKg,_that.targetWeightKg,_that.activityLevel,_that.dietType,_that.unitSystem,_that.isCompleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id, @JsonKey(name: 'user_id')  int? userId,  String? goal,  String? gender, @JsonKey(name: 'date_of_birth')  String? dateOfBirth, @JsonKey(name: 'height_cm')  int? heightCm, @JsonKey(name: 'weight_kg')  double? weightKg, @JsonKey(name: 'target_weight_kg')  double? targetWeightKg, @JsonKey(name: 'activity_level')  String? activityLevel, @JsonKey(name: 'diet_type')  String? dietType, @JsonKey(name: 'unit_system')  String unitSystem, @JsonKey(name: 'is_completed')  bool isCompleted)  $default,) {final _that = this;
switch (_that) {
case _UserProfileDto():
return $default(_that.id,_that.userId,_that.goal,_that.gender,_that.dateOfBirth,_that.heightCm,_that.weightKg,_that.targetWeightKg,_that.activityLevel,_that.dietType,_that.unitSystem,_that.isCompleted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id, @JsonKey(name: 'user_id')  int? userId,  String? goal,  String? gender, @JsonKey(name: 'date_of_birth')  String? dateOfBirth, @JsonKey(name: 'height_cm')  int? heightCm, @JsonKey(name: 'weight_kg')  double? weightKg, @JsonKey(name: 'target_weight_kg')  double? targetWeightKg, @JsonKey(name: 'activity_level')  String? activityLevel, @JsonKey(name: 'diet_type')  String? dietType, @JsonKey(name: 'unit_system')  String unitSystem, @JsonKey(name: 'is_completed')  bool isCompleted)?  $default,) {final _that = this;
switch (_that) {
case _UserProfileDto() when $default != null:
return $default(_that.id,_that.userId,_that.goal,_that.gender,_that.dateOfBirth,_that.heightCm,_that.weightKg,_that.targetWeightKg,_that.activityLevel,_that.dietType,_that.unitSystem,_that.isCompleted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserProfileDto extends UserProfileDto {
  const _UserProfileDto({this.id, @JsonKey(name: 'user_id') this.userId, this.goal, this.gender, @JsonKey(name: 'date_of_birth') this.dateOfBirth, @JsonKey(name: 'height_cm') this.heightCm, @JsonKey(name: 'weight_kg') this.weightKg, @JsonKey(name: 'target_weight_kg') this.targetWeightKg, @JsonKey(name: 'activity_level') this.activityLevel, @JsonKey(name: 'diet_type') this.dietType, @JsonKey(name: 'unit_system') this.unitSystem = 'metric', @JsonKey(name: 'is_completed') this.isCompleted = false}): super._();
  factory _UserProfileDto.fromJson(Map<String, dynamic> json) => _$UserProfileDtoFromJson(json);

@override final  int? id;
@override@JsonKey(name: 'user_id') final  int? userId;
@override final  String? goal;
@override final  String? gender;
@override@JsonKey(name: 'date_of_birth') final  String? dateOfBirth;
@override@JsonKey(name: 'height_cm') final  int? heightCm;
@override@JsonKey(name: 'weight_kg') final  double? weightKg;
@override@JsonKey(name: 'target_weight_kg') final  double? targetWeightKg;
@override@JsonKey(name: 'activity_level') final  String? activityLevel;
@override@JsonKey(name: 'diet_type') final  String? dietType;
@override@JsonKey(name: 'unit_system') final  String unitSystem;
@override@JsonKey(name: 'is_completed') final  bool isCompleted;

/// Create a copy of UserProfileDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileDtoCopyWith<_UserProfileDto> get copyWith => __$UserProfileDtoCopyWithImpl<_UserProfileDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserProfileDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfileDto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.goal, goal) || other.goal == goal)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.targetWeightKg, targetWeightKg) || other.targetWeightKg == targetWeightKg)&&(identical(other.activityLevel, activityLevel) || other.activityLevel == activityLevel)&&(identical(other.dietType, dietType) || other.dietType == dietType)&&(identical(other.unitSystem, unitSystem) || other.unitSystem == unitSystem)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,goal,gender,dateOfBirth,heightCm,weightKg,targetWeightKg,activityLevel,dietType,unitSystem,isCompleted);
}

@override
String toString() {
    return 'UserProfileDto(id: $id, userId: $userId, goal: $goal, gender: $gender, dateOfBirth: $dateOfBirth, heightCm: $heightCm, weightKg: $weightKg, targetWeightKg: $targetWeightKg, activityLevel: $activityLevel, dietType: $dietType, unitSystem: $unitSystem, isCompleted: $isCompleted)';
}


}

/// @nodoc
abstract mixin class _$UserProfileDtoCopyWith<$Res> implements $UserProfileDtoCopyWith<$Res> {
  factory _$UserProfileDtoCopyWith(_UserProfileDto value, $Res Function(_UserProfileDto) _then) = __$UserProfileDtoCopyWithImpl;
@override @useResult
$Res call({
 int? id,@JsonKey(name: 'user_id') int? userId, String? goal, String? gender,@JsonKey(name: 'date_of_birth') String? dateOfBirth,@JsonKey(name: 'height_cm') int? heightCm,@JsonKey(name: 'weight_kg') double? weightKg,@JsonKey(name: 'target_weight_kg') double? targetWeightKg,@JsonKey(name: 'activity_level') String? activityLevel,@JsonKey(name: 'diet_type') String? dietType,@JsonKey(name: 'unit_system') String unitSystem,@JsonKey(name: 'is_completed') bool isCompleted
});




}
/// @nodoc
class __$UserProfileDtoCopyWithImpl<$Res>
    implements _$UserProfileDtoCopyWith<$Res> {
  __$UserProfileDtoCopyWithImpl(this._self, this._then);

  final _UserProfileDto _self;
  final $Res Function(_UserProfileDto) _then;

/// Create a copy of UserProfileDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? userId = freezed,Object? goal = freezed,Object? gender = freezed,Object? dateOfBirth = freezed,Object? heightCm = freezed,Object? weightKg = freezed,Object? targetWeightKg = freezed,Object? activityLevel = freezed,Object? dietType = freezed,Object? unitSystem = null,Object? isCompleted = null,}) {
  return _then(_UserProfileDto(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,goal: freezed == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as String?,heightCm: freezed == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as int?,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double?,targetWeightKg: freezed == targetWeightKg ? _self.targetWeightKg : targetWeightKg // ignore: cast_nullable_to_non_nullable
as double?,activityLevel: freezed == activityLevel ? _self.activityLevel : activityLevel // ignore: cast_nullable_to_non_nullable
as String?,dietType: freezed == dietType ? _self.dietType : dietType // ignore: cast_nullable_to_non_nullable
as String?,unitSystem: null == unitSystem ? _self.unitSystem : unitSystem // ignore: cast_nullable_to_non_nullable
as String,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
