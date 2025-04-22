// // lib/feature/notification/service/system_notification_listener_service.dart
// import 'dart:async';
// import 'dart:convert';
// import 'dart:isolate';
// import 'dart:ui';

// import 'package:flutter/foundation.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:notification_listener_service/notification_event.dart';
// import 'package:notification_listener_service/notification_listener_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:workmanager/workmanager.dart';

// import '../repository/notification_repository.dart';

// final systemNotificationServiceProvider =
//     Provider<SystemNotificationService>((ref) {
//   return SystemNotificationService(ref);
// });

// // Background processing name constants
// const String _backgroundTaskName = 'processSystemNotifications';
// const String _periodicTaskName = 'ensureNotificationListener';

// class SystemNotificationService {
//   final Ref _ref;
//   final NotificationListenerService _notificationService =
//       NotificationListenerService();
//   bool _isInitialized = false;
//   StreamSubscription<NotificationEvent>? _subscription;
//   static const String _backgroundPortName = 'system_notification_port';
//   static ReceivePort? _backgroundReceivePort;

//   SystemNotificationService(this._ref);

//   Future<void> initialize() async {
//     if (_isInitialized) return;

//     // Initialize background processing
//     await _setupBackgroundProcessing();

//     // Request notification listener permission
//     final isPermissionGranted =
//         await _notificationService.isPermissionGranted();
//     if (!isPermissionGranted) {
//       final requestResult = await _notificationService.requestPermission();
//       debugPrint(
//           'Notification listener permission request result: $requestResult');
//     }

//     // Start listening for notifications
//     if (await _notificationService.isPermissionGranted()) {
//       await startListening();
//     }

//     // Register WorkManager task to ensure service stays running
//     await Workmanager().initialize(callbackDispatcher);
//     await Workmanager().registerPeriodicTask(
//       _periodicTaskName,
//       _periodicTaskName,
//       frequency: const Duration(minutes: 15),
//       constraints: Constraints(
//         networkType: NetworkType.connected,
//         requiresBatteryNotLow: false,
//       ),
//       existingWorkPolicy: ExistingWorkPolicy.replace,
//     );

//     _isInitialized = true;
//   }

//   Future<void> _setupBackgroundProcessing() async {
//     // Register a port for background communication
//     _backgroundReceivePort = ReceivePort();
//     IsolateNameServer.registerPortWithName(
//       _backgroundReceivePort!.sendPort,
//       _backgroundPortName,
//     );

//     // Listen for messages from background isolate
//     _backgroundReceivePort!.listen((dynamic message) {
//       if (message is Map<String, dynamic>) {
//         _processPendingNotifications();
//       }
//     });
//   }

//   Future<void> startListening() async {
//     if (_subscription != null) {
//       await _subscription!.cancel();
//     }

//     try {
//       final isRunning = await _notificationService.isRunning();
//       if (!isRunning) {
//         await _notificationService.startService();
//       }

//       _subscription = _notificationService.notificationStream.listen(
//         _handleNotification,
//         onError: (error) {
//           debugPrint('Error in notification stream: $error');
//           // Try to restart the service
//           _notificationService.startService();
//         },
//       );

//       debugPrint('System notification listener started successfully');
//     } catch (e) {
//       debugPrint('Error starting notification listener: $e');
//     }
//   }

//   void _handleNotification(NotificationEvent event) async {
//     try {
//       // Check if this is a notification we're interested in
//       if (event.packageName == null ||
//           event.title == null ||
//           event.content == null) {
//         return; // Skip incomplete notifications
//       }

//       final notificationData = {
//         'packageName': event.packageName,
//         'title': event.title,
//         'content': event.content,
//         'timestamp': DateTime.now().toIso8601String(),
//         'appName': event.appName ?? '',
//       };

//       debugPrint('Received notification: ${event.title}');

//       // Try to send immediately, if that fails, store for later
//       try {
//         await _sendNotificationToBackend(notificationData);
//       } catch (e) {
//         debugPrint('Failed to send notification, storing for later: $e');
//         await _storeNotificationForRetry(notificationData);
//       }
//     } catch (e) {
//       debugPrint('Error processing notification: $e');
//     }
//   }

//   Future<void> _sendNotificationToBackend(
//       Map<String, dynamic> notificationData) async {
//     final repository = _ref.read(notificationRepositoryProvider);
//     await repository.sendSystemNotification(notificationData);
//   }

//   Future<void> _storeNotificationForRetry(
//       Map<String, dynamic> notificationData) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();

//       // Get current list of pending notifications
//       final pendingNotifications =
//           prefs.getStringList('pending_notifications') ?? [];

//       // Add new notification
//       pendingNotifications.add(jsonEncode(notificationData));

//       // Save updated list
//       await prefs.setStringList('pending_notifications', pendingNotifications);

//       // Schedule a one-time task to process pending notifications
//       await Workmanager().registerOneOffTask(
//         _backgroundTaskName,
//         _backgroundTaskName,
//         constraints: Constraints(
//           networkType: NetworkType.connected,
//         ),
//       );
//     } catch (e) {
//       debugPrint('Error storing notification for retry: $e');
//     }
//   }

//   Future<void> _processPendingNotifications() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final pendingNotifications =
//           prefs.getStringList('pending_notifications') ?? [];

//       if (pendingNotifications.isEmpty) return;

//       debugPrint(
//           'Processing ${pendingNotifications.length} pending notifications');

//       final repository = _ref.read(notificationRepositoryProvider);
//       final successfulOnes = <int>[];

//       for (int i = 0; i < pendingNotifications.length; i++) {
//         try {
//           final notificationData =
//               jsonDecode(pendingNotifications[i]) as Map<String, dynamic>;
//           await repository.sendSystemNotification(notificationData);
//           successfulOnes.add(i);
//         } catch (e) {
//           debugPrint('Failed to send pending notification: $e');
//         }
//       }

//       // Remove successfully sent notifications
//       final updatedList = pendingNotifications
//           .asMap()
//           .entries
//           .where((entry) => !successfulOnes.contains(entry.key))
//           .map((entry) => entry.value)
//           .toList();

//       await prefs.setStringList('pending_notifications', updatedList);
//       debugPrint(
//           'Processed pending notifications, ${pendingNotifications.length - updatedList.length} sent successfully');
//     } catch (e) {
//       debugPrint('Error processing pending notifications: $e');
//     }
//   }

//   Future<void> stopListening() async {
//     if (_subscription != null) {
//       await _subscription!.cancel();
//       _subscription = null;
//     }

//     await _notificationService.stopService();
//     debugPrint('System notification listener stopped');
//   }
// }

// // Must be a top-level function
// @pragma('vm:entry-point')
// void callbackDispatcher() {
//   Workmanager().executeTask((taskName, inputData) async {
//     try {
//       switch (taskName) {
//         case _periodicTaskName:
//           // Ensure notification listener is running
//           final notificationService = NotificationListenerService();
//           final isRunning = await notificationService.isRunning();
//           if (!isRunning) {
//             await notificationService.startService();
//           }

//           // Notify main isolate to process pending notifications
//           final sendPort =
//               IsolateNameServer.lookupPortByName(_backgroundPortName);
//           sendPort?.send({'action': 'process_pending'});
//           break;

//         case _backgroundTaskName:
//           // This will trigger processing of pending notifications
//           final sendPort =
//               IsolateNameServer.lookupPortByName(_backgroundPortName);
//           sendPort?.send({'action': 'process_pending'});
//           break;
//       }
//       return Future.value(true);
//     } catch (e) {
//       debugPrint('Error in background task: $e');
//       return Future.value(false);
//     }
//   });
// }
