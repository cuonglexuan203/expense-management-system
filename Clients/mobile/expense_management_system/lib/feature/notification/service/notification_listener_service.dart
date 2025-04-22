// lib/feature/notification/service/notification_listener_service.dart
import 'dart:async';
import 'dart:developer';
import 'package:expense_management_system/feature/notification/models/system_notification.dart';
import 'package:expense_management_system/feature/notification/repositories/notification_repository.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationListenerServiceProvider = Provider((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return NotificationListenerService(repository);
});

// final notificationListenerServiceProviderAutoDispose =
//     Provider.autoDispose((ref) {
//   final repository = ref.watch(notificationRepositoryProvider);
//   return NotificationListenerService(repository);
// });

// // Stream Provider để UI lắng nghe notification mới (nếu cần)
// final systemNotificationStreamProvider =
//     StreamProvider.autoDispose<SystemNotification>((ref) {
//   final service = ref.watch(notificationListenerServiceProviderAutoDispose);

//   return service._getNotificationStream();
// });

class NotificationListenerService {
  NotificationListenerService(this._repository);

  final NotificationRepository _repository;
  static const MethodChannel _channel =
      MethodChannel('com.expense_management_system/notification_listener');
  static const EventChannel _eventChannel =
      EventChannel('com.expense_management_system/notification_events');

  StreamSubscription? _notificationSubscription;
  bool _isInitialized = false;

  // final _notificationController =
  //     StreamController<SystemNotification>.broadcast();
  // Stream<SystemNotification> _getNotificationStream() =>
  //     _notificationController.stream;

  Future<bool> initialize() async {
    if (_isInitialized) {
      log('NotificationListenerService already initialized.');
      return true;
    }
    log('Initializing NotificationListenerService...');

    try {
      await _startListenerService();

      _registerNotificationListener();

      _isInitialized = true;
      log('NotificationListenerService initialized and listening to EventChannel.');
      return true;
    } catch (e) {
      log('Failed to initialize notification listener: $e');
      _isInitialized = false;
      return false;
    }
  }

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

  Future<void> _startListenerService() async {
    try {
      await _channel.invokeMethod('startListenerService');
      log('Notification listener service started successfully.');
    } catch (e) {
      log('Error starting notification listener service: $e');
      rethrow;
    }
  }

  void _registerNotificationListener() {
    _notificationSubscription = _eventChannel
        .receiveBroadcastStream()
        .listen(_handleNotification, onError: (error) {
      log('Notification listener error: $error');
    });
  }

  void _handleNotification(dynamic event) {
    try {
      final Map<String, dynamic> data =
          Map<String, dynamic>.from(event as Map<dynamic, dynamic>);

      final notification = SystemNotification(
        packageName: data['packageName']?.toString() ?? '',
        title: data['title']?.toString() ?? '',
        text: data['text']?.toString() ?? '',
        timestamp: int.tryParse(data['timestamp']?.toString() ?? '') ??
            DateTime.now().millisecondsSinceEpoch,
        extras: data['extras'] is Map
            ? Map<String, dynamic>.from(data['extras'] as Map)
            : null,
      );

      _repository.sendSystemNotification(notification);
    } catch (e) {
      log('Error handling notification: $e');
    }
  }

  void dispose() {
    _notificationSubscription?.cancel();
    _isInitialized = false;
  }
}
