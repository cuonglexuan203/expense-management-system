// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletImpl _$$WalletImplFromJson(Map<String, dynamic> json) => _$WalletImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      balance: (json['balance'] as num?)?.toDouble() ?? 0,
      description: json['description'] as String?,
      createdAt: _dateTimeFromJson(json['createdAt']),
      income: json['income'] == null
          ? const TransactionSummary(totalAmount: 0, transactionCount: 0)
          : TransactionSummary.fromJson(json['income'] as Map<String, dynamic>),
      expense: json['expense'] == null
          ? const TransactionSummary(totalAmount: 0, transactionCount: 0)
          : TransactionSummary.fromJson(
              json['expense'] as Map<String, dynamic>),
      filterPeriod: json['filterPeriod'] as String?,
      balanceByPeriod: (json['balanceByPeriod'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$WalletImplToJson(_$WalletImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'balance': instance.balance,
      'description': instance.description,
      'createdAt': _dateTimeToJson(instance.createdAt),
      'income': _transactionSummaryToJson(instance.income),
      'expense': _transactionSummaryToJson(instance.expense),
      'filterPeriod': instance.filterPeriod,
      'balanceByPeriod': instance.balanceByPeriod,
    };
