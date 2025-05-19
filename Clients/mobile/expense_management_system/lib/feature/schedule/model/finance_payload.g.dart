// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FinancePayloadImpl _$$FinancePayloadImplFromJson(Map<String, dynamic> json) =>
    _$FinancePayloadImpl(
      type: $enumDecode(_$FinanceEventTypeEnumMap, json['type']),
      amount: (json['amount'] as num).toDouble(),
      walletId: (json['walletId'] as num).toInt(),
      categoryId: (json['categoryId'] as num).toInt(),
    );

Map<String, dynamic> _$$FinancePayloadImplToJson(
        _$FinancePayloadImpl instance) =>
    <String, dynamic>{
      'type': _$FinanceEventTypeEnumMap[instance.type]!,
      'amount': instance.amount,
      'walletId': instance.walletId,
      'categoryId': instance.categoryId,
    };

const _$FinanceEventTypeEnumMap = {
  FinanceEventType.income: 'Income',
  FinanceEventType.expense: 'Expense',
};
