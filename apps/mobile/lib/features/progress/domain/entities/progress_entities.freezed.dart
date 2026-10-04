// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'progress_entities.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DailyCaloriePoint {

 DateTime get date; int get consumed; int get target;
/// Create a copy of DailyCaloriePoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyCaloriePointCopyWith<DailyCaloriePoint> get copyWith => _$DailyCaloriePointCopyWithImpl<DailyCaloriePoint>(this as DailyCaloriePoint, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DailyCaloriePoint;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyCaloriePoint&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.consumed, _this.consumed) || other.consumed == _this.consumed)&&(identical(other.target, _this.target) || other.target == _this.target));
}


@override
int get hashCode {
  final _this = this as DailyCaloriePoint;
  return Object.hash(runtimeType,_this.date,_this.consumed,_this.target);
}

@override
String toString() {
  final _this = this as DailyCaloriePoint;
  return 'DailyCaloriePoint(date: ${_this.date}, consumed: ${_this.consumed}, target: ${_this.target})';
}


}

/// @nodoc
abstract mixin class $DailyCaloriePointCopyWith<$Res>  {
  factory $DailyCaloriePointCopyWith(DailyCaloriePoint value, $Res Function(DailyCaloriePoint) _then) = _$DailyCaloriePointCopyWithImpl;
@useResult
$Res call({
 DateTime date, int consumed, int target
});




}
/// @nodoc
class _$DailyCaloriePointCopyWithImpl<$Res>
    implements $DailyCaloriePointCopyWith<$Res> {
  _$DailyCaloriePointCopyWithImpl(this._self, this._then);

  final DailyCaloriePoint _self;
  final $Res Function(DailyCaloriePoint) _then;

/// Create a copy of DailyCaloriePoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? consumed = null,Object? target = null,}) {
  return _then(DailyCaloriePoint(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,consumed: null == consumed ? _self.consumed : consumed // ignore: cast_nullable_to_non_nullable
as int,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyCaloriePoint].
extension DailyCaloriePointPatterns on DailyCaloriePoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyCaloriePoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyCaloriePoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyCaloriePoint value)  $default,){
final _that = this;
switch (_that) {
case _DailyCaloriePoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyCaloriePoint value)?  $default,){
final _that = this;
switch (_that) {
case _DailyCaloriePoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  int consumed,  int target)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyCaloriePoint() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  int consumed,  int target)  $default,) {final _that = this;
switch (_that) {
case _DailyCaloriePoint():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  int consumed,  int target)?  $default,) {final _that = this;
switch (_that) {
case _DailyCaloriePoint() when $default != null:
return $default(_that.date,_that.consumed,_that.target);case _:
  return null;

}
}

}

/// @nodoc


class _DailyCaloriePoint implements DailyCaloriePoint {
  const _DailyCaloriePoint({required this.date, required this.consumed, required this.target});
  

@override final  DateTime date;
@override final  int consumed;
@override final  int target;

/// Create a copy of DailyCaloriePoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyCaloriePointCopyWith<_DailyCaloriePoint> get copyWith => __$DailyCaloriePointCopyWithImpl<_DailyCaloriePoint>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyCaloriePoint&&(identical(other.date, date) || other.date == date)&&(identical(other.consumed, consumed) || other.consumed == consumed)&&(identical(other.target, target) || other.target == target));
}


@override
int get hashCode {
    return Object.hash(runtimeType,date,consumed,target);
}

@override
String toString() {
    return 'DailyCaloriePoint(date: $date, consumed: $consumed, target: $target)';
}


}

/// @nodoc
abstract mixin class _$DailyCaloriePointCopyWith<$Res> implements $DailyCaloriePointCopyWith<$Res> {
  factory _$DailyCaloriePointCopyWith(_DailyCaloriePoint value, $Res Function(_DailyCaloriePoint) _then) = __$DailyCaloriePointCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, int consumed, int target
});




}
/// @nodoc
class __$DailyCaloriePointCopyWithImpl<$Res>
    implements _$DailyCaloriePointCopyWith<$Res> {
  __$DailyCaloriePointCopyWithImpl(this._self, this._then);

  final _DailyCaloriePoint _self;
  final $Res Function(_DailyCaloriePoint) _then;

/// Create a copy of DailyCaloriePoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? consumed = null,Object? target = null,}) {
  return _then(_DailyCaloriePoint(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,consumed: null == consumed ? _self.consumed : consumed // ignore: cast_nullable_to_non_nullable
as int,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$MacroAverages {

 int get calories; double get protein; double get carbs; double get fat;
/// Create a copy of MacroAverages
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MacroAveragesCopyWith<MacroAverages> get copyWith => _$MacroAveragesCopyWithImpl<MacroAverages>(this as MacroAverages, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MacroAverages;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MacroAverages&&(identical(other.calories, _this.calories) || other.calories == _this.calories)&&(identical(other.protein, _this.protein) || other.protein == _this.protein)&&(identical(other.carbs, _this.carbs) || other.carbs == _this.carbs)&&(identical(other.fat, _this.fat) || other.fat == _this.fat));
}


@override
int get hashCode {
  final _this = this as MacroAverages;
  return Object.hash(runtimeType,_this.calories,_this.protein,_this.carbs,_this.fat);
}

@override
String toString() {
  final _this = this as MacroAverages;
  return 'MacroAverages(calories: ${_this.calories}, protein: ${_this.protein}, carbs: ${_this.carbs}, fat: ${_this.fat})';
}


}

/// @nodoc
abstract mixin class $MacroAveragesCopyWith<$Res>  {
  factory $MacroAveragesCopyWith(MacroAverages value, $Res Function(MacroAverages) _then) = _$MacroAveragesCopyWithImpl;
@useResult
$Res call({
 int calories, double protein, double carbs, double fat
});




}
/// @nodoc
class _$MacroAveragesCopyWithImpl<$Res>
    implements $MacroAveragesCopyWith<$Res> {
  _$MacroAveragesCopyWithImpl(this._self, this._then);

  final MacroAverages _self;
  final $Res Function(MacroAverages) _then;

/// Create a copy of MacroAverages
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? calories = null,Object? protein = null,Object? carbs = null,Object? fat = null,}) {
  return _then(MacroAverages(
calories: null == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as int,protein: null == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as double,carbs: null == carbs ? _self.carbs : carbs // ignore: cast_nullable_to_non_nullable
as double,fat: null == fat ? _self.fat : fat // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [MacroAverages].
extension MacroAveragesPatterns on MacroAverages {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MacroAverages value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MacroAverages() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MacroAverages value)  $default,){
final _that = this;
switch (_that) {
case _MacroAverages():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MacroAverages value)?  $default,){
final _that = this;
switch (_that) {
case _MacroAverages() when $default != null:
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
case _MacroAverages() when $default != null:
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
case _MacroAverages():
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
case _MacroAverages() when $default != null:
return $default(_that.calories,_that.protein,_that.carbs,_that.fat);case _:
  return null;

}
}

}

/// @nodoc


class _MacroAverages implements MacroAverages {
  const _MacroAverages({this.calories = 0, this.protein = 0.0, this.carbs = 0.0, this.fat = 0.0});
  

@override@JsonKey() final  int calories;
@override@JsonKey() final  double protein;
@override@JsonKey() final  double carbs;
@override@JsonKey() final  double fat;

/// Create a copy of MacroAverages
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MacroAveragesCopyWith<_MacroAverages> get copyWith => __$MacroAveragesCopyWithImpl<_MacroAverages>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MacroAverages&&(identical(other.calories, calories) || other.calories == calories)&&(identical(other.protein, protein) || other.protein == protein)&&(identical(other.carbs, carbs) || other.carbs == carbs)&&(identical(other.fat, fat) || other.fat == fat));
}


@override
int get hashCode {
    return Object.hash(runtimeType,calories,protein,carbs,fat);
}

@override
String toString() {
    return 'MacroAverages(calories: $calories, protein: $protein, carbs: $carbs, fat: $fat)';
}


}

/// @nodoc
abstract mixin class _$MacroAveragesCopyWith<$Res> implements $MacroAveragesCopyWith<$Res> {
  factory _$MacroAveragesCopyWith(_MacroAverages value, $Res Function(_MacroAverages) _then) = __$MacroAveragesCopyWithImpl;
@override @useResult
$Res call({
 int calories, double protein, double carbs, double fat
});




}
/// @nodoc
class __$MacroAveragesCopyWithImpl<$Res>
    implements _$MacroAveragesCopyWith<$Res> {
  __$MacroAveragesCopyWithImpl(this._self, this._then);

  final _MacroAverages _self;
  final $Res Function(_MacroAverages) _then;

/// Create a copy of MacroAverages
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? calories = null,Object? protein = null,Object? carbs = null,Object? fat = null,}) {
  return _then(_MacroAverages(
calories: null == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as int,protein: null == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as double,carbs: null == carbs ? _self.carbs : carbs // ignore: cast_nullable_to_non_nullable
as double,fat: null == fat ? _self.fat : fat // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$MacroTargets {

 double get protein; double get carbs; double get fat;
/// Create a copy of MacroTargets
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MacroTargetsCopyWith<MacroTargets> get copyWith => _$MacroTargetsCopyWithImpl<MacroTargets>(this as MacroTargets, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MacroTargets;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MacroTargets&&(identical(other.protein, _this.protein) || other.protein == _this.protein)&&(identical(other.carbs, _this.carbs) || other.carbs == _this.carbs)&&(identical(other.fat, _this.fat) || other.fat == _this.fat));
}


@override
int get hashCode {
  final _this = this as MacroTargets;
  return Object.hash(runtimeType,_this.protein,_this.carbs,_this.fat);
}

@override
String toString() {
  final _this = this as MacroTargets;
  return 'MacroTargets(protein: ${_this.protein}, carbs: ${_this.carbs}, fat: ${_this.fat})';
}


}

/// @nodoc
abstract mixin class $MacroTargetsCopyWith<$Res>  {
  factory $MacroTargetsCopyWith(MacroTargets value, $Res Function(MacroTargets) _then) = _$MacroTargetsCopyWithImpl;
@useResult
$Res call({
 double protein, double carbs, double fat
});




}
/// @nodoc
class _$MacroTargetsCopyWithImpl<$Res>
    implements $MacroTargetsCopyWith<$Res> {
  _$MacroTargetsCopyWithImpl(this._self, this._then);

  final MacroTargets _self;
  final $Res Function(MacroTargets) _then;

/// Create a copy of MacroTargets
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? protein = null,Object? carbs = null,Object? fat = null,}) {
  return _then(MacroTargets(
protein: null == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as double,carbs: null == carbs ? _self.carbs : carbs // ignore: cast_nullable_to_non_nullable
as double,fat: null == fat ? _self.fat : fat // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [MacroTargets].
extension MacroTargetsPatterns on MacroTargets {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MacroTargets value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MacroTargets() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MacroTargets value)  $default,){
final _that = this;
switch (_that) {
case _MacroTargets():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MacroTargets value)?  $default,){
final _that = this;
switch (_that) {
case _MacroTargets() when $default != null:
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
case _MacroTargets() when $default != null:
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
case _MacroTargets():
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
case _MacroTargets() when $default != null:
return $default(_that.protein,_that.carbs,_that.fat);case _:
  return null;

}
}

}

/// @nodoc


class _MacroTargets implements MacroTargets {
  const _MacroTargets({this.protein = 150.0, this.carbs = 200.0, this.fat = 67.0});
  

@override@JsonKey() final  double protein;
@override@JsonKey() final  double carbs;
@override@JsonKey() final  double fat;

/// Create a copy of MacroTargets
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MacroTargetsCopyWith<_MacroTargets> get copyWith => __$MacroTargetsCopyWithImpl<_MacroTargets>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MacroTargets&&(identical(other.protein, protein) || other.protein == protein)&&(identical(other.carbs, carbs) || other.carbs == carbs)&&(identical(other.fat, fat) || other.fat == fat));
}


@override
int get hashCode {
    return Object.hash(runtimeType,protein,carbs,fat);
}

@override
String toString() {
    return 'MacroTargets(protein: $protein, carbs: $carbs, fat: $fat)';
}


}

/// @nodoc
abstract mixin class _$MacroTargetsCopyWith<$Res> implements $MacroTargetsCopyWith<$Res> {
  factory _$MacroTargetsCopyWith(_MacroTargets value, $Res Function(_MacroTargets) _then) = __$MacroTargetsCopyWithImpl;
@override @useResult
$Res call({
 double protein, double carbs, double fat
});




}
/// @nodoc
class __$MacroTargetsCopyWithImpl<$Res>
    implements _$MacroTargetsCopyWith<$Res> {
  __$MacroTargetsCopyWithImpl(this._self, this._then);

  final _MacroTargets _self;
  final $Res Function(_MacroTargets) _then;

/// Create a copy of MacroTargets
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? protein = null,Object? carbs = null,Object? fat = null,}) {
  return _then(_MacroTargets(
protein: null == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as double,carbs: null == carbs ? _self.carbs : carbs // ignore: cast_nullable_to_non_nullable
as double,fat: null == fat ? _self.fat : fat // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$WeightPoint {

 DateTime get date; double get weightKg;
/// Create a copy of WeightPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeightPointCopyWith<WeightPoint> get copyWith => _$WeightPointCopyWithImpl<WeightPoint>(this as WeightPoint, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WeightPoint;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeightPoint&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.weightKg, _this.weightKg) || other.weightKg == _this.weightKg));
}


@override
int get hashCode {
  final _this = this as WeightPoint;
  return Object.hash(runtimeType,_this.date,_this.weightKg);
}

@override
String toString() {
  final _this = this as WeightPoint;
  return 'WeightPoint(date: ${_this.date}, weightKg: ${_this.weightKg})';
}


}

/// @nodoc
abstract mixin class $WeightPointCopyWith<$Res>  {
  factory $WeightPointCopyWith(WeightPoint value, $Res Function(WeightPoint) _then) = _$WeightPointCopyWithImpl;
@useResult
$Res call({
 DateTime date, double weightKg
});




}
/// @nodoc
class _$WeightPointCopyWithImpl<$Res>
    implements $WeightPointCopyWith<$Res> {
  _$WeightPointCopyWithImpl(this._self, this._then);

  final WeightPoint _self;
  final $Res Function(WeightPoint) _then;

/// Create a copy of WeightPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? weightKg = null,}) {
  return _then(WeightPoint(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,weightKg: null == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [WeightPoint].
extension WeightPointPatterns on WeightPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeightPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeightPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeightPoint value)  $default,){
final _that = this;
switch (_that) {
case _WeightPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeightPoint value)?  $default,){
final _that = this;
switch (_that) {
case _WeightPoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  double weightKg)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeightPoint() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  double weightKg)  $default,) {final _that = this;
switch (_that) {
case _WeightPoint():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  double weightKg)?  $default,) {final _that = this;
switch (_that) {
case _WeightPoint() when $default != null:
return $default(_that.date,_that.weightKg);case _:
  return null;

}
}

}

/// @nodoc


class _WeightPoint implements WeightPoint {
  const _WeightPoint({required this.date, required this.weightKg});
  

@override final  DateTime date;
@override final  double weightKg;

/// Create a copy of WeightPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeightPointCopyWith<_WeightPoint> get copyWith => __$WeightPointCopyWithImpl<_WeightPoint>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeightPoint&&(identical(other.date, date) || other.date == date)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg));
}


@override
int get hashCode {
    return Object.hash(runtimeType,date,weightKg);
}

@override
String toString() {
    return 'WeightPoint(date: $date, weightKg: $weightKg)';
}


}

/// @nodoc
abstract mixin class _$WeightPointCopyWith<$Res> implements $WeightPointCopyWith<$Res> {
  factory _$WeightPointCopyWith(_WeightPoint value, $Res Function(_WeightPoint) _then) = __$WeightPointCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, double weightKg
});




}
/// @nodoc
class __$WeightPointCopyWithImpl<$Res>
    implements _$WeightPointCopyWith<$Res> {
  __$WeightPointCopyWithImpl(this._self, this._then);

  final _WeightPoint _self;
  final $Res Function(_WeightPoint) _then;

/// Create a copy of WeightPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? weightKg = null,}) {
  return _then(_WeightPoint(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,weightKg: null == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$ProgressData {

 String get range; DateTime get start; DateTime get end; List<DailyCaloriePoint> get calorieDaily; int get calorieAverage; int get calorieTarget; MacroAverages get macroAverages; MacroTargets get macroTargets; WeightProgress get weight; int get mealsTracked; int get daysOnTarget; int get activeDays; int get streak;
/// Create a copy of ProgressData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgressDataCopyWith<ProgressData> get copyWith => _$ProgressDataCopyWithImpl<ProgressData>(this as ProgressData, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProgressData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgressData&&(identical(other.range, _this.range) || other.range == _this.range)&&(identical(other.start, _this.start) || other.start == _this.start)&&(identical(other.end, _this.end) || other.end == _this.end)&&const DeepCollectionEquality().equals(other.calorieDaily, _this.calorieDaily)&&(identical(other.calorieAverage, _this.calorieAverage) || other.calorieAverage == _this.calorieAverage)&&(identical(other.calorieTarget, _this.calorieTarget) || other.calorieTarget == _this.calorieTarget)&&(identical(other.macroAverages, _this.macroAverages) || other.macroAverages == _this.macroAverages)&&(identical(other.macroTargets, _this.macroTargets) || other.macroTargets == _this.macroTargets)&&(identical(other.weight, _this.weight) || other.weight == _this.weight)&&(identical(other.mealsTracked, _this.mealsTracked) || other.mealsTracked == _this.mealsTracked)&&(identical(other.daysOnTarget, _this.daysOnTarget) || other.daysOnTarget == _this.daysOnTarget)&&(identical(other.activeDays, _this.activeDays) || other.activeDays == _this.activeDays)&&(identical(other.streak, _this.streak) || other.streak == _this.streak));
}


@override
int get hashCode {
  final _this = this as ProgressData;
  return Object.hash(runtimeType,_this.range,_this.start,_this.end,const DeepCollectionEquality().hash(_this.calorieDaily),_this.calorieAverage,_this.calorieTarget,_this.macroAverages,_this.macroTargets,_this.weight,_this.mealsTracked,_this.daysOnTarget,_this.activeDays,_this.streak);
}

@override
String toString() {
  final _this = this as ProgressData;
  return 'ProgressData(range: ${_this.range}, start: ${_this.start}, end: ${_this.end}, calorieDaily: ${_this.calorieDaily}, calorieAverage: ${_this.calorieAverage}, calorieTarget: ${_this.calorieTarget}, macroAverages: ${_this.macroAverages}, macroTargets: ${_this.macroTargets}, weight: ${_this.weight}, mealsTracked: ${_this.mealsTracked}, daysOnTarget: ${_this.daysOnTarget}, activeDays: ${_this.activeDays}, streak: ${_this.streak})';
}


}

/// @nodoc
abstract mixin class $ProgressDataCopyWith<$Res>  {
  factory $ProgressDataCopyWith(ProgressData value, $Res Function(ProgressData) _then) = _$ProgressDataCopyWithImpl;
@useResult
$Res call({
 String range, DateTime start, DateTime end, List<DailyCaloriePoint> calorieDaily, int calorieAverage, int calorieTarget, MacroAverages macroAverages, MacroTargets macroTargets, WeightProgress weight, int mealsTracked, int daysOnTarget, int activeDays, int streak
});


$MacroAveragesCopyWith<$Res> get macroAverages;$MacroTargetsCopyWith<$Res> get macroTargets;

}
/// @nodoc
class _$ProgressDataCopyWithImpl<$Res>
    implements $ProgressDataCopyWith<$Res> {
  _$ProgressDataCopyWithImpl(this._self, this._then);

  final ProgressData _self;
  final $Res Function(ProgressData) _then;

/// Create a copy of ProgressData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? range = null,Object? start = null,Object? end = null,Object? calorieDaily = null,Object? calorieAverage = null,Object? calorieTarget = null,Object? macroAverages = null,Object? macroTargets = null,Object? weight = null,Object? mealsTracked = null,Object? daysOnTarget = null,Object? activeDays = null,Object? streak = null,}) {
  return _then(ProgressData(
range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as String,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,calorieDaily: null == calorieDaily ? _self.calorieDaily : calorieDaily // ignore: cast_nullable_to_non_nullable
as List<DailyCaloriePoint>,calorieAverage: null == calorieAverage ? _self.calorieAverage : calorieAverage // ignore: cast_nullable_to_non_nullable
as int,calorieTarget: null == calorieTarget ? _self.calorieTarget : calorieTarget // ignore: cast_nullable_to_non_nullable
as int,macroAverages: null == macroAverages ? _self.macroAverages : macroAverages // ignore: cast_nullable_to_non_nullable
as MacroAverages,macroTargets: null == macroTargets ? _self.macroTargets : macroTargets // ignore: cast_nullable_to_non_nullable
as MacroTargets,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as WeightProgress,mealsTracked: null == mealsTracked ? _self.mealsTracked : mealsTracked // ignore: cast_nullable_to_non_nullable
as int,daysOnTarget: null == daysOnTarget ? _self.daysOnTarget : daysOnTarget // ignore: cast_nullable_to_non_nullable
as int,activeDays: null == activeDays ? _self.activeDays : activeDays // ignore: cast_nullable_to_non_nullable
as int,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of ProgressData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MacroAveragesCopyWith<$Res> get macroAverages {
  
  return $MacroAveragesCopyWith<$Res>(_self.macroAverages, (value) {
    return _then(_self.copyWith(macroAverages: value));
  });
}/// Create a copy of ProgressData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MacroTargetsCopyWith<$Res> get macroTargets {
  
  return $MacroTargetsCopyWith<$Res>(_self.macroTargets, (value) {
    return _then(_self.copyWith(macroTargets: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProgressData].
extension ProgressDataPatterns on ProgressData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProgressData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProgressData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProgressData value)  $default,){
final _that = this;
switch (_that) {
case _ProgressData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProgressData value)?  $default,){
final _that = this;
switch (_that) {
case _ProgressData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String range,  DateTime start,  DateTime end,  List<DailyCaloriePoint> calorieDaily,  int calorieAverage,  int calorieTarget,  MacroAverages macroAverages,  MacroTargets macroTargets,  WeightProgress weight,  int mealsTracked,  int daysOnTarget,  int activeDays,  int streak)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProgressData() when $default != null:
return $default(_that.range,_that.start,_that.end,_that.calorieDaily,_that.calorieAverage,_that.calorieTarget,_that.macroAverages,_that.macroTargets,_that.weight,_that.mealsTracked,_that.daysOnTarget,_that.activeDays,_that.streak);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String range,  DateTime start,  DateTime end,  List<DailyCaloriePoint> calorieDaily,  int calorieAverage,  int calorieTarget,  MacroAverages macroAverages,  MacroTargets macroTargets,  WeightProgress weight,  int mealsTracked,  int daysOnTarget,  int activeDays,  int streak)  $default,) {final _that = this;
switch (_that) {
case _ProgressData():
return $default(_that.range,_that.start,_that.end,_that.calorieDaily,_that.calorieAverage,_that.calorieTarget,_that.macroAverages,_that.macroTargets,_that.weight,_that.mealsTracked,_that.daysOnTarget,_that.activeDays,_that.streak);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String range,  DateTime start,  DateTime end,  List<DailyCaloriePoint> calorieDaily,  int calorieAverage,  int calorieTarget,  MacroAverages macroAverages,  MacroTargets macroTargets,  WeightProgress weight,  int mealsTracked,  int daysOnTarget,  int activeDays,  int streak)?  $default,) {final _that = this;
switch (_that) {
case _ProgressData() when $default != null:
return $default(_that.range,_that.start,_that.end,_that.calorieDaily,_that.calorieAverage,_that.calorieTarget,_that.macroAverages,_that.macroTargets,_that.weight,_that.mealsTracked,_that.daysOnTarget,_that.activeDays,_that.streak);case _:
  return null;

}
}

}

/// @nodoc


class _ProgressData implements ProgressData {
  const _ProgressData({required this.range, required this.start, required this.end, required  List<DailyCaloriePoint> calorieDaily, required this.calorieAverage, required this.calorieTarget, required this.macroAverages, required this.macroTargets, required this.weight, required this.mealsTracked, required this.daysOnTarget, required this.activeDays, required this.streak}): _calorieDaily = calorieDaily;
  

@override final  String range;
@override final  DateTime start;
@override final  DateTime end;
 final  List<DailyCaloriePoint> _calorieDaily;
@override List<DailyCaloriePoint> get calorieDaily {
  if (_calorieDaily is EqualUnmodifiableListView) return _calorieDaily;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_calorieDaily);
}

@override final  int calorieAverage;
@override final  int calorieTarget;
@override final  MacroAverages macroAverages;
@override final  MacroTargets macroTargets;
@override final  WeightProgress weight;
@override final  int mealsTracked;
@override final  int daysOnTarget;
@override final  int activeDays;
@override final  int streak;

/// Create a copy of ProgressData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgressDataCopyWith<_ProgressData> get copyWith => __$ProgressDataCopyWithImpl<_ProgressData>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProgressData&&(identical(other.range, range) || other.range == range)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&const DeepCollectionEquality().equals(other.calorieDaily, _calorieDaily)&&(identical(other.calorieAverage, calorieAverage) || other.calorieAverage == calorieAverage)&&(identical(other.calorieTarget, calorieTarget) || other.calorieTarget == calorieTarget)&&(identical(other.macroAverages, macroAverages) || other.macroAverages == macroAverages)&&(identical(other.macroTargets, macroTargets) || other.macroTargets == macroTargets)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.mealsTracked, mealsTracked) || other.mealsTracked == mealsTracked)&&(identical(other.daysOnTarget, daysOnTarget) || other.daysOnTarget == daysOnTarget)&&(identical(other.activeDays, activeDays) || other.activeDays == activeDays)&&(identical(other.streak, streak) || other.streak == streak));
}


@override
int get hashCode {
    return Object.hash(runtimeType,range,start,end,const DeepCollectionEquality().hash(_calorieDaily),calorieAverage,calorieTarget,macroAverages,macroTargets,weight,mealsTracked,daysOnTarget,activeDays,streak);
}

@override
String toString() {
    return 'ProgressData(range: $range, start: $start, end: $end, calorieDaily: $calorieDaily, calorieAverage: $calorieAverage, calorieTarget: $calorieTarget, macroAverages: $macroAverages, macroTargets: $macroTargets, weight: $weight, mealsTracked: $mealsTracked, daysOnTarget: $daysOnTarget, activeDays: $activeDays, streak: $streak)';
}


}

/// @nodoc
abstract mixin class _$ProgressDataCopyWith<$Res> implements $ProgressDataCopyWith<$Res> {
  factory _$ProgressDataCopyWith(_ProgressData value, $Res Function(_ProgressData) _then) = __$ProgressDataCopyWithImpl;
@override @useResult
$Res call({
 String range, DateTime start, DateTime end, List<DailyCaloriePoint> calorieDaily, int calorieAverage, int calorieTarget, MacroAverages macroAverages, MacroTargets macroTargets, WeightProgress weight, int mealsTracked, int daysOnTarget, int activeDays, int streak
});


@override $MacroAveragesCopyWith<$Res> get macroAverages;@override $MacroTargetsCopyWith<$Res> get macroTargets;

}
/// @nodoc
class __$ProgressDataCopyWithImpl<$Res>
    implements _$ProgressDataCopyWith<$Res> {
  __$ProgressDataCopyWithImpl(this._self, this._then);

  final _ProgressData _self;
  final $Res Function(_ProgressData) _then;

/// Create a copy of ProgressData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? range = null,Object? start = null,Object? end = null,Object? calorieDaily = null,Object? calorieAverage = null,Object? calorieTarget = null,Object? macroAverages = null,Object? macroTargets = null,Object? weight = null,Object? mealsTracked = null,Object? daysOnTarget = null,Object? activeDays = null,Object? streak = null,}) {
  return _then(_ProgressData(
range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as String,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,calorieDaily: null == calorieDaily ? _self._calorieDaily : calorieDaily // ignore: cast_nullable_to_non_nullable
as List<DailyCaloriePoint>,calorieAverage: null == calorieAverage ? _self.calorieAverage : calorieAverage // ignore: cast_nullable_to_non_nullable
as int,calorieTarget: null == calorieTarget ? _self.calorieTarget : calorieTarget // ignore: cast_nullable_to_non_nullable
as int,macroAverages: null == macroAverages ? _self.macroAverages : macroAverages // ignore: cast_nullable_to_non_nullable
as MacroAverages,macroTargets: null == macroTargets ? _self.macroTargets : macroTargets // ignore: cast_nullable_to_non_nullable
as MacroTargets,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as WeightProgress,mealsTracked: null == mealsTracked ? _self.mealsTracked : mealsTracked // ignore: cast_nullable_to_non_nullable
as int,daysOnTarget: null == daysOnTarget ? _self.daysOnTarget : daysOnTarget // ignore: cast_nullable_to_non_nullable
as int,activeDays: null == activeDays ? _self.activeDays : activeDays // ignore: cast_nullable_to_non_nullable
as int,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of ProgressData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MacroAveragesCopyWith<$Res> get macroAverages {
  
  return $MacroAveragesCopyWith<$Res>(_self.macroAverages, (value) {
    return _then(_self.copyWith(macroAverages: value));
  });
}/// Create a copy of ProgressData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MacroTargetsCopyWith<$Res> get macroTargets {
  
  return $MacroTargetsCopyWith<$Res>(_self.macroTargets, (value) {
    return _then(_self.copyWith(macroTargets: value));
  });
}
}

/// @nodoc
mixin _$DailySummaryPoint {

 DateTime get date; int get calories; double get protein; double get carbs; double get fat; double get fiber; int get waterMl; int get mealsCount;
/// Create a copy of DailySummaryPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailySummaryPointCopyWith<DailySummaryPoint> get copyWith => _$DailySummaryPointCopyWithImpl<DailySummaryPoint>(this as DailySummaryPoint, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DailySummaryPoint;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailySummaryPoint&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.calories, _this.calories) || other.calories == _this.calories)&&(identical(other.protein, _this.protein) || other.protein == _this.protein)&&(identical(other.carbs, _this.carbs) || other.carbs == _this.carbs)&&(identical(other.fat, _this.fat) || other.fat == _this.fat)&&(identical(other.fiber, _this.fiber) || other.fiber == _this.fiber)&&(identical(other.waterMl, _this.waterMl) || other.waterMl == _this.waterMl)&&(identical(other.mealsCount, _this.mealsCount) || other.mealsCount == _this.mealsCount));
}


@override
int get hashCode {
  final _this = this as DailySummaryPoint;
  return Object.hash(runtimeType,_this.date,_this.calories,_this.protein,_this.carbs,_this.fat,_this.fiber,_this.waterMl,_this.mealsCount);
}

@override
String toString() {
  final _this = this as DailySummaryPoint;
  return 'DailySummaryPoint(date: ${_this.date}, calories: ${_this.calories}, protein: ${_this.protein}, carbs: ${_this.carbs}, fat: ${_this.fat}, fiber: ${_this.fiber}, waterMl: ${_this.waterMl}, mealsCount: ${_this.mealsCount})';
}


}

/// @nodoc
abstract mixin class $DailySummaryPointCopyWith<$Res>  {
  factory $DailySummaryPointCopyWith(DailySummaryPoint value, $Res Function(DailySummaryPoint) _then) = _$DailySummaryPointCopyWithImpl;
@useResult
$Res call({
 DateTime date, int calories, double protein, double carbs, double fat, double fiber, int waterMl, int mealsCount
});




}
/// @nodoc
class _$DailySummaryPointCopyWithImpl<$Res>
    implements $DailySummaryPointCopyWith<$Res> {
  _$DailySummaryPointCopyWithImpl(this._self, this._then);

  final DailySummaryPoint _self;
  final $Res Function(DailySummaryPoint) _then;

/// Create a copy of DailySummaryPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? calories = null,Object? protein = null,Object? carbs = null,Object? fat = null,Object? fiber = null,Object? waterMl = null,Object? mealsCount = null,}) {
  return _then(DailySummaryPoint(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,calories: null == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
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


/// Adds pattern-matching-related methods to [DailySummaryPoint].
extension DailySummaryPointPatterns on DailySummaryPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailySummaryPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailySummaryPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailySummaryPoint value)  $default,){
final _that = this;
switch (_that) {
case _DailySummaryPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailySummaryPoint value)?  $default,){
final _that = this;
switch (_that) {
case _DailySummaryPoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  int calories,  double protein,  double carbs,  double fat,  double fiber,  int waterMl,  int mealsCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailySummaryPoint() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  int calories,  double protein,  double carbs,  double fat,  double fiber,  int waterMl,  int mealsCount)  $default,) {final _that = this;
switch (_that) {
case _DailySummaryPoint():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  int calories,  double protein,  double carbs,  double fat,  double fiber,  int waterMl,  int mealsCount)?  $default,) {final _that = this;
switch (_that) {
case _DailySummaryPoint() when $default != null:
return $default(_that.date,_that.calories,_that.protein,_that.carbs,_that.fat,_that.fiber,_that.waterMl,_that.mealsCount);case _:
  return null;

}
}

}

/// @nodoc


class _DailySummaryPoint implements DailySummaryPoint {
  const _DailySummaryPoint({required this.date, required this.calories, required this.protein, required this.carbs, required this.fat, required this.fiber, required this.waterMl, required this.mealsCount});
  

@override final  DateTime date;
@override final  int calories;
@override final  double protein;
@override final  double carbs;
@override final  double fat;
@override final  double fiber;
@override final  int waterMl;
@override final  int mealsCount;

/// Create a copy of DailySummaryPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailySummaryPointCopyWith<_DailySummaryPoint> get copyWith => __$DailySummaryPointCopyWithImpl<_DailySummaryPoint>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailySummaryPoint&&(identical(other.date, date) || other.date == date)&&(identical(other.calories, calories) || other.calories == calories)&&(identical(other.protein, protein) || other.protein == protein)&&(identical(other.carbs, carbs) || other.carbs == carbs)&&(identical(other.fat, fat) || other.fat == fat)&&(identical(other.fiber, fiber) || other.fiber == fiber)&&(identical(other.waterMl, waterMl) || other.waterMl == waterMl)&&(identical(other.mealsCount, mealsCount) || other.mealsCount == mealsCount));
}


@override
int get hashCode {
    return Object.hash(runtimeType,date,calories,protein,carbs,fat,fiber,waterMl,mealsCount);
}

@override
String toString() {
    return 'DailySummaryPoint(date: $date, calories: $calories, protein: $protein, carbs: $carbs, fat: $fat, fiber: $fiber, waterMl: $waterMl, mealsCount: $mealsCount)';
}


}

/// @nodoc
abstract mixin class _$DailySummaryPointCopyWith<$Res> implements $DailySummaryPointCopyWith<$Res> {
  factory _$DailySummaryPointCopyWith(_DailySummaryPoint value, $Res Function(_DailySummaryPoint) _then) = __$DailySummaryPointCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, int calories, double protein, double carbs, double fat, double fiber, int waterMl, int mealsCount
});




}
/// @nodoc
class __$DailySummaryPointCopyWithImpl<$Res>
    implements _$DailySummaryPointCopyWith<$Res> {
  __$DailySummaryPointCopyWithImpl(this._self, this._then);

  final _DailySummaryPoint _self;
  final $Res Function(_DailySummaryPoint) _then;

/// Create a copy of DailySummaryPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? calories = null,Object? protein = null,Object? carbs = null,Object? fat = null,Object? fiber = null,Object? waterMl = null,Object? mealsCount = null,}) {
  return _then(_DailySummaryPoint(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,calories: null == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
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
mixin _$WeeklyProgress {

 DateTime get weekStart; DateTime get weekEnd; List<DailySummaryPoint> get days; MacroAverages get totals; MacroAverages get averages; int get calorieTarget;
/// Create a copy of WeeklyProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeeklyProgressCopyWith<WeeklyProgress> get copyWith => _$WeeklyProgressCopyWithImpl<WeeklyProgress>(this as WeeklyProgress, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WeeklyProgress;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeeklyProgress&&(identical(other.weekStart, _this.weekStart) || other.weekStart == _this.weekStart)&&(identical(other.weekEnd, _this.weekEnd) || other.weekEnd == _this.weekEnd)&&const DeepCollectionEquality().equals(other.days, _this.days)&&(identical(other.totals, _this.totals) || other.totals == _this.totals)&&(identical(other.averages, _this.averages) || other.averages == _this.averages)&&(identical(other.calorieTarget, _this.calorieTarget) || other.calorieTarget == _this.calorieTarget));
}


@override
int get hashCode {
  final _this = this as WeeklyProgress;
  return Object.hash(runtimeType,_this.weekStart,_this.weekEnd,const DeepCollectionEquality().hash(_this.days),_this.totals,_this.averages,_this.calorieTarget);
}

@override
String toString() {
  final _this = this as WeeklyProgress;
  return 'WeeklyProgress(weekStart: ${_this.weekStart}, weekEnd: ${_this.weekEnd}, days: ${_this.days}, totals: ${_this.totals}, averages: ${_this.averages}, calorieTarget: ${_this.calorieTarget})';
}


}

/// @nodoc
abstract mixin class $WeeklyProgressCopyWith<$Res>  {
  factory $WeeklyProgressCopyWith(WeeklyProgress value, $Res Function(WeeklyProgress) _then) = _$WeeklyProgressCopyWithImpl;
@useResult
$Res call({
 DateTime weekStart, DateTime weekEnd, List<DailySummaryPoint> days, MacroAverages totals, MacroAverages averages, int calorieTarget
});


$MacroAveragesCopyWith<$Res> get totals;$MacroAveragesCopyWith<$Res> get averages;

}
/// @nodoc
class _$WeeklyProgressCopyWithImpl<$Res>
    implements $WeeklyProgressCopyWith<$Res> {
  _$WeeklyProgressCopyWithImpl(this._self, this._then);

  final WeeklyProgress _self;
  final $Res Function(WeeklyProgress) _then;

/// Create a copy of WeeklyProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weekStart = null,Object? weekEnd = null,Object? days = null,Object? totals = null,Object? averages = null,Object? calorieTarget = null,}) {
  return _then(WeeklyProgress(
weekStart: null == weekStart ? _self.weekStart : weekStart // ignore: cast_nullable_to_non_nullable
as DateTime,weekEnd: null == weekEnd ? _self.weekEnd : weekEnd // ignore: cast_nullable_to_non_nullable
as DateTime,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as List<DailySummaryPoint>,totals: null == totals ? _self.totals : totals // ignore: cast_nullable_to_non_nullable
as MacroAverages,averages: null == averages ? _self.averages : averages // ignore: cast_nullable_to_non_nullable
as MacroAverages,calorieTarget: null == calorieTarget ? _self.calorieTarget : calorieTarget // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of WeeklyProgress
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MacroAveragesCopyWith<$Res> get totals {
  
  return $MacroAveragesCopyWith<$Res>(_self.totals, (value) {
    return _then(_self.copyWith(totals: value));
  });
}/// Create a copy of WeeklyProgress
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MacroAveragesCopyWith<$Res> get averages {
  
  return $MacroAveragesCopyWith<$Res>(_self.averages, (value) {
    return _then(_self.copyWith(averages: value));
  });
}
}


/// Adds pattern-matching-related methods to [WeeklyProgress].
extension WeeklyProgressPatterns on WeeklyProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeeklyProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeeklyProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeeklyProgress value)  $default,){
final _that = this;
switch (_that) {
case _WeeklyProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeeklyProgress value)?  $default,){
final _that = this;
switch (_that) {
case _WeeklyProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime weekStart,  DateTime weekEnd,  List<DailySummaryPoint> days,  MacroAverages totals,  MacroAverages averages,  int calorieTarget)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeeklyProgress() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime weekStart,  DateTime weekEnd,  List<DailySummaryPoint> days,  MacroAverages totals,  MacroAverages averages,  int calorieTarget)  $default,) {final _that = this;
switch (_that) {
case _WeeklyProgress():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime weekStart,  DateTime weekEnd,  List<DailySummaryPoint> days,  MacroAverages totals,  MacroAverages averages,  int calorieTarget)?  $default,) {final _that = this;
switch (_that) {
case _WeeklyProgress() when $default != null:
return $default(_that.weekStart,_that.weekEnd,_that.days,_that.totals,_that.averages,_that.calorieTarget);case _:
  return null;

}
}

}

/// @nodoc


class _WeeklyProgress implements WeeklyProgress {
  const _WeeklyProgress({required this.weekStart, required this.weekEnd, required  List<DailySummaryPoint> days, required this.totals, required this.averages, required this.calorieTarget}): _days = days;
  

@override final  DateTime weekStart;
@override final  DateTime weekEnd;
 final  List<DailySummaryPoint> _days;
@override List<DailySummaryPoint> get days {
  if (_days is EqualUnmodifiableListView) return _days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_days);
}

@override final  MacroAverages totals;
@override final  MacroAverages averages;
@override final  int calorieTarget;

/// Create a copy of WeeklyProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeeklyProgressCopyWith<_WeeklyProgress> get copyWith => __$WeeklyProgressCopyWithImpl<_WeeklyProgress>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeeklyProgress&&(identical(other.weekStart, weekStart) || other.weekStart == weekStart)&&(identical(other.weekEnd, weekEnd) || other.weekEnd == weekEnd)&&const DeepCollectionEquality().equals(other.days, _days)&&(identical(other.totals, totals) || other.totals == totals)&&(identical(other.averages, averages) || other.averages == averages)&&(identical(other.calorieTarget, calorieTarget) || other.calorieTarget == calorieTarget));
}


@override
int get hashCode {
    return Object.hash(runtimeType,weekStart,weekEnd,const DeepCollectionEquality().hash(_days),totals,averages,calorieTarget);
}

@override
String toString() {
    return 'WeeklyProgress(weekStart: $weekStart, weekEnd: $weekEnd, days: $days, totals: $totals, averages: $averages, calorieTarget: $calorieTarget)';
}


}

/// @nodoc
abstract mixin class _$WeeklyProgressCopyWith<$Res> implements $WeeklyProgressCopyWith<$Res> {
  factory _$WeeklyProgressCopyWith(_WeeklyProgress value, $Res Function(_WeeklyProgress) _then) = __$WeeklyProgressCopyWithImpl;
@override @useResult
$Res call({
 DateTime weekStart, DateTime weekEnd, List<DailySummaryPoint> days, MacroAverages totals, MacroAverages averages, int calorieTarget
});


@override $MacroAveragesCopyWith<$Res> get totals;@override $MacroAveragesCopyWith<$Res> get averages;

}
/// @nodoc
class __$WeeklyProgressCopyWithImpl<$Res>
    implements _$WeeklyProgressCopyWith<$Res> {
  __$WeeklyProgressCopyWithImpl(this._self, this._then);

  final _WeeklyProgress _self;
  final $Res Function(_WeeklyProgress) _then;

/// Create a copy of WeeklyProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weekStart = null,Object? weekEnd = null,Object? days = null,Object? totals = null,Object? averages = null,Object? calorieTarget = null,}) {
  return _then(_WeeklyProgress(
weekStart: null == weekStart ? _self.weekStart : weekStart // ignore: cast_nullable_to_non_nullable
as DateTime,weekEnd: null == weekEnd ? _self.weekEnd : weekEnd // ignore: cast_nullable_to_non_nullable
as DateTime,days: null == days ? _self._days : days // ignore: cast_nullable_to_non_nullable
as List<DailySummaryPoint>,totals: null == totals ? _self.totals : totals // ignore: cast_nullable_to_non_nullable
as MacroAverages,averages: null == averages ? _self.averages : averages // ignore: cast_nullable_to_non_nullable
as MacroAverages,calorieTarget: null == calorieTarget ? _self.calorieTarget : calorieTarget // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of WeeklyProgress
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MacroAveragesCopyWith<$Res> get totals {
  
  return $MacroAveragesCopyWith<$Res>(_self.totals, (value) {
    return _then(_self.copyWith(totals: value));
  });
}/// Create a copy of WeeklyProgress
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MacroAveragesCopyWith<$Res> get averages {
  
  return $MacroAveragesCopyWith<$Res>(_self.averages, (value) {
    return _then(_self.copyWith(averages: value));
  });
}
}

/// @nodoc
mixin _$MonthlyProgress {

 int get year; int get month; List<DailySummaryPoint> get days; MacroAverages get averages; int get calorieTarget; int get daysOnTarget; int get activeDays;
/// Create a copy of MonthlyProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthlyProgressCopyWith<MonthlyProgress> get copyWith => _$MonthlyProgressCopyWithImpl<MonthlyProgress>(this as MonthlyProgress, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MonthlyProgress;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthlyProgress&&(identical(other.year, _this.year) || other.year == _this.year)&&(identical(other.month, _this.month) || other.month == _this.month)&&const DeepCollectionEquality().equals(other.days, _this.days)&&(identical(other.averages, _this.averages) || other.averages == _this.averages)&&(identical(other.calorieTarget, _this.calorieTarget) || other.calorieTarget == _this.calorieTarget)&&(identical(other.daysOnTarget, _this.daysOnTarget) || other.daysOnTarget == _this.daysOnTarget)&&(identical(other.activeDays, _this.activeDays) || other.activeDays == _this.activeDays));
}


@override
int get hashCode {
  final _this = this as MonthlyProgress;
  return Object.hash(runtimeType,_this.year,_this.month,const DeepCollectionEquality().hash(_this.days),_this.averages,_this.calorieTarget,_this.daysOnTarget,_this.activeDays);
}

@override
String toString() {
  final _this = this as MonthlyProgress;
  return 'MonthlyProgress(year: ${_this.year}, month: ${_this.month}, days: ${_this.days}, averages: ${_this.averages}, calorieTarget: ${_this.calorieTarget}, daysOnTarget: ${_this.daysOnTarget}, activeDays: ${_this.activeDays})';
}


}

/// @nodoc
abstract mixin class $MonthlyProgressCopyWith<$Res>  {
  factory $MonthlyProgressCopyWith(MonthlyProgress value, $Res Function(MonthlyProgress) _then) = _$MonthlyProgressCopyWithImpl;
@useResult
$Res call({
 int year, int month, List<DailySummaryPoint> days, MacroAverages averages, int calorieTarget, int daysOnTarget, int activeDays
});


$MacroAveragesCopyWith<$Res> get averages;

}
/// @nodoc
class _$MonthlyProgressCopyWithImpl<$Res>
    implements $MonthlyProgressCopyWith<$Res> {
  _$MonthlyProgressCopyWithImpl(this._self, this._then);

  final MonthlyProgress _self;
  final $Res Function(MonthlyProgress) _then;

/// Create a copy of MonthlyProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? year = null,Object? month = null,Object? days = null,Object? averages = null,Object? calorieTarget = null,Object? daysOnTarget = null,Object? activeDays = null,}) {
  return _then(MonthlyProgress(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as List<DailySummaryPoint>,averages: null == averages ? _self.averages : averages // ignore: cast_nullable_to_non_nullable
as MacroAverages,calorieTarget: null == calorieTarget ? _self.calorieTarget : calorieTarget // ignore: cast_nullable_to_non_nullable
as int,daysOnTarget: null == daysOnTarget ? _self.daysOnTarget : daysOnTarget // ignore: cast_nullable_to_non_nullable
as int,activeDays: null == activeDays ? _self.activeDays : activeDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of MonthlyProgress
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MacroAveragesCopyWith<$Res> get averages {
  
  return $MacroAveragesCopyWith<$Res>(_self.averages, (value) {
    return _then(_self.copyWith(averages: value));
  });
}
}


/// Adds pattern-matching-related methods to [MonthlyProgress].
extension MonthlyProgressPatterns on MonthlyProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthlyProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthlyProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthlyProgress value)  $default,){
final _that = this;
switch (_that) {
case _MonthlyProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthlyProgress value)?  $default,){
final _that = this;
switch (_that) {
case _MonthlyProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int year,  int month,  List<DailySummaryPoint> days,  MacroAverages averages,  int calorieTarget,  int daysOnTarget,  int activeDays)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthlyProgress() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int year,  int month,  List<DailySummaryPoint> days,  MacroAverages averages,  int calorieTarget,  int daysOnTarget,  int activeDays)  $default,) {final _that = this;
switch (_that) {
case _MonthlyProgress():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int year,  int month,  List<DailySummaryPoint> days,  MacroAverages averages,  int calorieTarget,  int daysOnTarget,  int activeDays)?  $default,) {final _that = this;
switch (_that) {
case _MonthlyProgress() when $default != null:
return $default(_that.year,_that.month,_that.days,_that.averages,_that.calorieTarget,_that.daysOnTarget,_that.activeDays);case _:
  return null;

}
}

}

/// @nodoc


class _MonthlyProgress implements MonthlyProgress {
  const _MonthlyProgress({required this.year, required this.month, required  List<DailySummaryPoint> days, required this.averages, required this.calorieTarget, required this.daysOnTarget, required this.activeDays}): _days = days;
  

@override final  int year;
@override final  int month;
 final  List<DailySummaryPoint> _days;
@override List<DailySummaryPoint> get days {
  if (_days is EqualUnmodifiableListView) return _days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_days);
}

@override final  MacroAverages averages;
@override final  int calorieTarget;
@override final  int daysOnTarget;
@override final  int activeDays;

/// Create a copy of MonthlyProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthlyProgressCopyWith<_MonthlyProgress> get copyWith => __$MonthlyProgressCopyWithImpl<_MonthlyProgress>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthlyProgress&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&const DeepCollectionEquality().equals(other.days, _days)&&(identical(other.averages, averages) || other.averages == averages)&&(identical(other.calorieTarget, calorieTarget) || other.calorieTarget == calorieTarget)&&(identical(other.daysOnTarget, daysOnTarget) || other.daysOnTarget == daysOnTarget)&&(identical(other.activeDays, activeDays) || other.activeDays == activeDays));
}


@override
int get hashCode {
    return Object.hash(runtimeType,year,month,const DeepCollectionEquality().hash(_days),averages,calorieTarget,daysOnTarget,activeDays);
}

@override
String toString() {
    return 'MonthlyProgress(year: $year, month: $month, days: $days, averages: $averages, calorieTarget: $calorieTarget, daysOnTarget: $daysOnTarget, activeDays: $activeDays)';
}


}

/// @nodoc
abstract mixin class _$MonthlyProgressCopyWith<$Res> implements $MonthlyProgressCopyWith<$Res> {
  factory _$MonthlyProgressCopyWith(_MonthlyProgress value, $Res Function(_MonthlyProgress) _then) = __$MonthlyProgressCopyWithImpl;
@override @useResult
$Res call({
 int year, int month, List<DailySummaryPoint> days, MacroAverages averages, int calorieTarget, int daysOnTarget, int activeDays
});


@override $MacroAveragesCopyWith<$Res> get averages;

}
/// @nodoc
class __$MonthlyProgressCopyWithImpl<$Res>
    implements _$MonthlyProgressCopyWith<$Res> {
  __$MonthlyProgressCopyWithImpl(this._self, this._then);

  final _MonthlyProgress _self;
  final $Res Function(_MonthlyProgress) _then;

/// Create a copy of MonthlyProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? year = null,Object? month = null,Object? days = null,Object? averages = null,Object? calorieTarget = null,Object? daysOnTarget = null,Object? activeDays = null,}) {
  return _then(_MonthlyProgress(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,days: null == days ? _self._days : days // ignore: cast_nullable_to_non_nullable
as List<DailySummaryPoint>,averages: null == averages ? _self.averages : averages // ignore: cast_nullable_to_non_nullable
as MacroAverages,calorieTarget: null == calorieTarget ? _self.calorieTarget : calorieTarget // ignore: cast_nullable_to_non_nullable
as int,daysOnTarget: null == daysOnTarget ? _self.daysOnTarget : daysOnTarget // ignore: cast_nullable_to_non_nullable
as int,activeDays: null == activeDays ? _self.activeDays : activeDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of MonthlyProgress
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MacroAveragesCopyWith<$Res> get averages {
  
  return $MacroAveragesCopyWith<$Res>(_self.averages, (value) {
    return _then(_self.copyWith(averages: value));
  });
}
}

// dart format on
