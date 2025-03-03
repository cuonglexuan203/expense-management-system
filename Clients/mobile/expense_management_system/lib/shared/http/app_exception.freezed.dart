// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_exception.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AppException {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() connectivity,
    required TResult Function() unauthorized,
    required TResult Function(String message) errorWithMessage,
    required TResult Function() error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? connectivity,
    TResult? Function()? unauthorized,
    TResult? Function(String message)? errorWithMessage,
    TResult? Function()? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? connectivity,
    TResult Function()? unauthorized,
    TResult Function(String message)? errorWithMessage,
    TResult Function()? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AppExceptionConnectivity value) connectivity,
    required TResult Function(AppExceptionUnauthorized value) unauthorized,
    required TResult Function(_AppExceptionErrorMessage value) errorWithMessage,
    required TResult Function(_AppExceptionError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AppExceptionConnectivity value)? connectivity,
    TResult? Function(AppExceptionUnauthorized value)? unauthorized,
    TResult? Function(_AppExceptionErrorMessage value)? errorWithMessage,
    TResult? Function(_AppExceptionError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AppExceptionConnectivity value)? connectivity,
    TResult Function(AppExceptionUnauthorized value)? unauthorized,
    TResult Function(_AppExceptionErrorMessage value)? errorWithMessage,
    TResult Function(_AppExceptionError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppExceptionCopyWith<$Res> {
  factory $AppExceptionCopyWith(
          AppException value, $Res Function(AppException) then) =
      _$AppExceptionCopyWithImpl<$Res, AppException>;
}

/// @nodoc
class _$AppExceptionCopyWithImpl<$Res, $Val extends AppException>
    implements $AppExceptionCopyWith<$Res> {
  _$AppExceptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$AppExceptionConnectivityImplCopyWith<$Res> {
  factory _$$AppExceptionConnectivityImplCopyWith(
          _$AppExceptionConnectivityImpl value,
          $Res Function(_$AppExceptionConnectivityImpl) then) =
      __$$AppExceptionConnectivityImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AppExceptionConnectivityImplCopyWithImpl<$Res>
    extends _$AppExceptionCopyWithImpl<$Res, _$AppExceptionConnectivityImpl>
    implements _$$AppExceptionConnectivityImplCopyWith<$Res> {
  __$$AppExceptionConnectivityImplCopyWithImpl(
      _$AppExceptionConnectivityImpl _value,
      $Res Function(_$AppExceptionConnectivityImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AppExceptionConnectivityImpl implements AppExceptionConnectivity {
  const _$AppExceptionConnectivityImpl();

  @override
  String toString() {
    return 'AppException.connectivity()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppExceptionConnectivityImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() connectivity,
    required TResult Function() unauthorized,
    required TResult Function(String message) errorWithMessage,
    required TResult Function() error,
  }) {
    return connectivity();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? connectivity,
    TResult? Function()? unauthorized,
    TResult? Function(String message)? errorWithMessage,
    TResult? Function()? error,
  }) {
    return connectivity?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? connectivity,
    TResult Function()? unauthorized,
    TResult Function(String message)? errorWithMessage,
    TResult Function()? error,
    required TResult orElse(),
  }) {
    if (connectivity != null) {
      return connectivity();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AppExceptionConnectivity value) connectivity,
    required TResult Function(AppExceptionUnauthorized value) unauthorized,
    required TResult Function(_AppExceptionErrorMessage value) errorWithMessage,
    required TResult Function(_AppExceptionError value) error,
  }) {
    return connectivity(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AppExceptionConnectivity value)? connectivity,
    TResult? Function(AppExceptionUnauthorized value)? unauthorized,
    TResult? Function(_AppExceptionErrorMessage value)? errorWithMessage,
    TResult? Function(_AppExceptionError value)? error,
  }) {
    return connectivity?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AppExceptionConnectivity value)? connectivity,
    TResult Function(AppExceptionUnauthorized value)? unauthorized,
    TResult Function(_AppExceptionErrorMessage value)? errorWithMessage,
    TResult Function(_AppExceptionError value)? error,
    required TResult orElse(),
  }) {
    if (connectivity != null) {
      return connectivity(this);
    }
    return orElse();
  }
}

abstract class AppExceptionConnectivity implements AppException {
  const factory AppExceptionConnectivity() = _$AppExceptionConnectivityImpl;
}

/// @nodoc
abstract class _$$AppExceptionUnauthorizedImplCopyWith<$Res> {
  factory _$$AppExceptionUnauthorizedImplCopyWith(
          _$AppExceptionUnauthorizedImpl value,
          $Res Function(_$AppExceptionUnauthorizedImpl) then) =
      __$$AppExceptionUnauthorizedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AppExceptionUnauthorizedImplCopyWithImpl<$Res>
    extends _$AppExceptionCopyWithImpl<$Res, _$AppExceptionUnauthorizedImpl>
    implements _$$AppExceptionUnauthorizedImplCopyWith<$Res> {
  __$$AppExceptionUnauthorizedImplCopyWithImpl(
      _$AppExceptionUnauthorizedImpl _value,
      $Res Function(_$AppExceptionUnauthorizedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AppExceptionUnauthorizedImpl implements AppExceptionUnauthorized {
  const _$AppExceptionUnauthorizedImpl();

  @override
  String toString() {
    return 'AppException.unauthorized()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppExceptionUnauthorizedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() connectivity,
    required TResult Function() unauthorized,
    required TResult Function(String message) errorWithMessage,
    required TResult Function() error,
  }) {
    return unauthorized();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? connectivity,
    TResult? Function()? unauthorized,
    TResult? Function(String message)? errorWithMessage,
    TResult? Function()? error,
  }) {
    return unauthorized?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? connectivity,
    TResult Function()? unauthorized,
    TResult Function(String message)? errorWithMessage,
    TResult Function()? error,
    required TResult orElse(),
  }) {
    if (unauthorized != null) {
      return unauthorized();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AppExceptionConnectivity value) connectivity,
    required TResult Function(AppExceptionUnauthorized value) unauthorized,
    required TResult Function(_AppExceptionErrorMessage value) errorWithMessage,
    required TResult Function(_AppExceptionError value) error,
  }) {
    return unauthorized(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AppExceptionConnectivity value)? connectivity,
    TResult? Function(AppExceptionUnauthorized value)? unauthorized,
    TResult? Function(_AppExceptionErrorMessage value)? errorWithMessage,
    TResult? Function(_AppExceptionError value)? error,
  }) {
    return unauthorized?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AppExceptionConnectivity value)? connectivity,
    TResult Function(AppExceptionUnauthorized value)? unauthorized,
    TResult Function(_AppExceptionErrorMessage value)? errorWithMessage,
    TResult Function(_AppExceptionError value)? error,
    required TResult orElse(),
  }) {
    if (unauthorized != null) {
      return unauthorized(this);
    }
    return orElse();
  }
}

abstract class AppExceptionUnauthorized implements AppException {
  const factory AppExceptionUnauthorized() = _$AppExceptionUnauthorizedImpl;
}

/// @nodoc
abstract class _$$AppExceptionErrorMessageImplCopyWith<$Res> {
  factory _$$AppExceptionErrorMessageImplCopyWith(
          _$AppExceptionErrorMessageImpl value,
          $Res Function(_$AppExceptionErrorMessageImpl) then) =
      __$$AppExceptionErrorMessageImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$AppExceptionErrorMessageImplCopyWithImpl<$Res>
    extends _$AppExceptionCopyWithImpl<$Res, _$AppExceptionErrorMessageImpl>
    implements _$$AppExceptionErrorMessageImplCopyWith<$Res> {
  __$$AppExceptionErrorMessageImplCopyWithImpl(
      _$AppExceptionErrorMessageImpl _value,
      $Res Function(_$AppExceptionErrorMessageImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$AppExceptionErrorMessageImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AppExceptionErrorMessageImpl implements _AppExceptionErrorMessage {
  const _$AppExceptionErrorMessageImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'AppException.errorWithMessage(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppExceptionErrorMessageImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppExceptionErrorMessageImplCopyWith<_$AppExceptionErrorMessageImpl>
      get copyWith => __$$AppExceptionErrorMessageImplCopyWithImpl<
          _$AppExceptionErrorMessageImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() connectivity,
    required TResult Function() unauthorized,
    required TResult Function(String message) errorWithMessage,
    required TResult Function() error,
  }) {
    return errorWithMessage(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? connectivity,
    TResult? Function()? unauthorized,
    TResult? Function(String message)? errorWithMessage,
    TResult? Function()? error,
  }) {
    return errorWithMessage?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? connectivity,
    TResult Function()? unauthorized,
    TResult Function(String message)? errorWithMessage,
    TResult Function()? error,
    required TResult orElse(),
  }) {
    if (errorWithMessage != null) {
      return errorWithMessage(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AppExceptionConnectivity value) connectivity,
    required TResult Function(AppExceptionUnauthorized value) unauthorized,
    required TResult Function(_AppExceptionErrorMessage value) errorWithMessage,
    required TResult Function(_AppExceptionError value) error,
  }) {
    return errorWithMessage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AppExceptionConnectivity value)? connectivity,
    TResult? Function(AppExceptionUnauthorized value)? unauthorized,
    TResult? Function(_AppExceptionErrorMessage value)? errorWithMessage,
    TResult? Function(_AppExceptionError value)? error,
  }) {
    return errorWithMessage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AppExceptionConnectivity value)? connectivity,
    TResult Function(AppExceptionUnauthorized value)? unauthorized,
    TResult Function(_AppExceptionErrorMessage value)? errorWithMessage,
    TResult Function(_AppExceptionError value)? error,
    required TResult orElse(),
  }) {
    if (errorWithMessage != null) {
      return errorWithMessage(this);
    }
    return orElse();
  }
}

abstract class _AppExceptionErrorMessage implements AppException {
  const factory _AppExceptionErrorMessage(final String message) =
      _$AppExceptionErrorMessageImpl;

  String get message;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppExceptionErrorMessageImplCopyWith<_$AppExceptionErrorMessageImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AppExceptionErrorImplCopyWith<$Res> {
  factory _$$AppExceptionErrorImplCopyWith(_$AppExceptionErrorImpl value,
          $Res Function(_$AppExceptionErrorImpl) then) =
      __$$AppExceptionErrorImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AppExceptionErrorImplCopyWithImpl<$Res>
    extends _$AppExceptionCopyWithImpl<$Res, _$AppExceptionErrorImpl>
    implements _$$AppExceptionErrorImplCopyWith<$Res> {
  __$$AppExceptionErrorImplCopyWithImpl(_$AppExceptionErrorImpl _value,
      $Res Function(_$AppExceptionErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AppExceptionErrorImpl implements _AppExceptionError {
  const _$AppExceptionErrorImpl();

  @override
  String toString() {
    return 'AppException.error()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AppExceptionErrorImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() connectivity,
    required TResult Function() unauthorized,
    required TResult Function(String message) errorWithMessage,
    required TResult Function() error,
  }) {
    return error();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? connectivity,
    TResult? Function()? unauthorized,
    TResult? Function(String message)? errorWithMessage,
    TResult? Function()? error,
  }) {
    return error?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? connectivity,
    TResult Function()? unauthorized,
    TResult Function(String message)? errorWithMessage,
    TResult Function()? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AppExceptionConnectivity value) connectivity,
    required TResult Function(AppExceptionUnauthorized value) unauthorized,
    required TResult Function(_AppExceptionErrorMessage value) errorWithMessage,
    required TResult Function(_AppExceptionError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AppExceptionConnectivity value)? connectivity,
    TResult? Function(AppExceptionUnauthorized value)? unauthorized,
    TResult? Function(_AppExceptionErrorMessage value)? errorWithMessage,
    TResult? Function(_AppExceptionError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AppExceptionConnectivity value)? connectivity,
    TResult Function(AppExceptionUnauthorized value)? unauthorized,
    TResult Function(_AppExceptionErrorMessage value)? errorWithMessage,
    TResult Function(_AppExceptionError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _AppExceptionError implements AppException {
  const factory _AppExceptionError() = _$AppExceptionErrorImpl;
}
