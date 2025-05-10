// lib/feature/event/model/event.dart
import 'dart:convert';
import 'package:expense_management_system/feature/schedule/model/event_rule.dart';
import 'package:expense_management_system/feature/schedule/model/finance_payload.dart';
import 'package:expense_management_system/shared/util/date_time_util.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event.freezed.dart';
part 'event.g.dart';

enum EventType {
  @JsonValue('Finance')
  finance,
  @JsonValue('Reminder')
  reminder,
}

@freezed
class Event with _$Event {
  @JsonSerializable(explicitToJson: true)
  const factory Event({
    // Thay đổi từ String? thành dynamic để tương thích với cả int và String
    // HOẶC thay đổi thành int? nếu API luôn trả về id là integer
    dynamic id, // hoặc int?
    dynamic scheduledEventId,
    required String name,
    String? description,
    required EventType type,
    required String payload,

    // Thêm mapping cho tên trường khác nhau
    @JsonKey(
        name: 'initialTrigger',
        fromJson: dateTimeFromJsonNonNull,
        toJson: dateTimeToJson)
    required DateTime initialTriggerDateTime,
    @JsonKey(name: 'recurrenceRule') EventRule? rule,
    @JsonKey(fromJson: dateTimeFromJsonNullable, toJson: dateTimeToJsonNullable)
    DateTime? createdAt,
    @JsonKey(fromJson: dateTimeFromJsonNullable, toJson: dateTimeToJsonNullable)
    DateTime? updatedAt,
  }) = _Event;

  const Event._();

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  // Helper to get FinancePayload if type is Finance
  FinancePayload? get financePayload {
    if (type == EventType.finance) {
      try {
        return FinancePayload.fromJson(
            jsonDecode(payload) as Map<String, dynamic>);
      } catch (e) {
        // Handle potential JSON decode error
        print('Error decoding finance payload: $e');
        return null;
      }
    }
    return null;
  }
}
