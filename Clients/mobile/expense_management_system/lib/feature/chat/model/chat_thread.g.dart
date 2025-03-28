// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_thread.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatThreadImpl _$$ChatThreadImplFromJson(Map<String, dynamic> json) =>
    _$ChatThreadImpl(
      id: (json['id'] as num).toInt(),
      userId: json['userId'] as String,
      title: json['title'] as String,
      isActive: json['isActive'] as bool,
      type: json['type'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ChatThreadImplToJson(_$ChatThreadImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'isActive': instance.isActive,
      'type': instance.type,
      'createdAt': instance.createdAt.toIso8601String(),
    };
