package com.example.expense_management_system

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterFragmentActivity() { 
    private val notificationListenerMethodChannel = "com.expense_management_system/notification_listener"
    private val notificationEventsEventChannel = "com.expense_management_system/notification_events"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, notificationListenerMethodChannel).setMethodCallHandler(
            NotificationMethodCallHandler(applicationContext)
        )
        println("MethodChannel '$notificationListenerMethodChannel' configured.") 
    }
}

