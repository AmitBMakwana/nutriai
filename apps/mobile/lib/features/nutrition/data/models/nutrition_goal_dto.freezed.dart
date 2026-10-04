// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nutrition_goal_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NutritionGoalDto {

 int? get id;@JsonKey(name: 'user_id') int? get userId;@JsonKey(name: 'daily_calories') int get dailyCalories;@JsonKey(name: 'protein_grams') int get proteinGrams;@JsonKey(name: 'carbs_grams') int get carbsGrams;@JsonKey(name: 'fat_grams') int get fatGrams;@JsonKey(name: 'water_ml') int get waterMl;@JsonKey(name: 'effective_from') String? get effectiveFrom;
/// Create a copy of NutritionGoalDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NutritionGoalDtoCopyWith<NutritionGoalDto> get copyWith => _$NutritionGoalDtoCopyWithImpl<NutritionGoalDto>(this as NutritionGoalDto, _$identity);

  /// Serializes this NutritionGoalDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NutritionGoalDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NutritionGoalDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.dailyCalories, _this.dailyCalories) || other.dailyCalories == _this.dailyCalories)&&(identical(other.proteinGrams, _this.proteinGrams) || other.proteinGrams == _this.proteinGrams)&&(identical(other.carbsGrams, _this.carbsGrams) || other.carbsGrams == _this.carbsGrams)&&(identical(other.fatGrams, _this.fatGrams) || other.fatGrams == _this.fatGrams)&&(identical(other.waterMl, _this.waterMl) || other.waterMl == _this.waterMl)&&(identical(other.effectiveFrom, _this.effectiveFrom) || other.effectiveFrom == _this.effectiveFrom));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NutritionGoalDto;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.dailyCalories,_this.proteinGrams,_this.carbsGrams,_this.fatGrams,_this.waterMl,_this.effectiveFrom);
}

@override
String toString() {
  final _this = this as NutritionGoalDto;
  return 'NutritionGoalDto(id: ${_this.id}, userId: ${_this.userId}, dailyCalories: ${_this.dailyCalories}, proteinGrams: ${_this.proteinGrams}, carbsGrams: ${_this.carbsGrams}, fatGrams: ${_this.fatGrams}, waterMl: ${_this.waterMl}, effectiveFrom: ${_this.effectiveFrom})';
}


}

/// @nodoc
abstract mixin class $NutritionGoalDtoCopyWith<$Res>  {
  factory $NutritionGoalDtoCopyWith(NutritionGoalDto value, $Res Function(NutritionGoalDto) _then) = _$NutritionGoalDtoCopyWithImpl;
@useResult
$Res call({
 int? id,@JsonKey(name: 'user_id') int? userId,@JsonKey(name: 'daily_calories') int dailyCalories,@JsonKey(name: 'protein_grams') int proteinGrams,@JsonKey(name: 'carbs_grams') int carbsGrams,@JsonKey(name: 'fat_grams') int fatGrams,@JsonKey(name: 'water_ml') int waterMl,@JsonKey(name: 'effective_from') String? effectiveFrom
});




}
/// @nodoc
class _$NutritionGoalDtoCopyWithImpl<$Res>
    implements $NutritionGoalDtoCopyWith<$Res> {
  _$NutritionGoalDtoCopyWithImpl(this._self, this._then);

  final NutritionGoalDto _self;
  final $Res Function(NutritionGoalDto) _then;

/// Create a copy of NutritionGoalDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? userId = freezed,Object? dailyCalories = null,Object? proteinGrams = null,Object? carbsGrams = null,Object? fatGrams = null,Object? waterMl = null,Object? effectiveFrom = freezed,}) {
  return _then(NutritionGoalDto(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,dailyCalories: null == dailyCalories ? _self.dailyCalories : dailyCalories // ignore: cast_nullable_to_non_nullable
as int,proteinGrams: null == proteinGrams ? _self.proteinGrams : proteinGrams // ignore: cast_nullable_to_non_nullable
as int,carbsGrams: null == carbsGrams ? _self.carbsGrams : carbsGrams // ignore: cast_nullable_to_non_nullable
as int,fatGrams: null == fatGrams ? _self.fatGrams : fatGrams // ignore: cast_nullable_to_non_nullable
as int,waterMl: null == waterMl ? _self.waterMl : waterMl // ignore: cast_nullable_to_non_nullable
as int,effectiveFrom: freezed == effectiveFrom ? _self.effectiveFrom : effectiveFrom // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NutritionGoalDto].
extension NutritionGoalDtoPatterns on NutritionGoalDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NutritionGoalDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NutritionGoalDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NutritionGoalDto value)  $default,){
final _that = this;
switch (_that) {
case _NutritionGoalDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NutritionGoalDto value)?  $default,){
final _that = this;
switch (_that) {
case _NutritionGoalDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id, @JsonKey(name: 'user_id')  int? userId, @JsonKey(name: 'daily_calories')  int dailyCalories, @JsonKey(name: 'protein_grams')  int proteinGrams, @JsonKey(name: 'carbs_grams')  int carbsGrams, @JsonKey(name: 'fat_grams')  int fatGrams, @JsonKey(name: 'water_ml')  int waterMl, @JsonKey(name: 'effective_from')  String? effectiveFrom)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NutritionGoalDto() when $default != null:
return $default(_that.id,_that.userId,_that.dailyCalories,_that.proteinGrams,_that.carbsGrams,_that.fatGrams,_that.waterMl,_that.effectiveFrom);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id, @JsonKey(name: 'user_id')  int? userId, @JsonKey(name: 'daily_calories')  int dailyCalories, @JsonKey(name: 'protein_grams')  int proteinGrams, @JsonKey(name: 'carbs_grams')  int carbsGrams, @JsonKey(name: 'fat_grams')  int fatGrams, @JsonKey(name: 'water_ml')  int waterMl, @JsonKey(name: 'effective_from')  String? effectiveFrom)  $default,) {final _that = this;
switch (_that) {
case _NutritionGoalDto():
return $default(_that.id,_that.userId,_that.dailyCalories,_that.proteinGrams,_that.carbsGrams,_that.fatGrams,_that.waterMl,_that.effectiveFrom);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id, @JsonKey(name: 'user_id')  int? userId, @JsonKey(name: 'daily_calories')  int dailyCalories, @JsonKey(name: 'protein_grams')  int proteinGrams, @JsonKey(name: 'carbs_grams')  int carbsGrams, @JsonKey(name: 'fat_grams')  int fatGrams, @JsonKey(name: 'water_ml')  int waterMl, @JsonKey(name: 'effective_from')  String? effectiveFrom)?  $default,) {final _that = this;
switch (_that) {
case _NutritionGoalDto() when $default != null:
return $default(_that.id,_that.userId,_that.dailyCalories,_that.proteinGrams,_that.carbsGrams,_that.fatGrams,_that.waterMl,_that.effectiveFrom);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NutritionGoalDto extends NutritionGoalDto {
  const _NutritionGoalDto({this.id, @JsonKey(name: 'user_id') this.userId, @JsonKey(name: 'daily_calories') required this.dailyCalories, @JsonKey(name: 'protein_grams') required this.proteinGrams, @JsonKey(name: 'carbs_grams') required this.carbsGrams, @JsonKey(name: 'fat_grams') required this.fatGrams, @JsonKey(name: 'water_ml') required this.waterMl, @JsonKey(name: 'effective_from') this.effectiveFrom}): super._();
  factory _NutritionGoalDto.fromJson(Map<String, dynamic> json) => _$NutritionGoalDtoFromJson(json);

@override final  int? id;
@override@JsonKey(name: 'user_id') final  int? userId;
@override@JsonKey(name: 'daily_calories') final  int dailyCalories;
@override@JsonKey(name: 'protein_grams') final  int proteinGrams;
@override@JsonKey(name: 'carbs_grams') final  int carbsGrams;
@override@JsonKey(name: 'fat_grams') final  int fatGrams;
@override@JsonKey(name: 'water_ml') final  int waterMl;
@override@JsonKey(name: 'effective_from') final  String? effectiveFrom;

/// Create a copy of NutritionGoalDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NutritionGoalDtoCopyWith<_NutritionGoalDto> get copyWith => __$NutritionGoalDtoCopyWithImpl<_NutritionGoalDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NutritionGoalDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NutritionGoalDto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.dailyCalories, dailyCalories) || other.dailyCalories == dailyCalories)&&(identical(other.proteinGrams, proteinGrams) || other.proteinGrams == proteinGrams)&&(identical(other.carbsGrams, carbsGrams) || other.carbsGrams == carbsGrams)&&(identical(other.fatGrams, fatGrams) || other.fatGrams == fatGrams)&&(identical(other.waterMl, waterMl) || other.waterMl == waterMl)&&(identical(other.effectiveFrom, effectiveFrom) || other.effectiveFrom == effectiveFrom));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,dailyCalories,proteinGrams,carbsGrams,fatGrams,waterMl,effectiveFrom);
}

@override
String toString() {
    return 'NutritionGoalDto(id: $id, userId: $userId, dailyCalories: $dailyCalories, proteinGrams: $proteinGrams, carbsGrams: $carbsGrams, fatGrams: $fatGrams, waterMl: $waterMl, effectiveFrom: $effectiveFrom)';
}


}

/// @nodoc
abstract mixin class _$NutritionGoalDtoCopyWith<$Res> implements $NutritionGoalDtoCopyWith<$Res> {
  factory _$NutritionGoalDtoCopyWith(_NutritionGoalDto value, $Res Function(_NutritionGoalDto) _then) = __$NutritionGoalDtoCopyWithImpl;
@override @useResult
$Res call({
 int? id,@JsonKey(name: 'user_id') int? userId,@JsonKey(name: 'daily_calories') int dailyCalories,@JsonKey(name: 'protein_grams') int proteinGrams,@JsonKey(name: 'carbs_grams') int carbsGrams,@JsonKey(name: 'fat_grams') int fatGrams,@JsonKey(name: 'water_ml') int waterMl,@JsonKey(name: 'effective_from') String? effectiveFrom
});




}
/// @nodoc
class __$NutritionGoalDtoCopyWithImpl<$Res>
    implements _$NutritionGoalDtoCopyWith<$Res> {
  __$NutritionGoalDtoCopyWithImpl(this._self, this._then);

  final _NutritionGoalDto _self;
  final $Res Function(_NutritionGoalDto) _then;

/// Create a copy of NutritionGoalDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? userId = freezed,Object? dailyCalories = null,Object? proteinGrams = null,Object? carbsGrams = null,Object? fatGrams = null,Object? waterMl = null,Object? effectiveFrom = freezed,}) {
  return _then(_NutritionGoalDto(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,dailyCalories: null == dailyCalories ? _self.dailyCalories : dailyCalories // ignore: cast_nullable_to_non_nullable
as int,proteinGrams: null == proteinGrams ? _self.proteinGrams : proteinGrams // ignore: cast_nullable_to_non_nullable
as int,carbsGrams: null == carbsGrams ? _self.carbsGrams : carbsGrams // ignore: cast_nullable_to_non_nullable
as int,fatGrams: null == fatGrams ? _self.fatGrams : fatGrams // ignore: cast_nullable_to_non_nullable
as int,waterMl: null == waterMl ? _self.waterMl : waterMl // ignore: cast_nullable_to_non_nullable
as int,effectiveFrom: freezed == effectiveFrom ? _self.effectiveFrom : effectiveFrom // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
