import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:expense_management_system/feature/notification/service/fcm_service.dart';
import 'package:expense_management_system/firebase_options.dart';
import 'package:expense_management_system/shared/theme/app_theme.dart';
import 'package:expense_management_system/shared/util/logger.dart';
import 'package:expense_management_system/shared/util/platform_type.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/app.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log("Handling a background message: ${message.messageId}");
  log("Background Message data: ${message.data}");
}

// Future<void> start() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await EasyLocalization.ensureInitialized();
//   await Future.wait([
//     initializeDateFormatting('', ''),
//   ]);
//   FlutterError.onError = (details) {
//     log(details.exceptionAsString(), stackTrace: details.stack);
//   };

//   final platformType = detectPlatformType();

//   runApp(EasyLocalization(
//     supportedLocales: const [Locale('en')],
//     path: 'assets/lang',
//     fallbackLocale: const Locale('en'),
//     child: ProviderScope(
//         overrides: [
//           platformTypeProvider.overrideWithValue(platformType),
//         ],
//         observers: [
//           Logger()
//         ],
//         child: MaterialApp(
//           debugShowCheckedModeBanner: false,
//           theme: AppTheme.light,
//           home: const App(),
//         )),
//   ));
// }

Future<void> start() async {
  // 1. Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize Firebase (MUST be done after WidgetsFlutterBinding and BEFORE using any Firebase services)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    log('Firebase initialized successfully.');
  } catch (e) {
    log('Error initializing Firebase: $e');
    // Handle critical error if Firebase fails to initialize
    // You can display an error screen instead of running the app
    // return; // Exit if Firebase cannot be initialized
  }

  // 3. Register background message handler (AFTER Firebase.initializeApp)
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 4. Initialize other services (EasyLocalization, DateFormatting)
  await EasyLocalization.ensureInitialized();
  await Future.wait([
    initializeDateFormatting('', ''),
  ]);

  // 5. Configure Flutter error handling
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  // 6. Detect Platform
  final platformType = detectPlatformType();

  // 7. Create ProviderContainer to be able to read providers BEFORE runApp
  final container = ProviderContainer(
    overrides: [
      platformTypeProvider.overrideWithValue(platformType),
    ],
    observers: [
      Logger(), // Riverpod logger
    ],
  );

  // 8. Initialize FCM Service (AFTER Firebase.initializeApp and BEFORE runApp)
  try {
    await container.read(fcmServiceProvider).initialize();
    log('FCM Service initialized from start().');
  } catch (e) {
    log('Error initializing FCM Service in start(): $e');
  }

  // 9. Run the Flutter application
  runApp(
    UncontrolledProviderScope(
      container: container, // Pass the created container to ProviderScope
      child: EasyLocalization(
        supportedLocales: const [Locale('en')],
        path: 'assets/lang',
        fallbackLocale: const Locale('en'),
        child: const App(), // Run the main App widget
      ),
    ),
  );
}
