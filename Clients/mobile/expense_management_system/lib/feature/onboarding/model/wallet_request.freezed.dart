// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WalletRequest _$WalletRequestFromJson(Map<String, dynamic> json) {
  return _WalletRequest.fromJson(json);
}

/// @nodoc
mixin _$WalletRequest {
  String get name => throw _privateConstructorUsedError;
  double get balance => throw _privateConstructorUsedError;

  /// Serializes this WalletRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WalletRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WalletRequestCopyWith<WalletRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletRequestCopyWith<$Res> {
  factory $WalletRequestCopyWith(
          WalletRequest value, $Res Function(WalletRequest) then) =
      _$WalletRequestCopyWithImpl<$Res, WalletRequest>;
  @useResult
  $Res call({String name, double balance});
}

/// @nodoc
class _$WalletRequestCopyWithImpl<$Res, $Val extends WalletRequest>
    implements $WalletRequestCopyWith<$Res> {
  _$WalletRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WalletRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? balance = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WalletRequestImplCopyWith<$Res>
    implements $WalletRequestCopyWith<$Res> {
  factory _$$WalletRequestImplCopyWith(
          _$WalletRequestImpl value, $Res Function(_$WalletRequestImpl) then) =
      __$$WalletRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, double balance});
}

/// @nodoc
class __$$WalletRequestImplCopyWithImpl<$Res>
    extends _$WalletRequestCopyWithImpl<$Res, _$WalletRequestImpl>
    implements _$$WalletRequestImplCopyWith<$Res> {
  __$$WalletRequestImplCopyWithImpl(
      _$WalletRequestImpl _value, $Res Function(_$WalletRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of WalletRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? balance = null,
  }) {
    return _then(_$WalletRequestImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WalletRequestImpl implements _WalletRequest {
  const _$WalletRequestImpl({required this.name, required this.balance});

  factory _$WalletRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$WalletRequestImplFromJson(json);

  @override
  final String name;
  @override
  final double balance;

  @override
  String toString() {
    return 'WalletRequest(name: $name, balance: $balance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletRequestImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.balance, balance) || other.balance == balance));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, balance);

  /// Create a copy of WalletRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WalletRequestImplCopyWith<_$WalletRequestImpl> get copyWith =>
      __$$WalletRequestImplCopyWithImpl<_$WalletRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WalletRequestImplToJson(
      this,
    );
  }
}

abstract class _WalletRequest implements WalletRequest {
  const factory _WalletRequest(
      {required final String name,
      required final double balance}) = _$WalletRequestImpl;

  factory _WalletRequest.fromJson(Map<String, dynamic> json) =
      _$WalletRequestImpl.fromJson;

  @override
  String get name;
  @override
  double get balance;

  /// Create a copy of WalletRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WalletRequestImplCopyWith<_$WalletRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
