// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventRuleImpl _$$EventRuleImplFromJson(Map<String, dynamic> json) =>
    _$EventRuleImpl(
      frequency:
          $enumDecodeNullable(_$EventFrequencyEnumMap, json['frequency']) ??
              EventFrequency.once,
      interval: (json['interval'] as num?)?.toInt() ?? 1,
      byDayOfWeek: (json['byDayOfWeek'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      byMonthDay: (json['byMonthDay'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      byMonth: (json['byMonth'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      endDate: dateTimeFromJsonNullable(json['endDate'] as String?),
      maxOccurrences: (json['maxOccurrences'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$EventRuleImplToJson(_$EventRuleImpl instance) =>
    <String, dynamic>{
      'frequency': _$EventFrequencyEnumMap[instance.frequency]!,
      'interval': instance.interval,
      'byDayOfWeek': instance.byDayOfWeek,
      'byMonthDay': instance.byMonthDay,
      'byMonth': instance.byMonth,
      'endDate': dateTimeToJsonNullable(instance.endDate),
      'maxOccurrences': instance.maxOccurrences,
    };

const _$EventFrequencyEnumMap = {
  EventFrequency.once: 'Once',
  EventFrequency.daily: 'Daily',
  EventFrequency.weekly: 'Weekly',
  EventFrequency.monthly: 'Monthly',
  EventFrequency.yearly: 'Yearly',
};
