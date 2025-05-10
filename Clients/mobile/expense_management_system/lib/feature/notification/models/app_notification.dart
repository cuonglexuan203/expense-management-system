// lib/feature/notification/models/notification.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_notification.freezed.dart';
part 'app_notification.g.dart';

@freezed
class AppNotification with _$AppNotification {
  const factory AppNotification({
    required int id,
    required String userId,
    required String type,
    required String title,
    required String body,
    required String status,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    required DateTime processedAt,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    required DateTime createdAt,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);
}

DateTime dateTimeFromJson(String date) => DateTime.parse(date);
String dateTimeToJson(DateTime date) => date.toIso8601String();
