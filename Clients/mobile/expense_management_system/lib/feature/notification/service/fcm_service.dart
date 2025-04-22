// lib/feature/notification/service/fcm_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:expense_management_system/feature/notification/models/device_token.dart';
import 'package:expense_management_system/feature/notification/repositories/device_token_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionSuggestionStreamProvider =
    StreamProvider.autoDispose<Map<String, dynamic>>((ref) {
  final controller = StreamController<Map<String, dynamic>>.broadcast();

  ref.onDispose(() {
    log("Disposing transactionSuggestionStreamProvider's controller");
    controller.close();
  });

  return controller.stream;
});
// --- End Stream Provider ---

// Provider cho FCMService
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

  final _suggestionController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get transactionSuggestionStream =>
      _suggestionController.stream;

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
      log('Android Notification Channel created.');
    } catch (e) {
      log('Error initializing FlutterLocalNotifications: $e');
    }
  }

  void _setupForegroundNotificationHandling() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Foreground Message Received!');
      log('Message data: ${message.data}');
      log('Message notification: ${message.notification?.title} / ${message.notification?.body}');

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
        if (isForeground) {
          log('Adding transaction suggestion to stream for UI handling.');
          _suggestionController.add(data);
        } else {
          log('Received transaction suggestion in background handler (data only).');
        }
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
      final type = data['type'] as String?;

      switch (type) {
        case 'transaction_suggestion':
          log('Notification tap type: transaction_suggestion. Triggering UI.');
          _suggestionController.add(data);
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
    } catch (e) {
      log('Error decoding or handling notification tap payload: $e');
    }
  }

  Future<String?> getToken() async {
    try {
      if (Platform.isIOS) {
        final apnsToken = await _firebaseMessaging.getAPNSToken();
        if (apnsToken == null) {
          log('Failed to get APNS token for iOS.');
          await Future.delayed(const Duration(seconds: 1));
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
        log('Registering FCM token: $token');

        final deviceToken = DeviceToken(
          token: token,
          platform:
              Platform.isIOS ? DevicePlatform.ios : DevicePlatform.android,
        );

        await _deviceTokenRepository.registerToken(deviceToken);
        log('FCM token registered successfully');
      } else {
        log('FCM token is null, cannot register');
      }
    } catch (e) {
      log('Error registering FCM token: $e');
    }
  }

  // TODO: Add unregisterDeviceToken method to remove token from backend
  // Future<void> unregisterDeviceToken() async { ... }

  void dispose() {
    log('Disposing FCMService');
    _suggestionController.close();
  }
}
