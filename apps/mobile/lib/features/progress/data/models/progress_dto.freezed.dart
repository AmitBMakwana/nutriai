// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'progress_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DailyCaloriePointDto {

 String get date; int get consumed; int get target;
/// Create a copy of DailyCaloriePointDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyCaloriePointDtoCopyWith<DailyCaloriePointDto> get copyWith => _$DailyCaloriePointDtoCopyWithImpl<DailyCaloriePointDto>(this as DailyCaloriePointDto, _$identity);

  /// Serializes this DailyCaloriePointDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DailyCaloriePointDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyCaloriePointDto&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.consumed, _this.consumed) || other.consumed == _this.consumed)&&(identical(other.target, _this.target) || other.target == _this.target));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DailyCaloriePointDto;
  return Object.hash(runtimeType,_this.date,_this.consumed,_this.target);
}

@override
String toString() {
  final _this = this as DailyCaloriePointDto;
  return 'DailyCaloriePointDto(date: ${_this.date}, consumed: ${_this.consumed}, target: ${_this.target})';
}


}

/// @nodoc
abstract mixin class $DailyCaloriePointDtoCopyWith<$Res>  {
  factory $DailyCaloriePointDtoCopyWith(DailyCaloriePointDto value, $Res Function(DailyCaloriePointDto) _then) = _$DailyCaloriePointDtoCopyWithImpl;
@useResult
$Res call({
 String date, int consumed, int target
});




}
/// @nodoc
class _$DailyCaloriePointDtoCopyWithImpl<$Res>
    implements $DailyCaloriePointDtoCopyWith<$Res> {
  _$DailyCaloriePointDtoCopyWithImpl(this._self, this._then);

  final DailyCaloriePointDto _self;
  final $Res Function(DailyCaloriePointDto) _then;

/// Create a copy of DailyCaloriePointDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? consumed = null,Object? target = null,}) {
  return _then(DailyCaloriePointDto(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,consumed: null == consumed ? _self.consumed : consumed // ignore: cast_nullable_to_non_nullable
as int,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyCaloriePointDto].
extension DailyCaloriePointDtoPatterns on DailyCaloriePointDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyCaloriePointDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyCaloriePointDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyCaloriePointDto value)  $default,){
final _that = this;
switch (_that) {
case _DailyCaloriePointDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyCaloriePointDto value)?  $default,){
final _that = this;
switch (_that) {
case _DailyCaloriePointDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  int consumed,  int target)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyCaloriePointDto() when $default != null:
return $default(_that.date,_that.consumed,_that.target);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  int consumed,  int target)  $default,) {final _that = this;
switch (_that) {
case _DailyCaloriePointDto():
return $default(_that.date,_that.consumed,_that.target);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  int consumed,  int target)?  $default,) {final _that = this;
switch (_that) {
case _DailyCaloriePointDto() when $default != null:
return $default(_that.date,_that.consumed,_that.target);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailyCaloriePointDto implements DailyCaloriePointDto {
  const _DailyCaloriePointDto({required this.date, required this.consumed, required this.target});
  factory _DailyCaloriePointDto.fromJson(Map<String, dynamic> json) => _$DailyCaloriePointDtoFromJson(json);

@override final  String date;
@override final  int consumed;
@override final  int target;

/// Create a copy of DailyCaloriePointDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyCaloriePointDtoCopyWith<_DailyCaloriePointDto> get copyWith => __$DailyCaloriePointDtoCopyWithImpl<_DailyCaloriePointDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyCaloriePointDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyCaloriePointDto&&(identical(other.date, date) || other.date == date)&&(identical(other.consumed, consumed) || other.consumed == consumed)&&(identical(other.target, target) || other.target == target));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,date,consumed,target);
}

@override
String toString() {
    return 'DailyCaloriePointDto(date: $date, consumed: $consumed, target: $target)';
}


}

/// @nodoc
abstract mixin class _$DailyCaloriePointDtoCopyWith<$Res> implements $DailyCaloriePointDtoCopyWith<$Res> {
  factory _$DailyCaloriePointDtoCopyWith(_DailyCaloriePointDto value, $Res Function(_DailyCaloriePointDto) _then) = __$DailyCaloriePointDtoCopyWithImpl;
@override @useResult
$Res call({
 String date, int consumed, int target
});




}
/// @nodoc
class __$DailyCaloriePointDtoCopyWithImpl<$Res>
    implements _$DailyCaloriePointDtoCopyWith<$Res> {
  __$DailyCaloriePointDtoCopyWithImpl(this._self, this._then);

  final _DailyCaloriePointDto _self;
  final $Res Function(_DailyCaloriePointDto) _then;

/// Create a copy of DailyCaloriePointDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? consumed = null,Object? target = null,}) {
  return _then(_DailyCaloriePointDto(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,consumed: null == consumed ? _self.consumed : consumed // ignore: cast_nullable_to_non_nullable
as int,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$MacroAveragesDto {

 int get calories; double get protein; double get carbs; double get fat;
/// Create a copy of MacroAveragesDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MacroAveragesDtoCopyWith<MacroAveragesDto> get copyWith => _$MacroAveragesDtoCopyWithImpl<MacroAveragesDto>(this as MacroAveragesDto, _$identity);

  /// Serializes this MacroAveragesDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MacroAveragesDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MacroAveragesDto&&(identical(other.calories, _this.calories) || other.calories == _this.calories)&&(identical(other.protein, _this.protein) || other.protein == _this.protein)&&(identical(other.carbs, _this.carbs) || other.carbs == _this.carbs)&&(identical(other.fat, _this.fat) || other.fat == _this.fat));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MacroAveragesDto;
  return Object.hash(runtimeType,_this.calories,_this.protein,_this.carbs,_this.fat);
}

@override
String toString() {
  final _this = this as MacroAveragesDto;
  return 'MacroAveragesDto(calories: ${_this.calories}, protein: ${_this.protein}, carbs: ${_this.carbs}, fat: ${_this.fat})';
}


}

/// @nodoc
abstract mixin class $MacroAveragesDtoCopyWith<$Res>  {
  factory $MacroAveragesDtoCopyWith(MacroAveragesDto value, $Res Function(MacroAveragesDto) _then) = _$MacroAveragesDtoCopyWithImpl;
@useResult
$Res call({
 int calories, double protein, double carbs, double fat
});




}
/// @nodoc
class _$MacroAveragesDtoCopyWithImpl<$Res>
    implements $MacroAveragesDtoCopyWith<$Res> {
  _$MacroAveragesDtoCopyWithImpl(this._self, this._then);

  final MacroAveragesDto _self;
  final $Res Function(MacroAveragesDto) _then;

/// Create a copy of MacroAveragesDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? calories = null,Object? protein = null,Object? carbs = null,Object? fat = null,}) {
  return _then(MacroAveragesDto(
calories: null == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as int,protein: null == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as double,carbs: null == carbs ? _self.carbs : carbs // ignore: cast_nullable_to_non_nullable
as double,fat: null == fat ? _self.fat : fat // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [MacroAveragesDto].
extension MacroAveragesDtoPatterns on MacroAveragesDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MacroAveragesDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MacroAveragesDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MacroAveragesDto value)  $default,){
final _that = this;
switch (_that) {
case _MacroAveragesDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MacroAveragesDto value)?  $default,){
final _that = this;
switch (_that) {
case _MacroAveragesDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int calories,  double protein,  double carbs,  double fat)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MacroAveragesDto() when $default != null:
return $default(_that.calories,_that.protein,_that.carbs,_that.fat);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int calories,  double protein,  double carbs,  double fat)  $default,) {final _that = this;
switch (_that) {
case _MacroAveragesDto():
return $default(_that.calories,_that.protein,_that.carbs,_that.fat);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int calories,  double protein,  double carbs,  double fat)?  $default,) {final _that = this;
switch (_that) {
case _MacroAveragesDto() when $default != null:
return $default(_that.calories,_that.protein,_that.carbs,_that.fat);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MacroAveragesDto implements MacroAveragesDto {
  const _MacroAveragesDto({required this.calories, required this.protein, required this.carbs, required this.fat});
  factory _MacroAveragesDto.fromJson(Map<String, dynamic> json) => _$MacroAveragesDtoFromJson(json);

@override final  int calories;
@override final  double protein;
@override final  double carbs;
@override final  double fat;

/// Create a copy of MacroAveragesDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MacroAveragesDtoCopyWith<_MacroAveragesDto> get copyWith => __$MacroAveragesDtoCopyWithImpl<_MacroAveragesDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MacroAveragesDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MacroAveragesDto&&(identical(other.calories, calories) || other.calories == calories)&&(identical(other.protein, protein) || other.protein == protein)&&(identical(other.carbs, carbs) || other.carbs == carbs)&&(identical(other.fat, fat) || other.fat == fat));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,calories,protein,carbs,fat);
}

@override
String toString() {
    return 'MacroAveragesDto(calories: $calories, protein: $protein, carbs: $carbs, fat: $fat)';
}


}

/// @nodoc
abstract mixin class _$MacroAveragesDtoCopyWith<$Res> implements $MacroAveragesDtoCopyWith<$Res> {
  factory _$MacroAveragesDtoCopyWith(_MacroAveragesDto value, $Res Function(_MacroAveragesDto) _then) = __$MacroAveragesDtoCopyWithImpl;
@override @useResult
$Res call({
 int calories, double protein, double carbs, double fat
});




}
/// @nodoc
class __$MacroAveragesDtoCopyWithImpl<$Res>
    implements _$MacroAveragesDtoCopyWith<$Res> {
  __$MacroAveragesDtoCopyWithImpl(this._self, this._then);

  final _MacroAveragesDto _self;
  final $Res Function(_MacroAveragesDto) _then;

/// Create a copy of MacroAveragesDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? calories = null,Object? protein = null,Object? carbs = null,Object? fat = null,}) {
  return _then(_MacroAveragesDto(
calories: null == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as int,protein: null == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as double,carbs: null == carbs ? _self.carbs : carbs // ignore: cast_nullable_to_non_nullable
as double,fat: null == fat ? _self.fat : fat // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$MacroTargetsDto {

 double get protein; double get carbs; double get fat;
/// Create a copy of MacroTargetsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MacroTargetsDtoCopyWith<MacroTargetsDto> get copyWith => _$MacroTargetsDtoCopyWithImpl<MacroTargetsDto>(this as MacroTargetsDto, _$identity);

  /// Serializes this MacroTargetsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MacroTargetsDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MacroTargetsDto&&(identical(other.protein, _this.protein) || other.protein == _this.protein)&&(identical(other.carbs, _this.carbs) || other.carbs == _this.carbs)&&(identical(other.fat, _this.fat) || other.fat == _this.fat));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MacroTargetsDto;
  return Object.hash(runtimeType,_this.protein,_this.carbs,_this.fat);
}

@override
String toString() {
  final _this = this as MacroTargetsDto;
  return 'MacroTargetsDto(protein: ${_this.protein}, carbs: ${_this.carbs}, fat: ${_this.fat})';
}


}

/// @nodoc
abstract mixin class $MacroTargetsDtoCopyWith<$Res>  {
  factory $MacroTargetsDtoCopyWith(MacroTargetsDto value, $Res Function(MacroTargetsDto) _then) = _$MacroTargetsDtoCopyWithImpl;
@useResult
$Res call({
 double protein, double carbs, double fat
});




}
/// @nodoc
class _$MacroTargetsDtoCopyWithImpl<$Res>
    implements $MacroTargetsDtoCopyWith<$Res> {
  _$MacroTargetsDtoCopyWithImpl(this._self, this._then);

  final MacroTargetsDto _self;
  final $Res Function(MacroTargetsDto) _then;

/// Create a copy of MacroTargetsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? protein = null,Object? carbs = null,Object? fat = null,}) {
  return _then(MacroTargetsDto(
protein: null == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as double,carbs: null == carbs ? _self.carbs : carbs // ignore: cast_nullable_to_non_nullable
as double,fat: null == fat ? _self.fat : fat // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [MacroTargetsDto].
extension MacroTargetsDtoPatterns on MacroTargetsDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MacroTargetsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MacroTargetsDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MacroTargetsDto value)  $default,){
final _that = this;
switch (_that) {
case _MacroTargetsDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MacroTargetsDto value)?  $default,){
final _that = this;
switch (_that) {
case _MacroTargetsDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double protein,  double carbs,  double fat)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MacroTargetsDto() when $default != null:
return $default(_that.protein,_that.carbs,_that.fat);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double protein,  double carbs,  double fat)  $default,) {final _that = this;
switch (_that) {
case _MacroTargetsDto():
return $default(_that.protein,_that.carbs,_that.fat);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double protein,  double carbs,  double fat)?  $default,) {final _that = this;
switch (_that) {
case _MacroTargetsDto() when $default != null:
return $default(_that.protein,_that.carbs,_that.fat);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MacroTargetsDto implements MacroTargetsDto {
  const _MacroTargetsDto({required this.protein, required this.carbs, required this.fat});
  factory _MacroTargetsDto.fromJson(Map<String, dynamic> json) => _$MacroTargetsDtoFromJson(json);

@override final  double protein;
@override final  double carbs;
@override final  double fat;

/// Create a copy of MacroTargetsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MacroTargetsDtoCopyWith<_MacroTargetsDto> get copyWith => __$MacroTargetsDtoCopyWithImpl<_MacroTargetsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MacroTargetsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MacroTargetsDto&&(identical(other.protein, protein) || other.protein == protein)&&(identical(other.carbs, carbs) || other.carbs == carbs)&&(identical(other.fat, fat) || other.fat == fat));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,protein,carbs,fat);
}

@override
String toString() {
    return 'MacroTargetsDto(protein: $protein, carbs: $carbs, fat: $fat)';
}


}

/// @nodoc
abstract mixin class _$MacroTargetsDtoCopyWith<$Res> implements $MacroTargetsDtoCopyWith<$Res> {
  factory _$MacroTargetsDtoCopyWith(_MacroTargetsDto value, $Res Function(_MacroTargetsDto) _then) = __$MacroTargetsDtoCopyWithImpl;
@override @useResult
$Res call({
 double protein, double carbs, double fat
});




}
/// @nodoc
class __$MacroTargetsDtoCopyWithImpl<$Res>
    implements _$MacroTargetsDtoCopyWith<$Res> {
  __$MacroTargetsDtoCopyWithImpl(this._self, this._then);

  final _MacroTargetsDto _self;
  final $Res Function(_MacroTargetsDto) _then;

/// Create a copy of MacroTargetsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? protein = null,Object? carbs = null,Object? fat = null,}) {
  return _then(_MacroTargetsDto(
protein: null == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as double,carbs: null == carbs ? _self.carbs : carbs // ignore: cast_nullable_to_non_nullable
as double,fat: null == fat ? _self.fat : fat // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$MacroProgressDto {

 MacroAveragesDto get average; MacroTargetsDto get target;
/// Create a copy of MacroProgressDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MacroProgressDtoCopyWith<MacroProgressDto> get copyWith => _$MacroProgressDtoCopyWithImpl<MacroProgressDto>(this as MacroProgressDto, _$identity);

  /// Serializes this MacroProgressDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MacroProgressDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MacroProgressDto&&(identical(other.average, _this.average) || other.average == _this.average)&&(identical(other.target, _this.target) || other.target == _this.target));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MacroProgressDto;
  return Object.hash(runtimeType,_this.average,_this.target);
}

@override
String toString() {
  final _this = this as MacroProgressDto;
  return 'MacroProgressDto(average: ${_this.average}, target: ${_this.target})';
}


}

/// @nodoc
abstract mixin class $MacroProgressDtoCopyWith<$Res>  {
  factory $MacroProgressDtoCopyWith(MacroProgressDto value, $Res Function(MacroProgressDto) _then) = _$MacroProgressDtoCopyWithImpl;
@useResult
$Res call({
 MacroAveragesDto average, MacroTargetsDto target
});


$MacroAveragesDtoCopyWith<$Res> get average;$MacroTargetsDtoCopyWith<$Res> get target;

}
/// @nodoc
class _$MacroProgressDtoCopyWithImpl<$Res>
    implements $MacroProgressDtoCopyWith<$Res> {
  _$MacroProgressDtoCopyWithImpl(this._self, this._then);

  final MacroProgressDto _self;
  final $Res Function(MacroProgressDto) _then;

/// Create a copy of MacroProgressDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? average = null,Object? target = null,}) {
  return _then(MacroProgressDto(
average: null == average ? _self.average : average // ignore: cast_nullable_to_non_nullable
as MacroAveragesDto,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as MacroTargetsDto,
  ));
}
/// Create a copy of MacroProgressDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MacroAveragesDtoCopyWith<$Res> get average {
  
  return $MacroAveragesDtoCopyWith<$Res>(_self.average, (value) {
    return _then(_self.copyWith(average: value));
  });
}/// Create a copy of MacroProgressDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MacroTargetsDtoCopyWith<$Res> get target {
  
  return $MacroTargetsDtoCopyWith<$Res>(_self.target, (value) {
    return _then(_self.copyWith(target: value));
  });
}
}


/// Adds pattern-matching-related methods to [MacroProgressDto].
extension MacroProgressDtoPatterns on MacroProgressDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MacroProgressDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MacroProgressDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MacroProgressDto value)  $default,){
final _that = this;
switch (_that) {
case _MacroProgressDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MacroProgressDto value)?  $default,){
final _that = this;
switch (_that) {
case _MacroProgressDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MacroAveragesDto average,  MacroTargetsDto target)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MacroProgressDto() when $default != null:
return $default(_that.average,_that.target);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MacroAveragesDto average,  MacroTargetsDto target)  $default,) {final _that = this;
switch (_that) {
case _MacroProgressDto():
return $default(_that.average,_that.target);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MacroAveragesDto average,  MacroTargetsDto target)?  $default,) {final _that = this;
switch (_that) {
case _MacroProgressDto() when $default != null:
return $default(_that.average,_that.target);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MacroProgressDto implements MacroProgressDto {
  const _MacroProgressDto({required this.average, required this.target});
  factory _MacroProgressDto.fromJson(Map<String, dynamic> json) => _$MacroProgressDtoFromJson(json);

@override final  MacroAveragesDto average;
@override final  MacroTargetsDto target;

/// Create a copy of MacroProgressDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MacroProgressDtoCopyWith<_MacroProgressDto> get copyWith => __$MacroProgressDtoCopyWithImpl<_MacroProgressDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MacroProgressDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MacroProgressDto&&(identical(other.average, average) || other.average == average)&&(identical(other.target, target) || other.target == target));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,average,target);
}

@override
String toString() {
    return 'MacroProgressDto(average: $average, target: $target)';
}


}

/// @nodoc
abstract mixin class _$MacroProgressDtoCopyWith<$Res> implements $MacroProgressDtoCopyWith<$Res> {
  factory _$MacroProgressDtoCopyWith(_MacroProgressDto value, $Res Function(_MacroProgressDto) _then) = __$MacroProgressDtoCopyWithImpl;
@override @useResult
$Res call({
 MacroAveragesDto average, MacroTargetsDto target
});


@override $MacroAveragesDtoCopyWith<$Res> get average;@override $MacroTargetsDtoCopyWith<$Res> get target;

}
/// @nodoc
class __$MacroProgressDtoCopyWithImpl<$Res>
    implements _$MacroProgressDtoCopyWith<$Res> {
  __$MacroProgressDtoCopyWithImpl(this._self, this._then);

  final _MacroProgressDto _self;
  final $Res Function(_MacroProgressDto) _then;

/// Create a copy of MacroProgressDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? average = null,Object? target = null,}) {
  return _then(_MacroProgressDto(
average: null == average ? _self.average : average // ignore: cast_nullable_to_non_nullable
as MacroAveragesDto,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as MacroTargetsDto,
  ));
}

/// Create a copy of MacroProgressDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MacroAveragesDtoCopyWith<$Res> get average {
  
  return $MacroAveragesDtoCopyWith<$Res>(_self.average, (value) {
    return _then(_self.copyWith(average: value));
  });
}/// Create a copy of MacroProgressDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MacroTargetsDtoCopyWith<$Res> get target {
  
  return $MacroTargetsDtoCopyWith<$Res>(_self.target, (value) {
    return _then(_self.copyWith(target: value));
  });
}
}


/// @nodoc
mixin _$WeightPointDto {

 String get date;@JsonKey(name: 'weight_kg') double get weightKg;
/// Create a copy of WeightPointDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeightPointDtoCopyWith<WeightPointDto> get copyWith => _$WeightPointDtoCopyWithImpl<WeightPointDto>(this as WeightPointDto, _$identity);

  /// Serializes this WeightPointDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WeightPointDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeightPointDto&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.weightKg, _this.weightKg) || other.weightKg == _this.weightKg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WeightPointDto;
  return Object.hash(runtimeType,_this.date,_this.weightKg);
}

@override
String toString() {
  final _this = this as WeightPointDto;
  return 'WeightPointDto(date: ${_this.date}, weightKg: ${_this.weightKg})';
}


}

/// @nodoc
abstract mixin class $WeightPointDtoCopyWith<$Res>  {
  factory $WeightPointDtoCopyWith(WeightPointDto value, $Res Function(WeightPointDto) _then) = _$WeightPointDtoCopyWithImpl;
@useResult
$Res call({
 String date,@JsonKey(name: 'weight_kg') double weightKg
});




}
/// @nodoc
class _$WeightPointDtoCopyWithImpl<$Res>
    implements $WeightPointDtoCopyWith<$Res> {
  _$WeightPointDtoCopyWithImpl(this._self, this._then);

  final WeightPointDto _self;
  final $Res Function(WeightPointDto) _then;

/// Create a copy of WeightPointDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? weightKg = null,}) {
  return _then(WeightPointDto(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,weightKg: null == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [WeightPointDto].
extension WeightPointDtoPatterns on WeightPointDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeightPointDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeightPointDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeightPointDto value)  $default,){
final _that = this;
switch (_that) {
case _WeightPointDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeightPointDto value)?  $default,){
final _that = this;
switch (_that) {
case _WeightPointDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date, @JsonKey(name: 'weight_kg')  double weightKg)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeightPointDto() when $default != null:
return $default(_that.date,_that.weightKg);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date, @JsonKey(name: 'weight_kg')  double weightKg)  $default,) {final _that = this;
switch (_that) {
case _WeightPointDto():
return $default(_that.date,_that.weightKg);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date, @JsonKey(name: 'weight_kg')  double weightKg)?  $default,) {final _that = this;
switch (_that) {
case _WeightPointDto() when $default != null:
return $default(_that.date,_that.weightKg);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeightPointDto implements WeightPointDto {
  const _WeightPointDto({required this.date, @JsonKey(name: 'weight_kg') required this.weightKg});
  factory _WeightPointDto.fromJson(Map<String, dynamic> json) => _$WeightPointDtoFromJson(json);

@override final  String date;
@override@JsonKey(name: 'weight_kg') final  double weightKg;

/// Create a copy of WeightPointDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeightPointDtoCopyWith<_WeightPointDto> get copyWith => __$WeightPointDtoCopyWithImpl<_WeightPointDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeightPointDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeightPointDto&&(identical(other.date, date) || other.date == date)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,date,weightKg);
}

@override
String toString() {
    return 'WeightPointDto(date: $date, weightKg: $weightKg)';
}


}

/// @nodoc
abstract mixin class _$WeightPointDtoCopyWith<$Res> implements $WeightPointDtoCopyWith<$Res> {
  factory _$WeightPointDtoCopyWith(_WeightPointDto value, $Res Function(_WeightPointDto) _then) = __$WeightPointDtoCopyWithImpl;
@override @useResult
$Res call({
 String date,@JsonKey(name: 'weight_kg') double weightKg
});




}
/// @nodoc
class __$WeightPointDtoCopyWithImpl<$Res>
    implements _$WeightPointDtoCopyWith<$Res> {
  __$WeightPointDtoCopyWithImpl(this._self, this._then);

  final _WeightPointDto _self;
  final $Res Function(_WeightPointDto) _then;

/// Create a copy of WeightPointDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? weightKg = null,}) {
  return _then(_WeightPointDto(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,weightKg: null == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$WeightProgressDto {

 List<WeightPointDto> get series;@JsonKey(name: 'start_kg') double? get startKg;@JsonKey(name: 'current_kg') double? get currentKg;@JsonKey(name: 'target_kg') double? get targetKg;@JsonKey(name: 'change_kg') double? get changeKg;
/// Create a copy of WeightProgressDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeightProgressDtoCopyWith<WeightProgressDto> get copyWith => _$WeightProgressDtoCopyWithImpl<WeightProgressDto>(this as WeightProgressDto, _$identity);

  /// Serializes this WeightProgressDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WeightProgressDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeightProgressDto&&const DeepCollectionEquality().equals(other.series, _this.series)&&(identical(other.startKg, _this.startKg) || other.startKg == _this.startKg)&&(identical(other.currentKg, _this.currentKg) || other.currentKg == _this.currentKg)&&(identical(other.targetKg, _this.targetKg) || other.targetKg == _this.targetKg)&&(identical(other.changeKg, _this.changeKg) || other.changeKg == _this.changeKg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WeightProgressDto;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.series),_this.startKg,_this.currentKg,_this.targetKg,_this.changeKg);
}

@override
String toString() {
  final _this = this as WeightProgressDto;
  return 'WeightProgressDto(series: ${_this.series}, startKg: ${_this.startKg}, currentKg: ${_this.currentKg}, targetKg: ${_this.targetKg}, changeKg: ${_this.changeKg})';
}


}

/// @nodoc
abstract mixin class $WeightProgressDtoCopyWith<$Res>  {
  factory $WeightProgressDtoCopyWith(WeightProgressDto value, $Res Function(WeightProgressDto) _then) = _$WeightProgressDtoCopyWithImpl;
@useResult
$Res call({
 List<WeightPointDto> series,@JsonKey(name: 'start_kg') double? startKg,@JsonKey(name: 'current_kg') double? currentKg,@JsonKey(name: 'target_kg') double? targetKg,@JsonKey(name: 'change_kg') double? changeKg
});




}
/// @nodoc
class _$WeightProgressDtoCopyWithImpl<$Res>
    implements $WeightProgressDtoCopyWith<$Res> {
  _$WeightProgressDtoCopyWithImpl(this._self, this._then);

  final WeightProgressDto _self;
  final $Res Function(WeightProgressDto) _then;

/// Create a copy of WeightProgressDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? series = null,Object? startKg = freezed,Object? currentKg = freezed,Object? targetKg = freezed,Object? changeKg = freezed,}) {
  return _then(WeightProgressDto(
series: null == series ? _self.series : series // ignore: cast_nullable_to_non_nullable
as List<WeightPointDto>,startKg: freezed == startKg ? _self.startKg : startKg // ignore: cast_nullable_to_non_nullable
as double?,currentKg: freezed == currentKg ? _self.currentKg : currentKg // ignore: cast_nullable_to_non_nullable
as double?,targetKg: freezed == targetKg ? _self.targetKg : targetKg // ignore: cast_nullable_to_non_nullable
as double?,changeKg: freezed == changeKg ? _self.changeKg : changeKg // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [WeightProgressDto].
extension WeightProgressDtoPatterns on WeightProgressDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeightProgressDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeightProgressDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeightProgressDto value)  $default,){
final _that = this;
switch (_that) {
case _WeightProgressDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeightProgressDto value)?  $default,){
final _that = this;
switch (_that) {
case _WeightProgressDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<WeightPointDto> series, @JsonKey(name: 'start_kg')  double? startKg, @JsonKey(name: 'current_kg')  double? currentKg, @JsonKey(name: 'target_kg')  double? targetKg, @JsonKey(name: 'change_kg')  double? changeKg)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeightProgressDto() when $default != null:
return $default(_that.series,_that.startKg,_that.currentKg,_that.targetKg,_that.changeKg);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<WeightPointDto> series, @JsonKey(name: 'start_kg')  double? startKg, @JsonKey(name: 'current_kg')  double? currentKg, @JsonKey(name: 'target_kg')  double? targetKg, @JsonKey(name: 'change_kg')  double? changeKg)  $default,) {final _that = this;
switch (_that) {
case _WeightProgressDto():
return $default(_that.series,_that.startKg,_that.currentKg,_that.targetKg,_that.changeKg);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<WeightPointDto> series, @JsonKey(name: 'start_kg')  double? startKg, @JsonKey(name: 'current_kg')  double? currentKg, @JsonKey(name: 'target_kg')  double? targetKg, @JsonKey(name: 'change_kg')  double? changeKg)?  $default,) {final _that = this;
switch (_that) {
case _WeightProgressDto() when $default != null:
return $default(_that.series,_that.startKg,_that.currentKg,_that.targetKg,_that.changeKg);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeightProgressDto implements WeightProgressDto {
  const _WeightProgressDto({required  List<WeightPointDto> series, @JsonKey(name: 'start_kg') this.startKg, @JsonKey(name: 'current_kg') this.currentKg, @JsonKey(name: 'target_kg') this.targetKg, @JsonKey(name: 'change_kg') this.changeKg}): _series = series;
  factory _WeightProgressDto.fromJson(Map<String, dynamic> json) => _$WeightProgressDtoFromJson(json);

 final  List<WeightPointDto> _series;
@override List<WeightPointDto> get series {
  if (_series is EqualUnmodifiableListView) return _series;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_series);
}

@override@JsonKey(name: 'start_kg') final  double? startKg;
@override@JsonKey(name: 'current_kg') final  double? currentKg;
@override@JsonKey(name: 'target_kg') final  double? targetKg;
@override@JsonKey(name: 'change_kg') final  double? changeKg;

/// Create a copy of WeightProgressDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeightProgressDtoCopyWith<_WeightProgressDto> get copyWith => __$WeightProgressDtoCopyWithImpl<_WeightProgressDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeightProgressDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeightProgressDto&&const DeepCollectionEquality().equals(other.series, _series)&&(identical(other.startKg, startKg) || other.startKg == startKg)&&(identical(other.currentKg, currentKg) || other.currentKg == currentKg)&&(identical(other.targetKg, targetKg) || other.targetKg == targetKg)&&(identical(other.changeKg, changeKg) || other.changeKg == changeKg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_series),startKg,currentKg,targetKg,changeKg);
}

@override
String toString() {
    return 'WeightProgressDto(series: $series, startKg: $startKg, currentKg: $currentKg, targetKg: $targetKg, changeKg: $changeKg)';
}


}

/// @nodoc
abstract mixin class _$WeightProgressDtoCopyWith<$Res> implements $WeightProgressDtoCopyWith<$Res> {
  factory _$WeightProgressDtoCopyWith(_WeightProgressDto value, $Res Function(_WeightProgressDto) _then) = __$WeightProgressDtoCopyWithImpl;
@override @useResult
$Res call({
 List<WeightPointDto> series,@JsonKey(name: 'start_kg') double? startKg,@JsonKey(name: 'current_kg') double? currentKg,@JsonKey(name: 'target_kg') double? targetKg,@JsonKey(name: 'change_kg') double? changeKg
});




}
/// @nodoc
class __$WeightProgressDtoCopyWithImpl<$Res>
    implements _$WeightProgressDtoCopyWith<$Res> {
  __$WeightProgressDtoCopyWithImpl(this._self, this._then);

  final _WeightProgressDto _self;
  final $Res Function(_WeightProgressDto) _then;

/// Create a copy of WeightProgressDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? series = null,Object? startKg = freezed,Object? currentKg = freezed,Object? targetKg = freezed,Object? changeKg = freezed,}) {
  return _then(_WeightProgressDto(
series: null == series ? _self._series : series // ignore: cast_nullable_to_non_nullable
as List<WeightPointDto>,startKg: freezed == startKg ? _self.startKg : startKg // ignore: cast_nullable_to_non_nullable
as double?,currentKg: freezed == currentKg ? _self.currentKg : currentKg // ignore: cast_nullable_to_non_nullable
as double?,targetKg: freezed == targetKg ? _self.targetKg : targetKg // ignore: cast_nullable_to_non_nullable
as double?,changeKg: freezed == changeKg ? _self.changeKg : changeKg // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$CaloriesProgressDto {

 List<DailyCaloriePointDto> get daily; int get average; int get target;
/// Create a copy of CaloriesProgressDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CaloriesProgressDtoCopyWith<CaloriesProgressDto> get copyWith => _$CaloriesProgressDtoCopyWithImpl<CaloriesProgressDto>(this as CaloriesProgressDto, _$identity);

  /// Serializes this CaloriesProgressDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CaloriesProgressDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CaloriesProgressDto&&const DeepCollectionEquality().equals(other.daily, _this.daily)&&(identical(other.average, _this.average) || other.average == _this.average)&&(identical(other.target, _this.target) || other.target == _this.target));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CaloriesProgressDto;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.daily),_this.average,_this.target);
}

@override
String toString() {
  final _this = this as CaloriesProgressDto;
  return 'CaloriesProgressDto(daily: ${_this.daily}, average: ${_this.average}, target: ${_this.target})';
}


}

/// @nodoc
abstract mixin class $CaloriesProgressDtoCopyWith<$Res>  {
  factory $CaloriesProgressDtoCopyWith(CaloriesProgressDto value, $Res Function(CaloriesProgressDto) _then) = _$CaloriesProgressDtoCopyWithImpl;
@useResult
$Res call({
 List<DailyCaloriePointDto> daily, int average, int target
});




}
/// @nodoc
class _$CaloriesProgressDtoCopyWithImpl<$Res>
    implements $CaloriesProgressDtoCopyWith<$Res> {
  _$CaloriesProgressDtoCopyWithImpl(this._self, this._then);

  final CaloriesProgressDto _self;
  final $Res Function(CaloriesProgressDto) _then;

/// Create a copy of CaloriesProgressDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? daily = null,Object? average = null,Object? target = null,}) {
  return _then(CaloriesProgressDto(
daily: null == daily ? _self.daily : daily // ignore: cast_nullable_to_non_nullable
as List<DailyCaloriePointDto>,average: null == average ? _self.average : average // ignore: cast_nullable_to_non_nullable
as int,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CaloriesProgressDto].
extension CaloriesProgressDtoPatterns on CaloriesProgressDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CaloriesProgressDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CaloriesProgressDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CaloriesProgressDto value)  $default,){
final _that = this;
switch (_that) {
case _CaloriesProgressDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CaloriesProgressDto value)?  $default,){
final _that = this;
switch (_that) {
case _CaloriesProgressDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<DailyCaloriePointDto> daily,  int average,  int target)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CaloriesProgressDto() when $default != null:
return $default(_that.daily,_that.average,_that.target);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<DailyCaloriePointDto> daily,  int average,  int target)  $default,) {final _that = this;
switch (_that) {
case _CaloriesProgressDto():
return $default(_that.daily,_that.average,_that.target);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<DailyCaloriePointDto> daily,  int average,  int target)?  $default,) {final _that = this;
switch (_that) {
case _CaloriesProgressDto() when $default != null:
return $default(_that.daily,_that.average,_that.target);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CaloriesProgressDto implements CaloriesProgressDto {
  const _CaloriesProgressDto({required  List<DailyCaloriePointDto> daily, required this.average, required this.target}): _daily = daily;
  factory _CaloriesProgressDto.fromJson(Map<String, dynamic> json) => _$CaloriesProgressDtoFromJson(json);

 final  List<DailyCaloriePointDto> _daily;
@override List<DailyCaloriePointDto> get daily {
  if (_daily is EqualUnmodifiableListView) return _daily;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_daily);
}

@override final  int average;
@override final  int target;

/// Create a copy of CaloriesProgressDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CaloriesProgressDtoCopyWith<_CaloriesProgressDto> get copyWith => __$CaloriesProgressDtoCopyWithImpl<_CaloriesProgressDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CaloriesProgressDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CaloriesProgressDto&&const DeepCollectionEquality().equals(other.daily, _daily)&&(identical(other.average, average) || other.average == average)&&(identical(other.target, target) || other.target == target));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_daily),average,target);
}

@override
String toString() {
    return 'CaloriesProgressDto(daily: $daily, average: $average, target: $target)';
}


}

/// @nodoc
abstract mixin class _$CaloriesProgressDtoCopyWith<$Res> implements $CaloriesProgressDtoCopyWith<$Res> {
  factory _$CaloriesProgressDtoCopyWith(_CaloriesProgressDto value, $Res Function(_CaloriesProgressDto) _then) = __$CaloriesProgressDtoCopyWithImpl;
@override @useResult
$Res call({
 List<DailyCaloriePointDto> daily, int average, int target
});




}
/// @nodoc
class __$CaloriesProgressDtoCopyWithImpl<$Res>
    implements _$CaloriesProgressDtoCopyWith<$Res> {
  __$CaloriesProgressDtoCopyWithImpl(this._self, this._then);

  final _CaloriesProgressDto _self;
  final $Res Function(_CaloriesProgressDto) _then;

/// Create a copy of CaloriesProgressDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? daily = null,Object? average = null,Object? target = null,}) {
  return _then(_CaloriesProgressDto(
daily: null == daily ? _self._daily : daily // ignore: cast_nullable_to_non_nullable
as List<DailyCaloriePointDto>,average: null == average ? _self.average : average // ignore: cast_nullable_to_non_nullable
as int,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ProgressDto {

 String get range; String get start; String get end; CaloriesProgressDto get calories; MacroProgressDto get macros; WeightProgressDto get weight;@JsonKey(name: 'meals_tracked') int get mealsTracked;@JsonKey(name: 'days_on_target') int get daysOnTarget;@JsonKey(name: 'active_days') int get activeDays; int get streak;
/// Create a copy of ProgressDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgressDtoCopyWith<ProgressDto> get copyWith => _$ProgressDtoCopyWithImpl<ProgressDto>(this as ProgressDto, _$identity);

  /// Serializes this ProgressDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProgressDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgressDto&&(identical(other.range, _this.range) || other.range == _this.range)&&(identical(other.start, _this.start) || other.start == _this.start)&&(identical(other.end, _this.end) || other.end == _this.end)&&(identical(other.calories, _this.calories) || other.calories == _this.calories)&&(identical(other.macros, _this.macros) || other.macros == _this.macros)&&(identical(other.weight, _this.weight) || other.weight == _this.weight)&&(identical(other.mealsTracked, _this.mealsTracked) || other.mealsTracked == _this.mealsTracked)&&(identical(other.daysOnTarget, _this.daysOnTarget) || other.daysOnTarget == _this.daysOnTarget)&&(identical(other.activeDays, _this.activeDays) || other.activeDays == _this.activeDays)&&(identical(other.streak, _this.streak) || other.streak == _this.streak));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProgressDto;
  return Object.hash(runtimeType,_this.range,_this.start,_this.end,_this.calories,_this.macros,_this.weight,_this.mealsTracked,_this.daysOnTarget,_this.activeDays,_this.streak);
}

@override
String toString() {
  final _this = this as ProgressDto;
  return 'ProgressDto(range: ${_this.range}, start: ${_this.start}, end: ${_this.end}, calories: ${_this.calories}, macros: ${_this.macros}, weight: ${_this.weight}, mealsTracked: ${_this.mealsTracked}, daysOnTarget: ${_this.daysOnTarget}, activeDays: ${_this.activeDays}, streak: ${_this.streak})';
}


}

/// @nodoc
abstract mixin class $ProgressDtoCopyWith<$Res>  {
  factory $ProgressDtoCopyWith(ProgressDto value, $Res Function(ProgressDto) _then) = _$ProgressDtoCopyWithImpl;
@useResult
$Res call({
 String range, String start, String end, CaloriesProgressDto calories, MacroProgressDto macros, WeightProgressDto weight,@JsonKey(name: 'meals_tracked') int mealsTracked,@JsonKey(name: 'days_on_target') int daysOnTarget,@JsonKey(name: 'active_days') int activeDays, int streak
});


$CaloriesProgressDtoCopyWith<$Res> get calories;$MacroProgressDtoCopyWith<$Res> get macros;$WeightProgressDtoCopyWith<$Res> get weight;

}
/// @nodoc
class _$ProgressDtoCopyWithImpl<$Res>
    implements $ProgressDtoCopyWith<$Res> {
  _$ProgressDtoCopyWithImpl(this._self, this._then);

  final ProgressDto _self;
  final $Res Function(ProgressDto) _then;

/// Create a copy of ProgressDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? range = null,Object? start = null,Object? end = null,Object? calories = null,Object? macros = null,Object? weight = null,Object? mealsTracked = null,Object? daysOnTarget = null,Object? activeDays = null,Object? streak = null,}) {
  return _then(ProgressDto(
range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as String,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as String,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as String,calories: null == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as CaloriesProgressDto,macros: null == macros ? _self.macros : macros // ignore: cast_nullable_to_non_nullable
as MacroProgressDto,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as WeightProgressDto,mealsTracked: null == mealsTracked ? _self.mealsTracked : mealsTracked // ignore: cast_nullable_to_non_nullable
as int,daysOnTarget: null == daysOnTarget ? _self.daysOnTarget : daysOnTarget // ignore: cast_nullable_to_non_nullable
as int,activeDays: null == activeDays ? _self.activeDays : activeDays // ignore: cast_nullable_to_non_nullable
as int,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of ProgressDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CaloriesProgressDtoCopyWith<$Res> get calories {
  
  return $CaloriesProgressDtoCopyWith<$Res>(_self.calories, (value) {
    return _then(_self.copyWith(calories: value));
  });
}/// Create a copy of ProgressDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MacroProgressDtoCopyWith<$Res> get macros {
  
  return $MacroProgressDtoCopyWith<$Res>(_self.macros, (value) {
    return _then(_self.copyWith(macros: value));
  });
}/// Create a copy of ProgressDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeightProgressDtoCopyWith<$Res> get weight {
  
  return $WeightProgressDtoCopyWith<$Res>(_self.weight, (value) {
    return _then(_self.copyWith(weight: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProgressDto].
extension ProgressDtoPatterns on ProgressDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProgressDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProgressDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProgressDto value)  $default,){
final _that = this;
switch (_that) {
case _ProgressDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProgressDto value)?  $default,){
final _that = this;
switch (_that) {
case _ProgressDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String range,  String start,  String end,  CaloriesProgressDto calories,  MacroProgressDto macros,  WeightProgressDto weight, @JsonKey(name: 'meals_tracked')  int mealsTracked, @JsonKey(name: 'days_on_target')  int daysOnTarget, @JsonKey(name: 'active_days')  int activeDays,  int streak)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProgressDto() when $default != null:
return $default(_that.range,_that.start,_that.end,_that.calories,_that.macros,_that.weight,_that.mealsTracked,_that.daysOnTarget,_that.activeDays,_that.streak);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String range,  String start,  String end,  CaloriesProgressDto calories,  MacroProgressDto macros,  WeightProgressDto weight, @JsonKey(name: 'meals_tracked')  int mealsTracked, @JsonKey(name: 'days_on_target')  int daysOnTarget, @JsonKey(name: 'active_days')  int activeDays,  int streak)  $default,) {final _that = this;
switch (_that) {
case _ProgressDto():
return $default(_that.range,_that.start,_that.end,_that.calories,_that.macros,_that.weight,_that.mealsTracked,_that.daysOnTarget,_that.activeDays,_that.streak);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String range,  String start,  String end,  CaloriesProgressDto calories,  MacroProgressDto macros,  WeightProgressDto weight, @JsonKey(name: 'meals_tracked')  int mealsTracked, @JsonKey(name: 'days_on_target')  int daysOnTarget, @JsonKey(name: 'active_days')  int activeDays,  int streak)?  $default,) {final _that = this;
switch (_that) {
case _ProgressDto() when $default != null:
return $default(_that.range,_that.start,_that.end,_that.calories,_that.macros,_that.weight,_that.mealsTracked,_that.daysOnTarget,_that.activeDays,_that.streak);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProgressDto implements ProgressDto {
  const _ProgressDto({required this.range, required this.start, required this.end, required this.calories, required this.macros, required this.weight, @JsonKey(name: 'meals_tracked') required this.mealsTracked, @JsonKey(name: 'days_on_target') required this.daysOnTarget, @JsonKey(name: 'active_days') required this.activeDays, required this.streak});
  factory _ProgressDto.fromJson(Map<String, dynamic> json) => _$ProgressDtoFromJson(json);

@override final  String range;
@override final  String start;
@override final  String end;
@override final  CaloriesProgressDto calories;
@override final  MacroProgressDto macros;
@override final  WeightProgressDto weight;
@override@JsonKey(name: 'meals_tracked') final  int mealsTracked;
@override@JsonKey(name: 'days_on_target') final  int daysOnTarget;
@override@JsonKey(name: 'active_days') final  int activeDays;
@override final  int streak;

/// Create a copy of ProgressDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgressDtoCopyWith<_ProgressDto> get copyWith => __$ProgressDtoCopyWithImpl<_ProgressDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProgressDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProgressDto&&(identical(other.range, range) || other.range == range)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.calories, calories) || other.calories == calories)&&(identical(other.macros, macros) || other.macros == macros)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.mealsTracked, mealsTracked) || other.mealsTracked == mealsTracked)&&(identical(other.daysOnTarget, daysOnTarget) || other.daysOnTarget == daysOnTarget)&&(identical(other.activeDays, activeDays) || other.activeDays == activeDays)&&(identical(other.streak, streak) || other.streak == streak));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,range,start,end,calories,macros,weight,mealsTracked,daysOnTarget,activeDays,streak);
}

@override
String toString() {
    return 'ProgressDto(range: $range, start: $start, end: $end, calories: $calories, macros: $macros, weight: $weight, mealsTracked: $mealsTracked, daysOnTarget: $daysOnTarget, activeDays: $activeDays, streak: $streak)';
}


}

/// @nodoc
abstract mixin class _$ProgressDtoCopyWith<$Res> implements $ProgressDtoCopyWith<$Res> {
  factory _$ProgressDtoCopyWith(_ProgressDto value, $Res Function(_ProgressDto) _then) = __$ProgressDtoCopyWithImpl;
@override @useResult
$Res call({
 String range, String start, String end, CaloriesProgressDto calories, MacroProgressDto macros, WeightProgressDto weight,@JsonKey(name: 'meals_tracked') int mealsTracked,@JsonKey(name: 'days_on_target') int daysOnTarget,@JsonKey(name: 'active_days') int activeDays, int streak
});


@override $CaloriesProgressDtoCopyWith<$Res> get calories;@override $MacroProgressDtoCopyWith<$Res> get macros;@override $WeightProgressDtoCopyWith<$Res> get weight;

}
/// @nodoc
class __$ProgressDtoCopyWithImpl<$Res>
    implements _$ProgressDtoCopyWith<$Res> {
  __$ProgressDtoCopyWithImpl(this._self, this._then);

  final _ProgressDto _self;
  final $Res Function(_ProgressDto) _then;

/// Create a copy of ProgressDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? range = null,Object? start = null,Object? end = null,Object? calories = null,Object? macros = null,Object? weight = null,Object? mealsTracked = null,Object? daysOnTarget = null,Object? activeDays = null,Object? streak = null,}) {
  return _then(_ProgressDto(
range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as String,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as String,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as String,calories: null == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as CaloriesProgressDto,macros: null == macros ? _self.macros : macros // ignore: cast_nullable_to_non_nullable
as MacroProgressDto,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as WeightProgressDto,mealsTracked: null == mealsTracked ? _self.mealsTracked : mealsTracked // ignore: cast_nullable_to_non_nullable
as int,daysOnTarget: null == daysOnTarget ? _self.daysOnTarget : daysOnTarget // ignore: cast_nullable_to_non_nullable
as int,activeDays: null == activeDays ? _self.activeDays : activeDays // ignore: cast_nullable_to_non_nullable
as int,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of ProgressDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CaloriesProgressDtoCopyWith<$Res> get calories {
  
  return $CaloriesProgressDtoCopyWith<$Res>(_self.calories, (value) {
    return _then(_self.copyWith(calories: value));
  });
}/// Create a copy of ProgressDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MacroProgressDtoCopyWith<$Res> get macros {
  
  return $MacroProgressDtoCopyWith<$Res>(_self.macros, (value) {
    return _then(_self.copyWith(macros: value));
  });
}/// Create a copy of ProgressDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeightProgressDtoCopyWith<$Res> get weight {
  
  return $WeightProgressDtoCopyWith<$Res>(_self.weight, (value) {
    return _then(_self.copyWith(weight: value));
  });
}
}


/// @nodoc
mixin _$DailySummaryPointDto {

 String get date; int get calories; double get protein; double get carbs; double get fat; double get fiber;@JsonKey(name: 'water_ml') int get waterMl;@JsonKey(name: 'meals_count') int get mealsCount;
/// Create a copy of DailySummaryPointDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailySummaryPointDtoCopyWith<DailySummaryPointDto> get copyWith => _$DailySummaryPointDtoCopyWithImpl<DailySummaryPointDto>(this as DailySummaryPointDto, _$identity);

  /// Serializes this DailySummaryPointDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DailySummaryPointDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailySummaryPointDto&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.calories, _this.calories) || other.calories == _this.calories)&&(identical(other.protein, _this.protein) || other.protein == _this.protein)&&(identical(other.carbs, _this.carbs) || other.carbs == _this.carbs)&&(identical(other.fat, _this.fat) || other.fat == _this.fat)&&(identical(other.fiber, _this.fiber) || other.fiber == _this.fiber)&&(identical(other.waterMl, _this.waterMl) || other.waterMl == _this.waterMl)&&(identical(other.mealsCount, _this.mealsCount) || other.mealsCount == _this.mealsCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DailySummaryPointDto;
  return Object.hash(runtimeType,_this.date,_this.calories,_this.protein,_this.carbs,_this.fat,_this.fiber,_this.waterMl,_this.mealsCount);
}

@override
String toString() {
  final _this = this as DailySummaryPointDto;
  return 'DailySummaryPointDto(date: ${_this.date}, calories: ${_this.calories}, protein: ${_this.protein}, carbs: ${_this.carbs}, fat: ${_this.fat}, fiber: ${_this.fiber}, waterMl: ${_this.waterMl}, mealsCount: ${_this.mealsCount})';
}


}

/// @nodoc
abstract mixin class $DailySummaryPointDtoCopyWith<$Res>  {
  factory $DailySummaryPointDtoCopyWith(DailySummaryPointDto value, $Res Function(DailySummaryPointDto) _then) = _$DailySummaryPointDtoCopyWithImpl;
@useResult
$Res call({
 String date, int calories, double protein, double carbs, double fat, double fiber,@JsonKey(name: 'water_ml') int waterMl,@JsonKey(name: 'meals_count') int mealsCount
});




}
/// @nodoc
class _$DailySummaryPointDtoCopyWithImpl<$Res>
    implements $DailySummaryPointDtoCopyWith<$Res> {
  _$DailySummaryPointDtoCopyWithImpl(this._self, this._then);

  final DailySummaryPointDto _self;
  final $Res Function(DailySummaryPointDto) _then;

/// Create a copy of DailySummaryPointDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? calories = null,Object? protein = null,Object? carbs = null,Object? fat = null,Object? fiber = null,Object? waterMl = null,Object? mealsCount = null,}) {
  return _then(DailySummaryPointDto(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,calories: null == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as int,protein: null == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as double,carbs: null == carbs ? _self.carbs : carbs // ignore: cast_nullable_to_non_nullable
as double,fat: null == fat ? _self.fat : fat // ignore: cast_nullable_to_non_nullable
as double,fiber: null == fiber ? _self.fiber : fiber // ignore: cast_nullable_to_non_nullable
as double,waterMl: null == waterMl ? _self.waterMl : waterMl // ignore: cast_nullable_to_non_nullable
as int,mealsCount: null == mealsCount ? _self.mealsCount : mealsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DailySummaryPointDto].
extension DailySummaryPointDtoPatterns on DailySummaryPointDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailySummaryPointDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailySummaryPointDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailySummaryPointDto value)  $default,){
final _that = this;
switch (_that) {
case _DailySummaryPointDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailySummaryPointDto value)?  $default,){
final _that = this;
switch (_that) {
case _DailySummaryPointDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  int calories,  double protein,  double carbs,  double fat,  double fiber, @JsonKey(name: 'water_ml')  int waterMl, @JsonKey(name: 'meals_count')  int mealsCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailySummaryPointDto() when $default != null:
return $default(_that.date,_that.calories,_that.protein,_that.carbs,_that.fat,_that.fiber,_that.waterMl,_that.mealsCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  int calories,  double protein,  double carbs,  double fat,  double fiber, @JsonKey(name: 'water_ml')  int waterMl, @JsonKey(name: 'meals_count')  int mealsCount)  $default,) {final _that = this;
switch (_that) {
case _DailySummaryPointDto():
return $default(_that.date,_that.calories,_that.protein,_that.carbs,_that.fat,_that.fiber,_that.waterMl,_that.mealsCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  int calories,  double protein,  double carbs,  double fat,  double fiber, @JsonKey(name: 'water_ml')  int waterMl, @JsonKey(name: 'meals_count')  int mealsCount)?  $default,) {final _that = this;
switch (_that) {
case _DailySummaryPointDto() when $default != null:
return $default(_that.date,_that.calories,_that.protein,_that.carbs,_that.fat,_that.fiber,_that.waterMl,_that.mealsCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailySummaryPointDto implements DailySummaryPointDto {
  const _DailySummaryPointDto({required this.date, required this.calories, required this.protein, required this.carbs, required this.fat, required this.fiber, @JsonKey(name: 'water_ml') required this.waterMl, @JsonKey(name: 'meals_count') required this.mealsCount});
  factory _DailySummaryPointDto.fromJson(Map<String, dynamic> json) => _$DailySummaryPointDtoFromJson(json);

@override final  String date;
@override final  int calories;
@override final  double protein;
@override final  double carbs;
@override final  double fat;
@override final  double fiber;
@override@JsonKey(name: 'water_ml') final  int waterMl;
@override@JsonKey(name: 'meals_count') final  int mealsCount;

/// Create a copy of DailySummaryPointDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailySummaryPointDtoCopyWith<_DailySummaryPointDto> get copyWith => __$DailySummaryPointDtoCopyWithImpl<_DailySummaryPointDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailySummaryPointDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailySummaryPointDto&&(identical(other.date, date) || other.date == date)&&(identical(other.calories, calories) || other.calories == calories)&&(identical(other.protein, protein) || other.protein == protein)&&(identical(other.carbs, carbs) || other.carbs == carbs)&&(identical(other.fat, fat) || other.fat == fat)&&(identical(other.fiber, fiber) || other.fiber == fiber)&&(identical(other.waterMl, waterMl) || other.waterMl == waterMl)&&(identical(other.mealsCount, mealsCount) || other.mealsCount == mealsCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,date,calories,protein,carbs,fat,fiber,waterMl,mealsCount);
}

@override
String toString() {
    return 'DailySummaryPointDto(date: $date, calories: $calories, protein: $protein, carbs: $carbs, fat: $fat, fiber: $fiber, waterMl: $waterMl, mealsCount: $mealsCount)';
}


}

/// @nodoc
abstract mixin class _$DailySummaryPointDtoCopyWith<$Res> implements $DailySummaryPointDtoCopyWith<$Res> {
  factory _$DailySummaryPointDtoCopyWith(_DailySummaryPointDto value, $Res Function(_DailySummaryPointDto) _then) = __$DailySummaryPointDtoCopyWithImpl;
@override @useResult
$Res call({
 String date, int calories, double protein, double carbs, double fat, double fiber,@JsonKey(name: 'water_ml') int waterMl,@JsonKey(name: 'meals_count') int mealsCount
});




}
/// @nodoc
class __$DailySummaryPointDtoCopyWithImpl<$Res>
    implements _$DailySummaryPointDtoCopyWith<$Res> {
  __$DailySummaryPointDtoCopyWithImpl(this._self, this._then);

  final _DailySummaryPointDto _self;
  final $Res Function(_DailySummaryPointDto) _then;

/// Create a copy of DailySummaryPointDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? calories = null,Object? protein = null,Object? carbs = null,Object? fat = null,Object? fiber = null,Object? waterMl = null,Object? mealsCount = null,}) {
  return _then(_DailySummaryPointDto(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,calories: null == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as int,protein: null == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as double,carbs: null == carbs ? _self.carbs : carbs // ignore: cast_nullable_to_non_nullable
as double,fat: null == fat ? _self.fat : fat // ignore: cast_nullable_to_non_nullable
as double,fiber: null == fiber ? _self.fiber : fiber // ignore: cast_nullable_to_non_nullable
as double,waterMl: null == waterMl ? _self.waterMl : waterMl // ignore: cast_nullable_to_non_nullable
as int,mealsCount: null == mealsCount ? _self.mealsCount : mealsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$WeeklyProgressDto {

@JsonKey(name: 'week_start') String get weekStart;@JsonKey(name: 'week_end') String get weekEnd; List<DailySummaryPointDto> get days; MacroAveragesDto get totals; MacroAveragesDto get averages;@JsonKey(name: 'calorie_target') int get calorieTarget;
/// Create a copy of WeeklyProgressDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeeklyProgressDtoCopyWith<WeeklyProgressDto> get copyWith => _$WeeklyProgressDtoCopyWithImpl<WeeklyProgressDto>(this as WeeklyProgressDto, _$identity);

  /// Serializes this WeeklyProgressDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WeeklyProgressDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeeklyProgressDto&&(identical(other.weekStart, _this.weekStart) || other.weekStart == _this.weekStart)&&(identical(other.weekEnd, _this.weekEnd) || other.weekEnd == _this.weekEnd)&&const DeepCollectionEquality().equals(other.days, _this.days)&&(identical(other.totals, _this.totals) || other.totals == _this.totals)&&(identical(other.averages, _this.averages) || other.averages == _this.averages)&&(identical(other.calorieTarget, _this.calorieTarget) || other.calorieTarget == _this.calorieTarget));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WeeklyProgressDto;
  return Object.hash(runtimeType,_this.weekStart,_this.weekEnd,const DeepCollectionEquality().hash(_this.days),_this.totals,_this.averages,_this.calorieTarget);
}

@override
String toString() {
  final _this = this as WeeklyProgressDto;
  return 'WeeklyProgressDto(weekStart: ${_this.weekStart}, weekEnd: ${_this.weekEnd}, days: ${_this.days}, totals: ${_this.totals}, averages: ${_this.averages}, calorieTarget: ${_this.calorieTarget})';
}


}

/// @nodoc
abstract mixin class $WeeklyProgressDtoCopyWith<$Res>  {
  factory $WeeklyProgressDtoCopyWith(WeeklyProgressDto value, $Res Function(WeeklyProgressDto) _then) = _$WeeklyProgressDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'week_start') String weekStart,@JsonKey(name: 'week_end') String weekEnd, List<DailySummaryPointDto> days, MacroAveragesDto totals, MacroAveragesDto averages,@JsonKey(name: 'calorie_target') int calorieTarget
});


$MacroAveragesDtoCopyWith<$Res> get totals;$MacroAveragesDtoCopyWith<$Res> get averages;

}
/// @nodoc
class _$WeeklyProgressDtoCopyWithImpl<$Res>
    implements $WeeklyProgressDtoCopyWith<$Res> {
  _$WeeklyProgressDtoCopyWithImpl(this._self, this._then);

  final WeeklyProgressDto _self;
  final $Res Function(WeeklyProgressDto) _then;

/// Create a copy of WeeklyProgressDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weekStart = null,Object? weekEnd = null,Object? days = null,Object? totals = null,Object? averages = null,Object? calorieTarget = null,}) {
  return _then(WeeklyProgressDto(
weekStart: null == weekStart ? _self.weekStart : weekStart // ignore: cast_nullable_to_non_nullable
as String,weekEnd: null == weekEnd ? _self.weekEnd : weekEnd // ignore: cast_nullable_to_non_nullable
as String,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as List<DailySummaryPointDto>,totals: null == totals ? _self.totals : totals // ignore: cast_nullable_to_non_nullable
as MacroAveragesDto,averages: null == averages ? _self.averages : averages // ignore: cast_nullable_to_non_nullable
as MacroAveragesDto,calorieTarget: null == calorieTarget ? _self.calorieTarget : calorieTarget // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of WeeklyProgressDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MacroAveragesDtoCopyWith<$Res> get totals {
  
  return $MacroAveragesDtoCopyWith<$Res>(_self.totals, (value) {
    return _then(_self.copyWith(totals: value));
  });
}/// Create a copy of WeeklyProgressDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MacroAveragesDtoCopyWith<$Res> get averages {
  
  return $MacroAveragesDtoCopyWith<$Res>(_self.averages, (value) {
    return _then(_self.copyWith(averages: value));
  });
}
}


/// Adds pattern-matching-related methods to [WeeklyProgressDto].
extension WeeklyProgressDtoPatterns on WeeklyProgressDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeeklyProgressDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeeklyProgressDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeeklyProgressDto value)  $default,){
final _that = this;
switch (_that) {
case _WeeklyProgressDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeeklyProgressDto value)?  $default,){
final _that = this;
switch (_that) {
case _WeeklyProgressDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'week_start')  String weekStart, @JsonKey(name: 'week_end')  String weekEnd,  List<DailySummaryPointDto> days,  MacroAveragesDto totals,  MacroAveragesDto averages, @JsonKey(name: 'calorie_target')  int calorieTarget)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeeklyProgressDto() when $default != null:
return $default(_that.weekStart,_that.weekEnd,_that.days,_that.totals,_that.averages,_that.calorieTarget);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'week_start')  String weekStart, @JsonKey(name: 'week_end')  String weekEnd,  List<DailySummaryPointDto> days,  MacroAveragesDto totals,  MacroAveragesDto averages, @JsonKey(name: 'calorie_target')  int calorieTarget)  $default,) {final _that = this;
switch (_that) {
case _WeeklyProgressDto():
return $default(_that.weekStart,_that.weekEnd,_that.days,_that.totals,_that.averages,_that.calorieTarget);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'week_start')  String weekStart, @JsonKey(name: 'week_end')  String weekEnd,  List<DailySummaryPointDto> days,  MacroAveragesDto totals,  MacroAveragesDto averages, @JsonKey(name: 'calorie_target')  int calorieTarget)?  $default,) {final _that = this;
switch (_that) {
case _WeeklyProgressDto() when $default != null:
return $default(_that.weekStart,_that.weekEnd,_that.days,_that.totals,_that.averages,_that.calorieTarget);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeeklyProgressDto implements WeeklyProgressDto {
  const _WeeklyProgressDto({@JsonKey(name: 'week_start') required this.weekStart, @JsonKey(name: 'week_end') required this.weekEnd, required  List<DailySummaryPointDto> days, required this.totals, required this.averages, @JsonKey(name: 'calorie_target') required this.calorieTarget}): _days = days;
  factory _WeeklyProgressDto.fromJson(Map<String, dynamic> json) => _$WeeklyProgressDtoFromJson(json);

@override@JsonKey(name: 'week_start') final  String weekStart;
@override@JsonKey(name: 'week_end') final  String weekEnd;
 final  List<DailySummaryPointDto> _days;
@override List<DailySummaryPointDto> get days {
  if (_days is EqualUnmodifiableListView) return _days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_days);
}

@override final  MacroAveragesDto totals;
@override final  MacroAveragesDto averages;
@override@JsonKey(name: 'calorie_target') final  int calorieTarget;

/// Create a copy of WeeklyProgressDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeeklyProgressDtoCopyWith<_WeeklyProgressDto> get copyWith => __$WeeklyProgressDtoCopyWithImpl<_WeeklyProgressDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeeklyProgressDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeeklyProgressDto&&(identical(other.weekStart, weekStart) || other.weekStart == weekStart)&&(identical(other.weekEnd, weekEnd) || other.weekEnd == weekEnd)&&const DeepCollectionEquality().equals(other.days, _days)&&(identical(other.totals, totals) || other.totals == totals)&&(identical(other.averages, averages) || other.averages == averages)&&(identical(other.calorieTarget, calorieTarget) || other.calorieTarget == calorieTarget));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,weekStart,weekEnd,const DeepCollectionEquality().hash(_days),totals,averages,calorieTarget);
}

@override
String toString() {
    return 'WeeklyProgressDto(weekStart: $weekStart, weekEnd: $weekEnd, days: $days, totals: $totals, averages: $averages, calorieTarget: $calorieTarget)';
}


}

/// @nodoc
abstract mixin class _$WeeklyProgressDtoCopyWith<$Res> implements $WeeklyProgressDtoCopyWith<$Res> {
  factory _$WeeklyProgressDtoCopyWith(_WeeklyProgressDto value, $Res Function(_WeeklyProgressDto) _then) = __$WeeklyProgressDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'week_start') String weekStart,@JsonKey(name: 'week_end') String weekEnd, List<DailySummaryPointDto> days, MacroAveragesDto totals, MacroAveragesDto averages,@JsonKey(name: 'calorie_target') int calorieTarget
});


@override $MacroAveragesDtoCopyWith<$Res> get totals;@override $MacroAveragesDtoCopyWith<$Res> get averages;

}
/// @nodoc
class __$WeeklyProgressDtoCopyWithImpl<$Res>
    implements _$WeeklyProgressDtoCopyWith<$Res> {
  __$WeeklyProgressDtoCopyWithImpl(this._self, this._then);

  final _WeeklyProgressDto _self;
  final $Res Function(_WeeklyProgressDto) _then;

/// Create a copy of WeeklyProgressDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weekStart = null,Object? weekEnd = null,Object? days = null,Object? totals = null,Object? averages = null,Object? calorieTarget = null,}) {
  return _then(_WeeklyProgressDto(
weekStart: null == weekStart ? _self.weekStart : weekStart // ignore: cast_nullable_to_non_nullable
as String,weekEnd: null == weekEnd ? _self.weekEnd : weekEnd // ignore: cast_nullable_to_non_nullable
as String,days: null == days ? _self._days : days // ignore: cast_nullable_to_non_nullable
as List<DailySummaryPointDto>,totals: null == totals ? _self.totals : totals // ignore: cast_nullable_to_non_nullable
as MacroAveragesDto,averages: null == averages ? _self.averages : averages // ignore: cast_nullable_to_non_nullable
as MacroAveragesDto,calorieTarget: null == calorieTarget ? _self.calorieTarget : calorieTarget // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of WeeklyProgressDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MacroAveragesDtoCopyWith<$Res> get totals {
  
  return $MacroAveragesDtoCopyWith<$Res>(_self.totals, (value) {
    return _then(_self.copyWith(totals: value));
  });
}/// Create a copy of WeeklyProgressDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MacroAveragesDtoCopyWith<$Res> get averages {
  
  return $MacroAveragesDtoCopyWith<$Res>(_self.averages, (value) {
    return _then(_self.copyWith(averages: value));
  });
}
}


/// @nodoc
mixin _$MonthlyProgressDto {

 int get year; int get month; List<DailySummaryPointDto> get days; MacroAveragesDto get averages;@JsonKey(name: 'calorie_target') int get calorieTarget;@JsonKey(name: 'days_on_target') int get daysOnTarget;@JsonKey(name: 'active_days') int get activeDays;
/// Create a copy of MonthlyProgressDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthlyProgressDtoCopyWith<MonthlyProgressDto> get copyWith => _$MonthlyProgressDtoCopyWithImpl<MonthlyProgressDto>(this as MonthlyProgressDto, _$identity);

  /// Serializes this MonthlyProgressDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MonthlyProgressDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthlyProgressDto&&(identical(other.year, _this.year) || other.year == _this.year)&&(identical(other.month, _this.month) || other.month == _this.month)&&const DeepCollectionEquality().equals(other.days, _this.days)&&(identical(other.averages, _this.averages) || other.averages == _this.averages)&&(identical(other.calorieTarget, _this.calorieTarget) || other.calorieTarget == _this.calorieTarget)&&(identical(other.daysOnTarget, _this.daysOnTarget) || other.daysOnTarget == _this.daysOnTarget)&&(identical(other.activeDays, _this.activeDays) || other.activeDays == _this.activeDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MonthlyProgressDto;
  return Object.hash(runtimeType,_this.year,_this.month,const DeepCollectionEquality().hash(_this.days),_this.averages,_this.calorieTarget,_this.daysOnTarget,_this.activeDays);
}

@override
String toString() {
  final _this = this as MonthlyProgressDto;
  return 'MonthlyProgressDto(year: ${_this.year}, month: ${_this.month}, days: ${_this.days}, averages: ${_this.averages}, calorieTarget: ${_this.calorieTarget}, daysOnTarget: ${_this.daysOnTarget}, activeDays: ${_this.activeDays})';
}


}

/// @nodoc
abstract mixin class $MonthlyProgressDtoCopyWith<$Res>  {
  factory $MonthlyProgressDtoCopyWith(MonthlyProgressDto value, $Res Function(MonthlyProgressDto) _then) = _$MonthlyProgressDtoCopyWithImpl;
@useResult
$Res call({
 int year, int month, List<DailySummaryPointDto> days, MacroAveragesDto averages,@JsonKey(name: 'calorie_target') int calorieTarget,@JsonKey(name: 'days_on_target') int daysOnTarget,@JsonKey(name: 'active_days') int activeDays
});


$MacroAveragesDtoCopyWith<$Res> get averages;

}
/// @nodoc
class _$MonthlyProgressDtoCopyWithImpl<$Res>
    implements $MonthlyProgressDtoCopyWith<$Res> {
  _$MonthlyProgressDtoCopyWithImpl(this._self, this._then);

  final MonthlyProgressDto _self;
  final $Res Function(MonthlyProgressDto) _then;

/// Create a copy of MonthlyProgressDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? year = null,Object? month = null,Object? days = null,Object? averages = null,Object? calorieTarget = null,Object? daysOnTarget = null,Object? activeDays = null,}) {
  return _then(MonthlyProgressDto(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as List<DailySummaryPointDto>,averages: null == averages ? _self.averages : averages // ignore: cast_nullable_to_non_nullable
as MacroAveragesDto,calorieTarget: null == calorieTarget ? _self.calorieTarget : calorieTarget // ignore: cast_nullable_to_non_nullable
as int,daysOnTarget: null == daysOnTarget ? _self.daysOnTarget : daysOnTarget // ignore: cast_nullable_to_non_nullable
as int,activeDays: null == activeDays ? _self.activeDays : activeDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of MonthlyProgressDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MacroAveragesDtoCopyWith<$Res> get averages {
  
  return $MacroAveragesDtoCopyWith<$Res>(_self.averages, (value) {
    return _then(_self.copyWith(averages: value));
  });
}
}


/// Adds pattern-matching-related methods to [MonthlyProgressDto].
extension MonthlyProgressDtoPatterns on MonthlyProgressDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthlyProgressDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthlyProgressDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthlyProgressDto value)  $default,){
final _that = this;
switch (_that) {
case _MonthlyProgressDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthlyProgressDto value)?  $default,){
final _that = this;
switch (_that) {
case _MonthlyProgressDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int year,  int month,  List<DailySummaryPointDto> days,  MacroAveragesDto averages, @JsonKey(name: 'calorie_target')  int calorieTarget, @JsonKey(name: 'days_on_target')  int daysOnTarget, @JsonKey(name: 'active_days')  int activeDays)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthlyProgressDto() when $default != null:
return $default(_that.year,_that.month,_that.days,_that.averages,_that.calorieTarget,_that.daysOnTarget,_that.activeDays);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int year,  int month,  List<DailySummaryPointDto> days,  MacroAveragesDto averages, @JsonKey(name: 'calorie_target')  int calorieTarget, @JsonKey(name: 'days_on_target')  int daysOnTarget, @JsonKey(name: 'active_days')  int activeDays)  $default,) {final _that = this;
switch (_that) {
case _MonthlyProgressDto():
return $default(_that.year,_that.month,_that.days,_that.averages,_that.calorieTarget,_that.daysOnTarget,_that.activeDays);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int year,  int month,  List<DailySummaryPointDto> days,  MacroAveragesDto averages, @JsonKey(name: 'calorie_target')  int calorieTarget, @JsonKey(name: 'days_on_target')  int daysOnTarget, @JsonKey(name: 'active_days')  int activeDays)?  $default,) {final _that = this;
switch (_that) {
case _MonthlyProgressDto() when $default != null:
return $default(_that.year,_that.month,_that.days,_that.averages,_that.calorieTarget,_that.daysOnTarget,_that.activeDays);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonthlyProgressDto implements MonthlyProgressDto {
  const _MonthlyProgressDto({required this.year, required this.month, required  List<DailySummaryPointDto> days, required this.averages, @JsonKey(name: 'calorie_target') required this.calorieTarget, @JsonKey(name: 'days_on_target') required this.daysOnTarget, @JsonKey(name: 'active_days') required this.activeDays}): _days = days;
  factory _MonthlyProgressDto.fromJson(Map<String, dynamic> json) => _$MonthlyProgressDtoFromJson(json);

@override final  int year;
@override final  int month;
 final  List<DailySummaryPointDto> _days;
@override List<DailySummaryPointDto> get days {
  if (_days is EqualUnmodifiableListView) return _days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_days);
}

@override final  MacroAveragesDto averages;
@override@JsonKey(name: 'calorie_target') final  int calorieTarget;
@override@JsonKey(name: 'days_on_target') final  int daysOnTarget;
@override@JsonKey(name: 'active_days') final  int activeDays;

/// Create a copy of MonthlyProgressDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthlyProgressDtoCopyWith<_MonthlyProgressDto> get copyWith => __$MonthlyProgressDtoCopyWithImpl<_MonthlyProgressDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonthlyProgressDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthlyProgressDto&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&const DeepCollectionEquality().equals(other.days, _days)&&(identical(other.averages, averages) || other.averages == averages)&&(identical(other.calorieTarget, calorieTarget) || other.calorieTarget == calorieTarget)&&(identical(other.daysOnTarget, daysOnTarget) || other.daysOnTarget == daysOnTarget)&&(identical(other.activeDays, activeDays) || other.activeDays == activeDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,year,month,const DeepCollectionEquality().hash(_days),averages,calorieTarget,daysOnTarget,activeDays);
}

@override
String toString() {
    return 'MonthlyProgressDto(year: $year, month: $month, days: $days, averages: $averages, calorieTarget: $calorieTarget, daysOnTarget: $daysOnTarget, activeDays: $activeDays)';
}


}

/// @nodoc
abstract mixin class _$MonthlyProgressDtoCopyWith<$Res> implements $MonthlyProgressDtoCopyWith<$Res> {
  factory _$MonthlyProgressDtoCopyWith(_MonthlyProgressDto value, $Res Function(_MonthlyProgressDto) _then) = __$MonthlyProgressDtoCopyWithImpl;
@override @useResult
$Res call({
 int year, int month, List<DailySummaryPointDto> days, MacroAveragesDto averages,@JsonKey(name: 'calorie_target') int calorieTarget,@JsonKey(name: 'days_on_target') int daysOnTarget,@JsonKey(name: 'active_days') int activeDays
});


@override $MacroAveragesDtoCopyWith<$Res> get averages;

}
/// @nodoc
class __$MonthlyProgressDtoCopyWithImpl<$Res>
    implements _$MonthlyProgressDtoCopyWith<$Res> {
  __$MonthlyProgressDtoCopyWithImpl(this._self, this._then);

  final _MonthlyProgressDto _self;
  final $Res Function(_MonthlyProgressDto) _then;

/// Create a copy of MonthlyProgressDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? year = null,Object? month = null,Object? days = null,Object? averages = null,Object? calorieTarget = null,Object? daysOnTarget = null,Object? activeDays = null,}) {
  return _then(_MonthlyProgressDto(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,days: null == days ? _self._days : days // ignore: cast_nullable_to_non_nullable
as List<DailySummaryPointDto>,averages: null == averages ? _self.averages : averages // ignore: cast_nullable_to_non_nullable
as MacroAveragesDto,calorieTarget: null == calorieTarget ? _self.calorieTarget : calorieTarget // ignore: cast_nullable_to_non_nullable
as int,daysOnTarget: null == daysOnTarget ? _self.daysOnTarget : daysOnTarget // ignore: cast_nullable_to_non_nullable
as int,activeDays: null == activeDays ? _self.activeDays : activeDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of MonthlyProgressDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MacroAveragesDtoCopyWith<$Res> get averages {
  
  return $MacroAveragesDtoCopyWith<$Res>(_self.averages, (value) {
    return _then(_self.copyWith(averages: value));
  });
}
}

// dart format on
