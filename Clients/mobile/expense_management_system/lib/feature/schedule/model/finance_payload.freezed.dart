// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'finance_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FinancePayload _$FinancePayloadFromJson(Map<String, dynamic> json) {
  return _FinancePayload.fromJson(json);
}

/// @nodoc
mixin _$FinancePayload {
  FinanceEventType get type => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  int get walletId => throw _privateConstructorUsedError;
  int get categoryId => throw _privateConstructorUsedError;

  /// Serializes this FinancePayload to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FinancePayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FinancePayloadCopyWith<FinancePayload> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinancePayloadCopyWith<$Res> {
  factory $FinancePayloadCopyWith(
          FinancePayload value, $Res Function(FinancePayload) then) =
      _$FinancePayloadCopyWithImpl<$Res, FinancePayload>;
  @useResult
  $Res call(
      {FinanceEventType type, double amount, int walletId, int categoryId});
}

/// @nodoc
class _$FinancePayloadCopyWithImpl<$Res, $Val extends FinancePayload>
    implements $FinancePayloadCopyWith<$Res> {
  _$FinancePayloadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FinancePayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? amount = null,
    Object? walletId = null,
    Object? categoryId = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as FinanceEventType,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      walletId: null == walletId
          ? _value.walletId
          : walletId // ignore: cast_nullable_to_non_nullable
              as int,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FinancePayloadImplCopyWith<$Res>
    implements $FinancePayloadCopyWith<$Res> {
  factory _$$FinancePayloadImplCopyWith(_$FinancePayloadImpl value,
          $Res Function(_$FinancePayloadImpl) then) =
      __$$FinancePayloadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {FinanceEventType type, double amount, int walletId, int categoryId});
}

/// @nodoc
class __$$FinancePayloadImplCopyWithImpl<$Res>
    extends _$FinancePayloadCopyWithImpl<$Res, _$FinancePayloadImpl>
    implements _$$FinancePayloadImplCopyWith<$Res> {
  __$$FinancePayloadImplCopyWithImpl(
      _$FinancePayloadImpl _value, $Res Function(_$FinancePayloadImpl) _then)
      : super(_value, _then);

  /// Create a copy of FinancePayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? amount = null,
    Object? walletId = null,
    Object? categoryId = null,
  }) {
    return _then(_$FinancePayloadImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as FinanceEventType,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      walletId: null == walletId
          ? _value.walletId
          : walletId // ignore: cast_nullable_to_non_nullable
              as int,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FinancePayloadImpl implements _FinancePayload {
  const _$FinancePayloadImpl(
      {required this.type,
      required this.amount,
      required this.walletId,
      required this.categoryId});

  factory _$FinancePayloadImpl.fromJson(Map<String, dynamic> json) =>
      _$$FinancePayloadImplFromJson(json);

  @override
  final FinanceEventType type;
  @override
  final double amount;
  @override
  final int walletId;
  @override
  final int categoryId;

  @override
  String toString() {
    return 'FinancePayload(type: $type, amount: $amount, walletId: $walletId, categoryId: $categoryId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinancePayloadImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.walletId, walletId) ||
                other.walletId == walletId) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, type, amount, walletId, categoryId);

  /// Create a copy of FinancePayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FinancePayloadImplCopyWith<_$FinancePayloadImpl> get copyWith =>
      __$$FinancePayloadImplCopyWithImpl<_$FinancePayloadImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FinancePayloadImplToJson(
      this,
    );
  }
}

abstract class _FinancePayload implements FinancePayload {
  const factory _FinancePayload(
      {required final FinanceEventType type,
      required final double amount,
      required final int walletId,
      required final int categoryId}) = _$FinancePayloadImpl;

  factory _FinancePayload.fromJson(Map<String, dynamic> json) =
      _$FinancePayloadImpl.fromJson;

  @override
  FinanceEventType get type;
  @override
  double get amount;
  @override
  int get walletId;
  @override
  int get categoryId;

  /// Create a copy of FinancePayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FinancePayloadImplCopyWith<_$FinancePayloadImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
