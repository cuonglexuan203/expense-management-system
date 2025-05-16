// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventImpl _$$EventImplFromJson(Map<String, dynamic> json) => _$EventImpl(
      id: json['id'],
      scheduledEventId: json['scheduledEventId'],
      name: json['name'] as String,
      description: json['description'] as String?,
      type: $enumDecode(_$EventTypeEnumMap, json['type']),
      payload: json['payload'] as String,
      initialTriggerDateTime:
          dateTimeFromJsonNonNull(json['initialTrigger'] as String),
      rule: json['recurrenceRule'] == null
          ? null
          : EventRule.fromJson(json['recurrenceRule'] as Map<String, dynamic>),
      createdAt: dateTimeFromJsonNullable(json['createdAt'] as String?),
      updatedAt: dateTimeFromJsonNullable(json['updatedAt'] as String?),
    );

Map<String, dynamic> _$$EventImplToJson(_$EventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'scheduledEventId': instance.scheduledEventId,
      'name': instance.name,
      'description': instance.description,
      'type': _$EventTypeEnumMap[instance.type]!,
      'payload': instance.payload,
      'initialTrigger': dateTimeToJson(instance.initialTriggerDateTime),
      'recurrenceRule': instance.rule?.toJson(),
      'createdAt': dateTimeToJsonNullable(instance.createdAt),
      'updatedAt': dateTimeToJsonNullable(instance.updatedAt),
    };

const _$EventTypeEnumMap = {
  EventType.finance: 'Finance',
  EventType.reminder: 'Reminder',
};
