// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageImpl _$$MessageImplFromJson(Map<String, dynamic> json) =>
    _$MessageImpl(
      id: (json['id'] as num).toInt(),
      chatThreadId: (json['chatThreadId'] as num).toInt(),
      userId: json['userId'] as String?,
      role: json['role'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      extractedTransactions: (json['extractedTransactions'] as List<dynamic>?)
              ?.map((e) =>
                  ExtractedTransaction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$MessageImplToJson(_$MessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chatThreadId': instance.chatThreadId,
      'userId': instance.userId,
      'role': instance.role,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
      'extractedTransactions': instance.extractedTransactions,
    };
