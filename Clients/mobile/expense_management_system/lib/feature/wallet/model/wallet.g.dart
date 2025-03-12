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
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      income: (json['income'] as num?)?.toDouble(),
      expense: (json['expense'] as num?)?.toDouble(),
      filterPeriod: json['filterPeriod'] as String?,
      balanceByPeriod: (json['balanceByPeriod'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$WalletImplToJson(_$WalletImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'balance': instance.balance,
      'description': instance.description,
      'createdAt': instance.createdAt?.toIso8601String(),
      'income': instance.income,
      'expense': instance.expense,
      'filterPeriod': instance.filterPeriod,
      'balanceByPeriod': instance.balanceByPeriod,
    };
