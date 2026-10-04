// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reset_password_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ResetPasswordRequestDto {

 String get email; String get token; String get password;@JsonKey(name: 'password_confirmation') String get passwordConfirmation;
/// Create a copy of ResetPasswordRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResetPasswordRequestDtoCopyWith<ResetPasswordRequestDto> get copyWith => _$ResetPasswordRequestDtoCopyWithImpl<ResetPasswordRequestDto>(this as ResetPasswordRequestDto, _$identity);

  /// Serializes this ResetPasswordRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ResetPasswordRequestDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetPasswordRequestDto&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.token, _this.token) || other.token == _this.token)&&(identical(other.password, _this.password) || other.password == _this.password)&&(identical(other.passwordConfirmation, _this.passwordConfirmation) || other.passwordConfirmation == _this.passwordConfirmation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ResetPasswordRequestDto;
  return Object.hash(runtimeType,_this.email,_this.token,_this.password,_this.passwordConfirmation);
}

@override
String toString() {
  final _this = this as ResetPasswordRequestDto;
  return 'ResetPasswordRequestDto(email: ${_this.email}, token: ${_this.token}, password: ${_this.password}, passwordConfirmation: ${_this.passwordConfirmation})';
}


}

/// @nodoc
abstract mixin class $ResetPasswordRequestDtoCopyWith<$Res>  {
  factory $ResetPasswordRequestDtoCopyWith(ResetPasswordRequestDto value, $Res Function(ResetPasswordRequestDto) _then) = _$ResetPasswordRequestDtoCopyWithImpl;
@useResult
$Res call({
 String email, String token, String password,@JsonKey(name: 'password_confirmation') String passwordConfirmation
});




}
/// @nodoc
class _$ResetPasswordRequestDtoCopyWithImpl<$Res>
    implements $ResetPasswordRequestDtoCopyWith<$Res> {
  _$ResetPasswordRequestDtoCopyWithImpl(this._self, this._then);

  final ResetPasswordRequestDto _self;
  final $Res Function(ResetPasswordRequestDto) _then;

/// Create a copy of ResetPasswordRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? token = null,Object? password = null,Object? passwordConfirmation = null,}) {
  return _then(ResetPasswordRequestDto(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,passwordConfirmation: null == passwordConfirmation ? _self.passwordConfirmation : passwordConfirmation // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ResetPasswordRequestDto].
extension ResetPasswordRequestDtoPatterns on ResetPasswordRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResetPasswordRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResetPasswordRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResetPasswordRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _ResetPasswordRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResetPasswordRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _ResetPasswordRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String email,  String token,  String password, @JsonKey(name: 'password_confirmation')  String passwordConfirmation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResetPasswordRequestDto() when $default != null:
return $default(_that.email,_that.token,_that.password,_that.passwordConfirmation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String email,  String token,  String password, @JsonKey(name: 'password_confirmation')  String passwordConfirmation)  $default,) {final _that = this;
switch (_that) {
case _ResetPasswordRequestDto():
return $default(_that.email,_that.token,_that.password,_that.passwordConfirmation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String email,  String token,  String password, @JsonKey(name: 'password_confirmation')  String passwordConfirmation)?  $default,) {final _that = this;
switch (_that) {
case _ResetPasswordRequestDto() when $default != null:
return $default(_that.email,_that.token,_that.password,_that.passwordConfirmation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ResetPasswordRequestDto implements ResetPasswordRequestDto {
  const _ResetPasswordRequestDto({required this.email, required this.token, required this.password, @JsonKey(name: 'password_confirmation') required this.passwordConfirmation});
  factory _ResetPasswordRequestDto.fromJson(Map<String, dynamic> json) => _$ResetPasswordRequestDtoFromJson(json);

@override final  String email;
@override final  String token;
@override final  String password;
@override@JsonKey(name: 'password_confirmation') final  String passwordConfirmation;

/// Create a copy of ResetPasswordRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResetPasswordRequestDtoCopyWith<_ResetPasswordRequestDto> get copyWith => __$ResetPasswordRequestDtoCopyWithImpl<_ResetPasswordRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResetPasswordRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResetPasswordRequestDto&&(identical(other.email, email) || other.email == email)&&(identical(other.token, token) || other.token == token)&&(identical(other.password, password) || other.password == password)&&(identical(other.passwordConfirmation, passwordConfirmation) || other.passwordConfirmation == passwordConfirmation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,email,token,password,passwordConfirmation);
}

@override
String toString() {
    return 'ResetPasswordRequestDto(email: $email, token: $token, password: $password, passwordConfirmation: $passwordConfirmation)';
}


}

/// @nodoc
abstract mixin class _$ResetPasswordRequestDtoCopyWith<$Res> implements $ResetPasswordRequestDtoCopyWith<$Res> {
  factory _$ResetPasswordRequestDtoCopyWith(_ResetPasswordRequestDto value, $Res Function(_ResetPasswordRequestDto) _then) = __$ResetPasswordRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 String email, String token, String password,@JsonKey(name: 'password_confirmation') String passwordConfirmation
});




}
/// @nodoc
class __$ResetPasswordRequestDtoCopyWithImpl<$Res>
    implements _$ResetPasswordRequestDtoCopyWith<$Res> {
  __$ResetPasswordRequestDtoCopyWithImpl(this._self, this._then);

  final _ResetPasswordRequestDto _self;
  final $Res Function(_ResetPasswordRequestDto) _then;

/// Create a copy of ResetPasswordRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? token = null,Object? password = null,Object? passwordConfirmation = null,}) {
  return _then(_ResetPasswordRequestDto(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,passwordConfirmation: null == passwordConfirmation ? _self.passwordConfirmation : passwordConfirmation // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
