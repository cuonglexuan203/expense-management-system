// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_token.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DeviceToken _$DeviceTokenFromJson(Map<String, dynamic> json) {
  return _DeviceToken.fromJson(json);
}

/// @nodoc
mixin _$DeviceToken {
  String get token => throw _privateConstructorUsedError;
  DevicePlatform get platform => throw _privateConstructorUsedError;

  /// Serializes this DeviceToken to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeviceToken
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeviceTokenCopyWith<DeviceToken> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceTokenCopyWith<$Res> {
  factory $DeviceTokenCopyWith(
          DeviceToken value, $Res Function(DeviceToken) then) =
      _$DeviceTokenCopyWithImpl<$Res, DeviceToken>;
  @useResult
  $Res call({String token, DevicePlatform platform});
}

/// @nodoc
class _$DeviceTokenCopyWithImpl<$Res, $Val extends DeviceToken>
    implements $DeviceTokenCopyWith<$Res> {
  _$DeviceTokenCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeviceToken
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? platform = null,
  }) {
    return _then(_value.copyWith(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as DevicePlatform,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeviceTokenImplCopyWith<$Res>
    implements $DeviceTokenCopyWith<$Res> {
  factory _$$DeviceTokenImplCopyWith(
          _$DeviceTokenImpl value, $Res Function(_$DeviceTokenImpl) then) =
      __$$DeviceTokenImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String token, DevicePlatform platform});
}

/// @nodoc
class __$$DeviceTokenImplCopyWithImpl<$Res>
    extends _$DeviceTokenCopyWithImpl<$Res, _$DeviceTokenImpl>
    implements _$$DeviceTokenImplCopyWith<$Res> {
  __$$DeviceTokenImplCopyWithImpl(
      _$DeviceTokenImpl _value, $Res Function(_$DeviceTokenImpl) _then)
      : super(_value, _then);

  /// Create a copy of DeviceToken
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? platform = null,
  }) {
    return _then(_$DeviceTokenImpl(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as DevicePlatform,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeviceTokenImpl implements _DeviceToken {
  const _$DeviceTokenImpl({required this.token, required this.platform});

  factory _$DeviceTokenImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeviceTokenImplFromJson(json);

  @override
  final String token;
  @override
  final DevicePlatform platform;

  @override
  String toString() {
    return 'DeviceToken(token: $token, platform: $platform)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceTokenImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.platform, platform) ||
                other.platform == platform));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, token, platform);

  /// Create a copy of DeviceToken
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeviceTokenImplCopyWith<_$DeviceTokenImpl> get copyWith =>
      __$$DeviceTokenImplCopyWithImpl<_$DeviceTokenImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeviceTokenImplToJson(
      this,
    );
  }
}

abstract class _DeviceToken implements DeviceToken {
  const factory _DeviceToken(
      {required final String token,
      required final DevicePlatform platform}) = _$DeviceTokenImpl;

  factory _DeviceToken.fromJson(Map<String, dynamic> json) =
      _$DeviceTokenImpl.fromJson;

  @override
  String get token;
  @override
  DevicePlatform get platform;

  /// Create a copy of DeviceToken
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeviceTokenImplCopyWith<_$DeviceTokenImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
