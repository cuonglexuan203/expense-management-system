// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extracted_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExtractedTransactionImpl _$$ExtractedTransactionImplFromJson(
        Map<String, dynamic> json) =>
    _$ExtractedTransactionImpl(
      chatExtractionId: (json['chatExtractionId'] as num).toInt(),
      chatMessageId: (json['chatMessageId'] as num).toInt(),
      category: json['category'] as String?,
      transactionId: (json['transactionId'] as num).toInt(),
      name: json['name'] as String,
      amount: (json['amount'] as num).toInt(),
      type: (json['type'] as num).toInt(),
      occurredAt: DateTime.parse(json['occurredAt'] as String),
      confirmationMode: (json['confirmationMode'] as num).toInt(),
      confirmationStatus: (json['confirmationStatus'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ExtractedTransactionImplToJson(
        _$ExtractedTransactionImpl instance) =>
    <String, dynamic>{
      'chatExtractionId': instance.chatExtractionId,
      'chatMessageId': instance.chatMessageId,
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
