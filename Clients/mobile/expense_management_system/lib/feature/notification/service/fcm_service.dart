import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:expense_management_system/app/app.dart';
import 'package:expense_management_system/feature/notification/models/device_token.dart';
import 'package:expense_management_system/feature/notification/repositories/device_token_repository.dart';
import 'package:expense_management_system/shared/route/app_router.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fcmServiceProvider = Provider.autoDispose((ref) {
  final deviceTokenRepository = ref.watch(deviceTokenRepositoryProvider);
  return FCMService(deviceTokenRepository, ref);
});

class FCMService {
  FCMService(this._deviceTokenRepository, this._ref);

  final DeviceTokenRepository _deviceTokenRepository;
  final Ref _ref;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) {
      log('FCM Service already initialized.');
      return;
    }
    log('Initializing FCM Service...');

    await _requestPermissions();

    await _setupLocalNotifications();

    _setupForegroundNotificationHandling();

    _setupBackgroundNotificationHandling();

    await _handleInitialNotification();

    _isInitialized = true;
    log('FCM Service initialized successfully');
  }

  Future<void> _requestPermissions() async {
    try {
      NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      log('User granted notification permission: ${settings.authorizationStatus}');
    } catch (e) {
      log('Error requesting FCM permissions: $e');
    }
  }

  Future<void> _setupLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    try {
      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (details) {
          log('Local notification tapped with payload: ${details.payload}');
          _handleNotificationTap(details.payload);
        },
      );
      log('FlutterLocalNotifications initialized.');

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              'high_importance_channel',
              'High Importance Notifications',
              description: 'This channel is used for important notifications.',
              importance: Importance.high,
              playSound: true,
              enableVibration: true,
            ),
          );
      log('Android Notification Channel (high_importance_channel) created.');
    } catch (e) {
      log('Error initializing FlutterLocalNotifications: $e');
    }
  }

  void _setupForegroundNotificationHandling() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Foreground Message Received!');
      log('Message data: ${message.data}');
      if (message.notification != null) {
        log('Message notification: ${message.notification?.title} / ${message.notification?.body}');
      }

      if (message.notification != null || message.data.isNotEmpty) {
        _showLocalNotification(message);
      }

      if (message.data.isNotEmpty) {
        _handleNotificationData(message.data, isForeground: true);
      }
    });
  }

  void _setupBackgroundNotificationHandling() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('App opened from background notification tap!');
      log('Message data: ${message.data}');
      _handleNotificationTap(jsonEncode(message.data));
    });
  }

  Future<void> _handleInitialNotification() async {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      log('App opened from terminated notification tap!');
      log('Message data: ${initialMessage.data}');
      _handleNotificationTap(jsonEncode(initialMessage.data));
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    final data = message.data;

    final title =
        (data['title'] as String?) ?? notification?.title ?? 'New Notification';
    final body = (data['body'] as String?) ?? notification?.body ?? '';

    const channelId = 'high_importance_channel';

    const androidDetails = AndroidNotificationDetails(
      channelId,
      'High Importance Notifications',
      channelDescription: 'Channel for important notifications.',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
      // icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _localNotifications.show(
        message.messageId?.hashCode ?? DateTime.now().millisecondsSinceEpoch,
        title,
        body,
        platformDetails,
        payload: jsonEncode(message.data),
      );
      log('Local notification shown: $title');
    } catch (e) {
      log('Error showing local notification: $e');
    }
  }

  void _handleNotificationData(Map<String, dynamic> data,
      {bool isForeground = false}) {
    log('Handling notification data (isForeground: $isForeground): $data');
    final type = data['type'] as String?;

    switch (type) {
      case 'transaction_suggestion':
        log('Received transaction suggestion data (foreground: $isForeground).');
        break;
      case 'spending_reminder':
        log('Handling spending reminder data.');
        break;
      case 'promotion':
        log('Handling promotion data.');
        break;
      default:
        log('Received unknown notification data type: $type');
    }
  }

  void _handleNotificationTap(String? payload) {
    if (payload == null) {
      log('Notification tapped with null payload.');
      return;
    }

    try {
      final data = jsonDecode(payload) as Map<String, dynamic>;
      log('Handling notification tap with data: $data');

      String? type = data['type'] as String?;
      final notificationIdRaw = data['notification_id'];

      if (type == null && notificationIdRaw != null) {
        type = 'transaction_suggestion';
        log('Type missing, defaulted to transaction_suggestion.');
      }

      switch (type) {
        case 'transaction_suggestion':
          log('Notification tap type: transaction_suggestion.');
          int? notificationId;
          if (notificationIdRaw is int) {
            notificationId = notificationIdRaw;
          } else if (notificationIdRaw is String) {
            notificationId = int.tryParse(notificationIdRaw);
          }

          if (notificationId != null) {
            final targetPath = TransactionSuggestionRoute.path
                .replaceFirst(':notificationId', notificationId.toString());
            log('[FCMService] Setting pending navigation to: $targetPath');
            _ref.read(pendingNavigationProvider.notifier).state = targetPath;
          } else {
            log('Error: transaction_suggestion data missing or invalid notification_id');
          }
          break;
        case 'spending_reminder':
          log('Notification tap type: spending_reminder.');
          break;
        case 'promotion':
          log('Notification tap type: promotion.');
          break;
        default:
          log('Notification tapped with unknown type: $type');
      }
    } catch (e, stackTrace) {
      log('Error decoding or handling notification tap payload: $e',
          stackTrace: stackTrace);
    }
  }

  Future<String?> getToken() async {
    try {
      if (Platform.isIOS) {
        final apnsToken = await _firebaseMessaging.getAPNSToken();
        if (apnsToken == null) {
          log('Warning: Failed to get APNS token for iOS. FCM token might still work.');
        }
      }
      final fcmToken = await _firebaseMessaging.getToken();
      log('FCM Token: $fcmToken');
      return fcmToken;
    } catch (e) {
      log('Error getting FCM token: $e');
      return null;
    }
  }

  Future<void> registerDeviceToken() async {
    try {
      final token = await getToken();
      if (token != null) {
        log('Registering FCM token with backend: $token');

        final deviceToken = DeviceToken(
          token: token,
          platform:
              Platform.isIOS ? DevicePlatform.ios : DevicePlatform.android,
        );

        await _deviceTokenRepository.registerToken(deviceToken);
        log('FCM token registered successfully with backend.');
      } else {
        log('FCM token is null, cannot register with backend.');
      }
    } catch (e) {
      log('Error registering FCM token with backend: $e');
    }
  }
}
