// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionImpl _$$TransactionImplFromJson(Map<String, dynamic> json) =>
    _$TransactionImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      walletId: (json['walletId'] as num).toInt(),
      walletName: json['walletName'] as String?,
      categoryName: json['categoryName'] as String?,
      amount: _amountFromJson(json['amount']),
      description: json['description'] as String?,
      type: json['type'] as String,
      occurredAt: DateTime.parse(json['occurredAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$TransactionImplToJson(_$TransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'walletId': instance.walletId,
      'walletName': instance.walletName,
      'categoryName': instance.categoryName,
      'amount': instance.amount,
      'description': instance.description,
      'type': instance.type,
      'occurredAt': instance.occurredAt.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };
