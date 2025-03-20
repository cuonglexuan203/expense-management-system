// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Transaction _$TransactionFromJson(Map<String, dynamic> json) {
  return _Transaction.fromJson(json);
}

/// @nodoc
mixin _$Transaction {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get walletId => throw _privateConstructorUsedError;
  String? get walletName => throw _privateConstructorUsedError;
  String? get categoryName => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _amountFromJson)
  double get amount => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  DateTime get occurredAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Transaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionCopyWith<Transaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionCopyWith<$Res> {
  factory $TransactionCopyWith(
          Transaction value, $Res Function(Transaction) then) =
      _$TransactionCopyWithImpl<$Res, Transaction>;
  @useResult
  $Res call(
      {int id,
      String name,
      int walletId,
      String? walletName,
      String? categoryName,
      @JsonKey(fromJson: _amountFromJson) double amount,
      String? description,
      String type,
      DateTime occurredAt,
      DateTime? createdAt});
}

/// @nodoc
class _$TransactionCopyWithImpl<$Res, $Val extends Transaction>
    implements $TransactionCopyWith<$Res> {
  _$TransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? walletId = null,
    Object? walletName = freezed,
    Object? categoryName = freezed,
    Object? amount = null,
    Object? description = freezed,
    Object? type = null,
    Object? occurredAt = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      walletId: null == walletId
          ? _value.walletId
          : walletId // ignore: cast_nullable_to_non_nullable
              as int,
      walletName: freezed == walletName
          ? _value.walletName
          : walletName // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryName: freezed == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      occurredAt: null == occurredAt
          ? _value.occurredAt
          : occurredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionImplCopyWith<$Res>
    implements $TransactionCopyWith<$Res> {
  factory _$$TransactionImplCopyWith(
          _$TransactionImpl value, $Res Function(_$TransactionImpl) then) =
      __$$TransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      int walletId,
      String? walletName,
      String? categoryName,
      @JsonKey(fromJson: _amountFromJson) double amount,
      String? description,
      String type,
      DateTime occurredAt,
      DateTime? createdAt});
}

/// @nodoc
class __$$TransactionImplCopyWithImpl<$Res>
    extends _$TransactionCopyWithImpl<$Res, _$TransactionImpl>
    implements _$$TransactionImplCopyWith<$Res> {
  __$$TransactionImplCopyWithImpl(
      _$TransactionImpl _value, $Res Function(_$TransactionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? walletId = null,
    Object? walletName = freezed,
    Object? categoryName = freezed,
    Object? amount = null,
    Object? description = freezed,
    Object? type = null,
    Object? occurredAt = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$TransactionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      walletId: null == walletId
          ? _value.walletId
          : walletId // ignore: cast_nullable_to_non_nullable
              as int,
      walletName: freezed == walletName
          ? _value.walletName
          : walletName // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryName: freezed == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      occurredAt: null == occurredAt
          ? _value.occurredAt
          : occurredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionImpl implements _Transaction {
  const _$TransactionImpl(
      {required this.id,
      required this.name,
      required this.walletId,
      this.walletName,
      this.categoryName,
      @JsonKey(fromJson: _amountFromJson) required this.amount,
      this.description,
      required this.type,
      required this.occurredAt,
      this.createdAt});

  factory _$TransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final int walletId;
  @override
  final String? walletName;
  @override
  final String? categoryName;
  @override
  @JsonKey(fromJson: _amountFromJson)
  final double amount;
  @override
  final String? description;
  @override
  final String type;
  @override
  final DateTime occurredAt;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Transaction(id: $id, name: $name, walletId: $walletId, walletName: $walletName, categoryName: $categoryName, amount: $amount, description: $description, type: $type, occurredAt: $occurredAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.walletId, walletId) ||
                other.walletId == walletId) &&
            (identical(other.walletName, walletName) ||
                other.walletName == walletName) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.occurredAt, occurredAt) ||
                other.occurredAt == occurredAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, walletId, walletName,
      categoryName, amount, description, type, occurredAt, createdAt);

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      __$$TransactionImplCopyWithImpl<_$TransactionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionImplToJson(
      this,
    );
  }
}

abstract class _Transaction implements Transaction {
  const factory _Transaction(
      {required final int id,
      required final String name,
      required final int walletId,
      final String? walletName,
      final String? categoryName,
      @JsonKey(fromJson: _amountFromJson) required final double amount,
      final String? description,
      required final String type,
      required final DateTime occurredAt,
      final DateTime? createdAt}) = _$TransactionImpl;

  factory _Transaction.fromJson(Map<String, dynamic> json) =
      _$TransactionImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  int get walletId;
  @override
  String? get walletName;
  @override
  String? get categoryName;
  @override
  @JsonKey(fromJson: _amountFromJson)
  double get amount;
  @override
  String? get description;
  @override
  String get type;
  @override
  DateTime get occurredAt;
  @override
  DateTime? get createdAt;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
