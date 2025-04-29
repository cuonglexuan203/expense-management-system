// lib/feature/notification/model/system_notification.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'system_notification.freezed.dart';
part 'system_notification.g.dart';

@freezed
class SystemNotification with _$SystemNotification {
  const factory SystemNotification({
    required String packageName,
    required String title,
    required String text,
    required int timestamp,
    Map<String, dynamic>? extras,
  }) = _SystemNotification;

  factory SystemNotification.fromJson(Map<String, dynamic> json) =>
      _$SystemNotificationFromJson(json);
}
