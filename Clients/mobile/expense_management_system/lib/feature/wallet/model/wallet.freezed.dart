// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Wallet _$WalletFromJson(Map<String, dynamic> json) {
  return _Wallet.fromJson(json);
}

/// @nodoc
mixin _$Wallet {
  @JsonKey(name: 'id')
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get balance => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: TransactionSummary.fromJson, toJson: _transactionSummaryToJson)
  TransactionSummary get income => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: TransactionSummary.fromJson, toJson: _transactionSummaryToJson)
  TransactionSummary get expense => throw _privateConstructorUsedError;
  String? get filterPeriod => throw _privateConstructorUsedError;
  double get balanceByPeriod => throw _privateConstructorUsedError;

  /// Serializes this Wallet to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Wallet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WalletCopyWith<Wallet> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletCopyWith<$Res> {
  factory $WalletCopyWith(Wallet value, $Res Function(Wallet) then) =
      _$WalletCopyWithImpl<$Res, Wallet>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      String name,
      double balance,
      String? description,
      DateTime? createdAt,
      @JsonKey(
          fromJson: TransactionSummary.fromJson,
          toJson: _transactionSummaryToJson)
      TransactionSummary income,
      @JsonKey(
          fromJson: TransactionSummary.fromJson,
          toJson: _transactionSummaryToJson)
      TransactionSummary expense,
      String? filterPeriod,
      double balanceByPeriod});

  $TransactionSummaryCopyWith<$Res> get income;
  $TransactionSummaryCopyWith<$Res> get expense;
}

/// @nodoc
class _$WalletCopyWithImpl<$Res, $Val extends Wallet>
    implements $WalletCopyWith<$Res> {
  _$WalletCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Wallet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? balance = null,
    Object? description = freezed,
    Object? createdAt = freezed,
    Object? income = null,
    Object? expense = null,
    Object? filterPeriod = freezed,
    Object? balanceByPeriod = null,
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
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      income: null == income
          ? _value.income
          : income // ignore: cast_nullable_to_non_nullable
              as TransactionSummary,
      expense: null == expense
          ? _value.expense
          : expense // ignore: cast_nullable_to_non_nullable
              as TransactionSummary,
      filterPeriod: freezed == filterPeriod
          ? _value.filterPeriod
          : filterPeriod // ignore: cast_nullable_to_non_nullable
              as String?,
      balanceByPeriod: null == balanceByPeriod
          ? _value.balanceByPeriod
          : balanceByPeriod // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }

  /// Create a copy of Wallet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TransactionSummaryCopyWith<$Res> get income {
    return $TransactionSummaryCopyWith<$Res>(_value.income, (value) {
      return _then(_value.copyWith(income: value) as $Val);
    });
  }

  /// Create a copy of Wallet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TransactionSummaryCopyWith<$Res> get expense {
    return $TransactionSummaryCopyWith<$Res>(_value.expense, (value) {
      return _then(_value.copyWith(expense: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WalletImplCopyWith<$Res> implements $WalletCopyWith<$Res> {
  factory _$$WalletImplCopyWith(
          _$WalletImpl value, $Res Function(_$WalletImpl) then) =
      __$$WalletImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      String name,
      double balance,
      String? description,
      DateTime? createdAt,
      @JsonKey(
          fromJson: TransactionSummary.fromJson,
          toJson: _transactionSummaryToJson)
      TransactionSummary income,
      @JsonKey(
          fromJson: TransactionSummary.fromJson,
          toJson: _transactionSummaryToJson)
      TransactionSummary expense,
      String? filterPeriod,
      double balanceByPeriod});

  @override
  $TransactionSummaryCopyWith<$Res> get income;
  @override
  $TransactionSummaryCopyWith<$Res> get expense;
}

/// @nodoc
class __$$WalletImplCopyWithImpl<$Res>
    extends _$WalletCopyWithImpl<$Res, _$WalletImpl>
    implements _$$WalletImplCopyWith<$Res> {
  __$$WalletImplCopyWithImpl(
      _$WalletImpl _value, $Res Function(_$WalletImpl) _then)
      : super(_value, _then);

  /// Create a copy of Wallet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? balance = null,
    Object? description = freezed,
    Object? createdAt = freezed,
    Object? income = null,
    Object? expense = null,
    Object? filterPeriod = freezed,
    Object? balanceByPeriod = null,
  }) {
    return _then(_$WalletImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      income: null == income
          ? _value.income
          : income // ignore: cast_nullable_to_non_nullable
              as TransactionSummary,
      expense: null == expense
          ? _value.expense
          : expense // ignore: cast_nullable_to_non_nullable
              as TransactionSummary,
      filterPeriod: freezed == filterPeriod
          ? _value.filterPeriod
          : filterPeriod // ignore: cast_nullable_to_non_nullable
              as String?,
      balanceByPeriod: null == balanceByPeriod
          ? _value.balanceByPeriod
          : balanceByPeriod // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WalletImpl implements _Wallet {
  const _$WalletImpl(
      {@JsonKey(name: 'id') required this.id,
      required this.name,
      this.balance = 0,
      this.description,
      this.createdAt,
      @JsonKey(
          fromJson: TransactionSummary.fromJson,
          toJson: _transactionSummaryToJson)
      this.income =
          const TransactionSummary(totalAmount: 0, transactionCount: 0),
      @JsonKey(
          fromJson: TransactionSummary.fromJson,
          toJson: _transactionSummaryToJson)
      this.expense =
          const TransactionSummary(totalAmount: 0, transactionCount: 0),
      this.filterPeriod,
      this.balanceByPeriod = 0});

  factory _$WalletImpl.fromJson(Map<String, dynamic> json) =>
      _$$WalletImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int id;
  @override
  final String name;
  @override
  @JsonKey()
  final double balance;
  @override
  final String? description;
  @override
  final DateTime? createdAt;
  @override
  @JsonKey(
      fromJson: TransactionSummary.fromJson, toJson: _transactionSummaryToJson)
  final TransactionSummary income;
  @override
  @JsonKey(
      fromJson: TransactionSummary.fromJson, toJson: _transactionSummaryToJson)
  final TransactionSummary expense;
  @override
  final String? filterPeriod;
  @override
  @JsonKey()
  final double balanceByPeriod;

  @override
  String toString() {
    return 'Wallet(id: $id, name: $name, balance: $balance, description: $description, createdAt: $createdAt, income: $income, expense: $expense, filterPeriod: $filterPeriod, balanceByPeriod: $balanceByPeriod)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.income, income) || other.income == income) &&
            (identical(other.expense, expense) || other.expense == expense) &&
            (identical(other.filterPeriod, filterPeriod) ||
                other.filterPeriod == filterPeriod) &&
            (identical(other.balanceByPeriod, balanceByPeriod) ||
                other.balanceByPeriod == balanceByPeriod));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, balance, description,
      createdAt, income, expense, filterPeriod, balanceByPeriod);

  /// Create a copy of Wallet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WalletImplCopyWith<_$WalletImpl> get copyWith =>
      __$$WalletImplCopyWithImpl<_$WalletImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WalletImplToJson(
      this,
    );
  }
}

abstract class _Wallet implements Wallet {
  const factory _Wallet(
      {@JsonKey(name: 'id') required final int id,
      required final String name,
      final double balance,
      final String? description,
      final DateTime? createdAt,
      @JsonKey(
          fromJson: TransactionSummary.fromJson,
          toJson: _transactionSummaryToJson)
      final TransactionSummary income,
      @JsonKey(
          fromJson: TransactionSummary.fromJson,
          toJson: _transactionSummaryToJson)
      final TransactionSummary expense,
      final String? filterPeriod,
      final double balanceByPeriod}) = _$WalletImpl;

  factory _Wallet.fromJson(Map<String, dynamic> json) = _$WalletImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int get id;
  @override
  String get name;
  @override
  double get balance;
  @override
  String? get description;
  @override
  DateTime? get createdAt;
  @override
  @JsonKey(
      fromJson: TransactionSummary.fromJson, toJson: _transactionSummaryToJson)
  TransactionSummary get income;
  @override
  @JsonKey(
      fromJson: TransactionSummary.fromJson, toJson: _transactionSummaryToJson)
  TransactionSummary get expense;
  @override
  String? get filterPeriod;
  @override
  double get balanceByPeriod;

  /// Create a copy of Wallet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WalletImplCopyWith<_$WalletImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
