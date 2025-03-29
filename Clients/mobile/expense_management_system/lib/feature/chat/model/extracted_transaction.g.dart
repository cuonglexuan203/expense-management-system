// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extracted_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExtractedTransactionImpl _$$ExtractedTransactionImplFromJson(
        Map<String, dynamic> json) =>
    _$ExtractedTransactionImpl(
      id: (json['id'] as num).toInt(),
      chatExtractionId: (json['chatExtractionId'] as num).toInt(),
      category: json['category'] as String?,
      transactionId: (json['transactionId'] as num).toInt(),
      name: json['name'] as String,
      amount: (json['amount'] as num).toInt(),
      type: json['type'] as String,
      occurredAt: DateTime.parse(json['occurredAt'] as String),
      confirmationMode: json['confirmationMode'] as String,
      confirmationStatus: json['confirmationStatus'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ExtractedTransactionImplToJson(
        _$ExtractedTransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chatExtractionId': instance.chatExtractionId,
      'category': instance.category,
      'transactionId': instance.transactionId,
      'name': instance.name,
      'amount': instance.amount,
      'type': instance.type,
      'occurredAt': instance.occurredAt.toIso8601String(),
      'confirmationMode': instance.confirmationMode,
      'confirmationStatus': instance.confirmationStatus,
      'createdAt': instance.createdAt.toIso8601String(),
    };
