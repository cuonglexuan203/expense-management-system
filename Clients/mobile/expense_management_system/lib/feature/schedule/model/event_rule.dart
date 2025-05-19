// lib/feature/event/model/event_rule.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:expense_management_system/shared/util/date_time_util.dart';

part 'event_rule.freezed.dart';
part 'event_rule.g.dart';

enum EventFrequency {
  @JsonValue('Once')
  once,
  @JsonValue('Daily')
  daily,
  @JsonValue('Weekly')
  weekly,
  @JsonValue('Monthly')
  monthly,
  @JsonValue('Yearly')
  yearly,
}

@freezed
class EventRule with _$EventRule {
  const factory EventRule({
    @Default(EventFrequency.once) EventFrequency frequency,
    @Default(1) int interval,
    @Default([]) List<String> byDayOfWeek,
    @Default([]) List<int> byMonthDay,
    @Default([]) List<int> byMonth,
    @JsonKey(fromJson: dateTimeFromJsonNullable, toJson: dateTimeToJsonNullable)
    DateTime? endDate,
    int? maxOccurrences,
  }) = _EventRule;

  factory EventRule.fromJson(Map<String, dynamic> json) =>
      _$EventRuleFromJson(json);
}
