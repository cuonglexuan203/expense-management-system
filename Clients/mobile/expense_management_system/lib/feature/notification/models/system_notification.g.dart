// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SystemNotificationImpl _$$SystemNotificationImplFromJson(
        Map<String, dynamic> json) =>
    _$SystemNotificationImpl(
      packageName: json['packageName'] as String,
      title: json['title'] as String,
      text: json['text'] as String,
      timestamp: (json['timestamp'] as num).toInt(),
      extras: json['extras'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$SystemNotificationImplToJson(
        _$SystemNotificationImpl instance) =>
    <String, dynamic>{
      'packageName': instance.packageName,
      'title': instance.title,
      'text': instance.text,
      'timestamp': instance.timestamp,
      'extras': instance.extras,
    };
