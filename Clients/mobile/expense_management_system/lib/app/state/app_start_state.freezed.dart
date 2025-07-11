// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_start_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AppStartState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() unauthenticated,
    required TResult Function() internetUnAvailable,
    required TResult Function() authenticated,
    required TResult Function() authenticatedAnonymous,
    required TResult Function() requirePasscode,
    required TResult Function() requireOnboarding,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? unauthenticated,
    TResult? Function()? internetUnAvailable,
    TResult? Function()? authenticated,
    TResult? Function()? authenticatedAnonymous,
    TResult? Function()? requirePasscode,
    TResult? Function()? requireOnboarding,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? unauthenticated,
    TResult Function()? internetUnAvailable,
    TResult Function()? authenticated,
    TResult Function()? authenticatedAnonymous,
    TResult Function()? requirePasscode,
    TResult Function()? requireOnboarding,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(Unauthenticated value) unauthenticated,
    required TResult Function(_InternetUnAvailable value) internetUnAvailable,
    required TResult Function(AppAuthenticated value) authenticated,
    required TResult Function(AppAuthenticatedAnonymous value)
        authenticatedAnonymous,
    required TResult Function(_RequirePasscode value) requirePasscode,
    required TResult Function(_RequireOnboarding value) requireOnboarding,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(Unauthenticated value)? unauthenticated,
    TResult? Function(_InternetUnAvailable value)? internetUnAvailable,
    TResult? Function(AppAuthenticated value)? authenticated,
    TResult? Function(AppAuthenticatedAnonymous value)? authenticatedAnonymous,
    TResult? Function(_RequirePasscode value)? requirePasscode,
    TResult? Function(_RequireOnboarding value)? requireOnboarding,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(Unauthenticated value)? unauthenticated,
    TResult Function(_InternetUnAvailable value)? internetUnAvailable,
    TResult Function(AppAuthenticated value)? authenticated,
    TResult Function(AppAuthenticatedAnonymous value)? authenticatedAnonymous,
    TResult Function(_RequirePasscode value)? requirePasscode,
    TResult Function(_RequireOnboarding value)? requireOnboarding,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppStartStateCopyWith<$Res> {
  factory $AppStartStateCopyWith(
          AppStartState value, $Res Function(AppStartState) then) =
      _$AppStartStateCopyWithImpl<$Res, AppStartState>;
}

/// @nodoc
class _$AppStartStateCopyWithImpl<$Res, $Val extends AppStartState>
    implements $AppStartStateCopyWith<$Res> {
  _$AppStartStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppStartState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl value, $Res Function(_$InitialImpl) then) =
      __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$AppStartStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppStartState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'AppStartState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() unauthenticated,
    required TResult Function() internetUnAvailable,
    required TResult Function() authenticated,
    required TResult Function() authenticatedAnonymous,
    required TResult Function() requirePasscode,
    required TResult Function() requireOnboarding,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? unauthenticated,
    TResult? Function()? internetUnAvailable,
    TResult? Function()? authenticated,
    TResult? Function()? authenticatedAnonymous,
    TResult? Function()? requirePasscode,
    TResult? Function()? requireOnboarding,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? unauthenticated,
    TResult Function()? internetUnAvailable,
    TResult Function()? authenticated,
    TResult Function()? authenticatedAnonymous,
    TResult Function()? requirePasscode,
    TResult Function()? requireOnboarding,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(Unauthenticated value) unauthenticated,
    required TResult Function(_InternetUnAvailable value) internetUnAvailable,
    required TResult Function(AppAuthenticated value) authenticated,
    required TResult Function(AppAuthenticatedAnonymous value)
        authenticatedAnonymous,
    required TResult Function(_RequirePasscode value) requirePasscode,
    required TResult Function(_RequireOnboarding value) requireOnboarding,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(Unauthenticated value)? unauthenticated,
    TResult? Function(_InternetUnAvailable value)? internetUnAvailable,
    TResult? Function(AppAuthenticated value)? authenticated,
    TResult? Function(AppAuthenticatedAnonymous value)? authenticatedAnonymous,
    TResult? Function(_RequirePasscode value)? requirePasscode,
    TResult? Function(_RequireOnboarding value)? requireOnboarding,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(Unauthenticated value)? unauthenticated,
    TResult Function(_InternetUnAvailable value)? internetUnAvailable,
    TResult Function(AppAuthenticated value)? authenticated,
    TResult Function(AppAuthenticatedAnonymous value)? authenticatedAnonymous,
    TResult Function(_RequirePasscode value)? requirePasscode,
    TResult Function(_RequireOnboarding value)? requireOnboarding,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements AppStartState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$UnauthenticatedImplCopyWith<$Res> {
  factory _$$UnauthenticatedImplCopyWith(_$UnauthenticatedImpl value,
          $Res Function(_$UnauthenticatedImpl) then) =
      __$$UnauthenticatedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UnauthenticatedImplCopyWithImpl<$Res>
    extends _$AppStartStateCopyWithImpl<$Res, _$UnauthenticatedImpl>
    implements _$$UnauthenticatedImplCopyWith<$Res> {
  __$$UnauthenticatedImplCopyWithImpl(
      _$UnauthenticatedImpl _value, $Res Function(_$UnauthenticatedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppStartState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$UnauthenticatedImpl implements Unauthenticated {
  const _$UnauthenticatedImpl();

  @override
  String toString() {
    return 'AppStartState.unauthenticated()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UnauthenticatedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() unauthenticated,
    required TResult Function() internetUnAvailable,
    required TResult Function() authenticated,
    required TResult Function() authenticatedAnonymous,
    required TResult Function() requirePasscode,
    required TResult Function() requireOnboarding,
  }) {
    return unauthenticated();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? unauthenticated,
    TResult? Function()? internetUnAvailable,
    TResult? Function()? authenticated,
    TResult? Function()? authenticatedAnonymous,
    TResult? Function()? requirePasscode,
    TResult? Function()? requireOnboarding,
  }) {
    return unauthenticated?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? unauthenticated,
    TResult Function()? internetUnAvailable,
    TResult Function()? authenticated,
    TResult Function()? authenticatedAnonymous,
    TResult Function()? requirePasscode,
    TResult Function()? requireOnboarding,
    required TResult orElse(),
  }) {
    if (unauthenticated != null) {
      return unauthenticated();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(Unauthenticated value) unauthenticated,
    required TResult Function(_InternetUnAvailable value) internetUnAvailable,
    required TResult Function(AppAuthenticated value) authenticated,
    required TResult Function(AppAuthenticatedAnonymous value)
        authenticatedAnonymous,
    required TResult Function(_RequirePasscode value) requirePasscode,
    required TResult Function(_RequireOnboarding value) requireOnboarding,
  }) {
    return unauthenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(Unauthenticated value)? unauthenticated,
    TResult? Function(_InternetUnAvailable value)? internetUnAvailable,
    TResult? Function(AppAuthenticated value)? authenticated,
    TResult? Function(AppAuthenticatedAnonymous value)? authenticatedAnonymous,
    TResult? Function(_RequirePasscode value)? requirePasscode,
    TResult? Function(_RequireOnboarding value)? requireOnboarding,
  }) {
    return unauthenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(Unauthenticated value)? unauthenticated,
    TResult Function(_InternetUnAvailable value)? internetUnAvailable,
    TResult Function(AppAuthenticated value)? authenticated,
    TResult Function(AppAuthenticatedAnonymous value)? authenticatedAnonymous,
    TResult Function(_RequirePasscode value)? requirePasscode,
    TResult Function(_RequireOnboarding value)? requireOnboarding,
    required TResult orElse(),
  }) {
    if (unauthenticated != null) {
      return unauthenticated(this);
    }
    return orElse();
  }
}

abstract class Unauthenticated implements AppStartState {
  const factory Unauthenticated() = _$UnauthenticatedImpl;
}

/// @nodoc
abstract class _$$InternetUnAvailableImplCopyWith<$Res> {
  factory _$$InternetUnAvailableImplCopyWith(_$InternetUnAvailableImpl value,
          $Res Function(_$InternetUnAvailableImpl) then) =
      __$$InternetUnAvailableImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InternetUnAvailableImplCopyWithImpl<$Res>
    extends _$AppStartStateCopyWithImpl<$Res, _$InternetUnAvailableImpl>
    implements _$$InternetUnAvailableImplCopyWith<$Res> {
  __$$InternetUnAvailableImplCopyWithImpl(_$InternetUnAvailableImpl _value,
      $Res Function(_$InternetUnAvailableImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppStartState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InternetUnAvailableImpl implements _InternetUnAvailable {
  const _$InternetUnAvailableImpl();

  @override
  String toString() {
    return 'AppStartState.internetUnAvailable()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InternetUnAvailableImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() unauthenticated,
    required TResult Function() internetUnAvailable,
    required TResult Function() authenticated,
    required TResult Function() authenticatedAnonymous,
    required TResult Function() requirePasscode,
    required TResult Function() requireOnboarding,
  }) {
    return internetUnAvailable();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? unauthenticated,
    TResult? Function()? internetUnAvailable,
    TResult? Function()? authenticated,
    TResult? Function()? authenticatedAnonymous,
    TResult? Function()? requirePasscode,
    TResult? Function()? requireOnboarding,
  }) {
    return internetUnAvailable?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? unauthenticated,
    TResult Function()? internetUnAvailable,
    TResult Function()? authenticated,
    TResult Function()? authenticatedAnonymous,
    TResult Function()? requirePasscode,
    TResult Function()? requireOnboarding,
    required TResult orElse(),
  }) {
    if (internetUnAvailable != null) {
      return internetUnAvailable();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(Unauthenticated value) unauthenticated,
    required TResult Function(_InternetUnAvailable value) internetUnAvailable,
    required TResult Function(AppAuthenticated value) authenticated,
    required TResult Function(AppAuthenticatedAnonymous value)
        authenticatedAnonymous,
    required TResult Function(_RequirePasscode value) requirePasscode,
    required TResult Function(_RequireOnboarding value) requireOnboarding,
  }) {
    return internetUnAvailable(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(Unauthenticated value)? unauthenticated,
    TResult? Function(_InternetUnAvailable value)? internetUnAvailable,
    TResult? Function(AppAuthenticated value)? authenticated,
    TResult? Function(AppAuthenticatedAnonymous value)? authenticatedAnonymous,
    TResult? Function(_RequirePasscode value)? requirePasscode,
    TResult? Function(_RequireOnboarding value)? requireOnboarding,
  }) {
    return internetUnAvailable?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(Unauthenticated value)? unauthenticated,
    TResult Function(_InternetUnAvailable value)? internetUnAvailable,
    TResult Function(AppAuthenticated value)? authenticated,
    TResult Function(AppAuthenticatedAnonymous value)? authenticatedAnonymous,
    TResult Function(_RequirePasscode value)? requirePasscode,
    TResult Function(_RequireOnboarding value)? requireOnboarding,
    required TResult orElse(),
  }) {
    if (internetUnAvailable != null) {
      return internetUnAvailable(this);
    }
    return orElse();
  }
}

abstract class _InternetUnAvailable implements AppStartState {
  const factory _InternetUnAvailable() = _$InternetUnAvailableImpl;
}

/// @nodoc
abstract class _$$AppAuthenticatedImplCopyWith<$Res> {
  factory _$$AppAuthenticatedImplCopyWith(_$AppAuthenticatedImpl value,
          $Res Function(_$AppAuthenticatedImpl) then) =
      __$$AppAuthenticatedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AppAuthenticatedImplCopyWithImpl<$Res>
    extends _$AppStartStateCopyWithImpl<$Res, _$AppAuthenticatedImpl>
    implements _$$AppAuthenticatedImplCopyWith<$Res> {
  __$$AppAuthenticatedImplCopyWithImpl(_$AppAuthenticatedImpl _value,
      $Res Function(_$AppAuthenticatedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppStartState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AppAuthenticatedImpl implements AppAuthenticated {
  const _$AppAuthenticatedImpl();

  @override
  String toString() {
    return 'AppStartState.authenticated()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AppAuthenticatedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() unauthenticated,
    required TResult Function() internetUnAvailable,
    required TResult Function() authenticated,
    required TResult Function() authenticatedAnonymous,
    required TResult Function() requirePasscode,
    required TResult Function() requireOnboarding,
  }) {
    return authenticated();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? unauthenticated,
    TResult? Function()? internetUnAvailable,
    TResult? Function()? authenticated,
    TResult? Function()? authenticatedAnonymous,
    TResult? Function()? requirePasscode,
    TResult? Function()? requireOnboarding,
  }) {
    return authenticated?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? unauthenticated,
    TResult Function()? internetUnAvailable,
    TResult Function()? authenticated,
    TResult Function()? authenticatedAnonymous,
    TResult Function()? requirePasscode,
    TResult Function()? requireOnboarding,
    required TResult orElse(),
  }) {
    if (authenticated != null) {
      return authenticated();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(Unauthenticated value) unauthenticated,
    required TResult Function(_InternetUnAvailable value) internetUnAvailable,
    required TResult Function(AppAuthenticated value) authenticated,
    required TResult Function(AppAuthenticatedAnonymous value)
        authenticatedAnonymous,
    required TResult Function(_RequirePasscode value) requirePasscode,
    required TResult Function(_RequireOnboarding value) requireOnboarding,
  }) {
    return authenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(Unauthenticated value)? unauthenticated,
    TResult? Function(_InternetUnAvailable value)? internetUnAvailable,
    TResult? Function(AppAuthenticated value)? authenticated,
    TResult? Function(AppAuthenticatedAnonymous value)? authenticatedAnonymous,
    TResult? Function(_RequirePasscode value)? requirePasscode,
    TResult? Function(_RequireOnboarding value)? requireOnboarding,
  }) {
    return authenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(Unauthenticated value)? unauthenticated,
    TResult Function(_InternetUnAvailable value)? internetUnAvailable,
    TResult Function(AppAuthenticated value)? authenticated,
    TResult Function(AppAuthenticatedAnonymous value)? authenticatedAnonymous,
    TResult Function(_RequirePasscode value)? requirePasscode,
    TResult Function(_RequireOnboarding value)? requireOnboarding,
    required TResult orElse(),
  }) {
    if (authenticated != null) {
      return authenticated(this);
    }
    return orElse();
  }
}

abstract class AppAuthenticated implements AppStartState {
  const factory AppAuthenticated() = _$AppAuthenticatedImpl;
}

/// @nodoc
abstract class _$$AppAuthenticatedAnonymousImplCopyWith<$Res> {
  factory _$$AppAuthenticatedAnonymousImplCopyWith(
          _$AppAuthenticatedAnonymousImpl value,
          $Res Function(_$AppAuthenticatedAnonymousImpl) then) =
      __$$AppAuthenticatedAnonymousImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AppAuthenticatedAnonymousImplCopyWithImpl<$Res>
    extends _$AppStartStateCopyWithImpl<$Res, _$AppAuthenticatedAnonymousImpl>
    implements _$$AppAuthenticatedAnonymousImplCopyWith<$Res> {
  __$$AppAuthenticatedAnonymousImplCopyWithImpl(
      _$AppAuthenticatedAnonymousImpl _value,
      $Res Function(_$AppAuthenticatedAnonymousImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppStartState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AppAuthenticatedAnonymousImpl implements AppAuthenticatedAnonymous {
  const _$AppAuthenticatedAnonymousImpl();

  @override
  String toString() {
    return 'AppStartState.authenticatedAnonymous()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppAuthenticatedAnonymousImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() unauthenticated,
    required TResult Function() internetUnAvailable,
    required TResult Function() authenticated,
    required TResult Function() authenticatedAnonymous,
    required TResult Function() requirePasscode,
    required TResult Function() requireOnboarding,
  }) {
    return authenticatedAnonymous();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? unauthenticated,
    TResult? Function()? internetUnAvailable,
    TResult? Function()? authenticated,
    TResult? Function()? authenticatedAnonymous,
    TResult? Function()? requirePasscode,
    TResult? Function()? requireOnboarding,
  }) {
    return authenticatedAnonymous?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? unauthenticated,
    TResult Function()? internetUnAvailable,
    TResult Function()? authenticated,
    TResult Function()? authenticatedAnonymous,
    TResult Function()? requirePasscode,
    TResult Function()? requireOnboarding,
    required TResult orElse(),
  }) {
    if (authenticatedAnonymous != null) {
      return authenticatedAnonymous();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(Unauthenticated value) unauthenticated,
    required TResult Function(_InternetUnAvailable value) internetUnAvailable,
    required TResult Function(AppAuthenticated value) authenticated,
    required TResult Function(AppAuthenticatedAnonymous value)
        authenticatedAnonymous,
    required TResult Function(_RequirePasscode value) requirePasscode,
    required TResult Function(_RequireOnboarding value) requireOnboarding,
  }) {
    return authenticatedAnonymous(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(Unauthenticated value)? unauthenticated,
    TResult? Function(_InternetUnAvailable value)? internetUnAvailable,
    TResult? Function(AppAuthenticated value)? authenticated,
    TResult? Function(AppAuthenticatedAnonymous value)? authenticatedAnonymous,
    TResult? Function(_RequirePasscode value)? requirePasscode,
    TResult? Function(_RequireOnboarding value)? requireOnboarding,
  }) {
    return authenticatedAnonymous?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(Unauthenticated value)? unauthenticated,
    TResult Function(_InternetUnAvailable value)? internetUnAvailable,
    TResult Function(AppAuthenticated value)? authenticated,
    TResult Function(AppAuthenticatedAnonymous value)? authenticatedAnonymous,
    TResult Function(_RequirePasscode value)? requirePasscode,
    TResult Function(_RequireOnboarding value)? requireOnboarding,
    required TResult orElse(),
  }) {
    if (authenticatedAnonymous != null) {
      return authenticatedAnonymous(this);
    }
    return orElse();
  }
}

abstract class AppAuthenticatedAnonymous implements AppStartState {
  const factory AppAuthenticatedAnonymous() = _$AppAuthenticatedAnonymousImpl;
}

/// @nodoc
abstract class _$$RequirePasscodeImplCopyWith<$Res> {
  factory _$$RequirePasscodeImplCopyWith(_$RequirePasscodeImpl value,
          $Res Function(_$RequirePasscodeImpl) then) =
      __$$RequirePasscodeImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RequirePasscodeImplCopyWithImpl<$Res>
    extends _$AppStartStateCopyWithImpl<$Res, _$RequirePasscodeImpl>
    implements _$$RequirePasscodeImplCopyWith<$Res> {
  __$$RequirePasscodeImplCopyWithImpl(
      _$RequirePasscodeImpl _value, $Res Function(_$RequirePasscodeImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppStartState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$RequirePasscodeImpl implements _RequirePasscode {
  const _$RequirePasscodeImpl();

  @override
  String toString() {
    return 'AppStartState.requirePasscode()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$RequirePasscodeImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() unauthenticated,
    required TResult Function() internetUnAvailable,
    required TResult Function() authenticated,
    required TResult Function() authenticatedAnonymous,
    required TResult Function() requirePasscode,
    required TResult Function() requireOnboarding,
  }) {
    return requirePasscode();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? unauthenticated,
    TResult? Function()? internetUnAvailable,
    TResult? Function()? authenticated,
    TResult? Function()? authenticatedAnonymous,
    TResult? Function()? requirePasscode,
    TResult? Function()? requireOnboarding,
  }) {
    return requirePasscode?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? unauthenticated,
    TResult Function()? internetUnAvailable,
    TResult Function()? authenticated,
    TResult Function()? authenticatedAnonymous,
    TResult Function()? requirePasscode,
    TResult Function()? requireOnboarding,
    required TResult orElse(),
  }) {
    if (requirePasscode != null) {
      return requirePasscode();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(Unauthenticated value) unauthenticated,
    required TResult Function(_InternetUnAvailable value) internetUnAvailable,
    required TResult Function(AppAuthenticated value) authenticated,
    required TResult Function(AppAuthenticatedAnonymous value)
        authenticatedAnonymous,
    required TResult Function(_RequirePasscode value) requirePasscode,
    required TResult Function(_RequireOnboarding value) requireOnboarding,
  }) {
    return requirePasscode(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(Unauthenticated value)? unauthenticated,
    TResult? Function(_InternetUnAvailable value)? internetUnAvailable,
    TResult? Function(AppAuthenticated value)? authenticated,
    TResult? Function(AppAuthenticatedAnonymous value)? authenticatedAnonymous,
    TResult? Function(_RequirePasscode value)? requirePasscode,
    TResult? Function(_RequireOnboarding value)? requireOnboarding,
  }) {
    return requirePasscode?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(Unauthenticated value)? unauthenticated,
    TResult Function(_InternetUnAvailable value)? internetUnAvailable,
    TResult Function(AppAuthenticated value)? authenticated,
    TResult Function(AppAuthenticatedAnonymous value)? authenticatedAnonymous,
    TResult Function(_RequirePasscode value)? requirePasscode,
    TResult Function(_RequireOnboarding value)? requireOnboarding,
    required TResult orElse(),
  }) {
    if (requirePasscode != null) {
      return requirePasscode(this);
    }
    return orElse();
  }
}

abstract class _RequirePasscode implements AppStartState {
  const factory _RequirePasscode() = _$RequirePasscodeImpl;
}

/// @nodoc
abstract class _$$RequireOnboardingImplCopyWith<$Res> {
  factory _$$RequireOnboardingImplCopyWith(_$RequireOnboardingImpl value,
          $Res Function(_$RequireOnboardingImpl) then) =
      __$$RequireOnboardingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RequireOnboardingImplCopyWithImpl<$Res>
    extends _$AppStartStateCopyWithImpl<$Res, _$RequireOnboardingImpl>
    implements _$$RequireOnboardingImplCopyWith<$Res> {
  __$$RequireOnboardingImplCopyWithImpl(_$RequireOnboardingImpl _value,
      $Res Function(_$RequireOnboardingImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppStartState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$RequireOnboardingImpl implements _RequireOnboarding {
  const _$RequireOnboardingImpl();

  @override
  String toString() {
    return 'AppStartState.requireOnboarding()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$RequireOnboardingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() unauthenticated,
    required TResult Function() internetUnAvailable,
    required TResult Function() authenticated,
    required TResult Function() authenticatedAnonymous,
    required TResult Function() requirePasscode,
    required TResult Function() requireOnboarding,
  }) {
    return requireOnboarding();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? unauthenticated,
    TResult? Function()? internetUnAvailable,
    TResult? Function()? authenticated,
    TResult? Function()? authenticatedAnonymous,
    TResult? Function()? requirePasscode,
    TResult? Function()? requireOnboarding,
  }) {
    return requireOnboarding?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? unauthenticated,
    TResult Function()? internetUnAvailable,
    TResult Function()? authenticated,
    TResult Function()? authenticatedAnonymous,
    TResult Function()? requirePasscode,
    TResult Function()? requireOnboarding,
    required TResult orElse(),
  }) {
    if (requireOnboarding != null) {
      return requireOnboarding();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(Unauthenticated value) unauthenticated,
    required TResult Function(_InternetUnAvailable value) internetUnAvailable,
    required TResult Function(AppAuthenticated value) authenticated,
    required TResult Function(AppAuthenticatedAnonymous value)
        authenticatedAnonymous,
    required TResult Function(_RequirePasscode value) requirePasscode,
    required TResult Function(_RequireOnboarding value) requireOnboarding,
  }) {
    return requireOnboarding(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(Unauthenticated value)? unauthenticated,
    TResult? Function(_InternetUnAvailable value)? internetUnAvailable,
    TResult? Function(AppAuthenticated value)? authenticated,
    TResult? Function(AppAuthenticatedAnonymous value)? authenticatedAnonymous,
    TResult? Function(_RequirePasscode value)? requirePasscode,
    TResult? Function(_RequireOnboarding value)? requireOnboarding,
  }) {
    return requireOnboarding?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(Unauthenticated value)? unauthenticated,
    TResult Function(_InternetUnAvailable value)? internetUnAvailable,
    TResult Function(AppAuthenticated value)? authenticated,
    TResult Function(AppAuthenticatedAnonymous value)? authenticatedAnonymous,
    TResult Function(_RequirePasscode value)? requirePasscode,
    TResult Function(_RequireOnboarding value)? requireOnboarding,
    required TResult orElse(),
  }) {
    if (requireOnboarding != null) {
      return requireOnboarding(this);
    }
    return orElse();
  }
}

abstract class _RequireOnboarding implements AppStartState {
  const factory _RequireOnboarding() = _$RequireOnboardingImpl;
}
