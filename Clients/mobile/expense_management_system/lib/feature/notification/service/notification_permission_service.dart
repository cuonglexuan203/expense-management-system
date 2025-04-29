import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationPermissionServiceProvider = Provider((ref) {
  return NotificationPermissionService();
});

class NotificationPermissionService {
  static const MethodChannel _channel =
      MethodChannel('com.expense_management_system/notification_listener');

  Future<bool> checkNotificationListenerPermission() async {
    try {
      final bool? hasPermission =
          await _channel.invokeMethod('checkNotificationListenerPermission');
      log('Notification listener permission status: $hasPermission');
      return hasPermission ?? false;
    } catch (e) {
      log('Error checking notification permission: $e');
      return false;
    }
  }

  Future<bool> requestNotificationListenerPermission() async {
    try {
      final bool? openedSettings =
          await _channel.invokeMethod('requestNotificationListenerPermission');
      log('Requesting notification listener permission (opened settings): $openedSettings');
      return openedSettings ?? false;
    } catch (e) {
      log('Error requesting notification permission: $e');
      return false;
    }
  }
}
