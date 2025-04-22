package com.example.expense_management_system

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }
}

// package com.example.expense_management_system // Thay bằng package của bạn

// import android.content.ComponentName
// import android.content.Context
// import android.content.Intent
// import android.provider.Settings
// import android.text.TextUtils
// import androidx.annotation.NonNull
// import io.flutter.embedding.android.FlutterActivity
// import io.flutter.embedding.engine.FlutterEngine
// import io.flutter.plugin.common.EventChannel
// import io.flutter.plugin.common.MethodChannel

// class MainActivity : FlutterActivity() {
//     private val NOTIFICATION_CHANNEL = "com.expense_management_system/notification_listener"
//     private val EVENT_CHANNEL = "com.expense_management_system/notification_events"

//     override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//         super.configureFlutterEngine(flutterEngine)

//         // --- Method Channel ---
//         MethodChannel(flutterEngine.dartExecutor.binaryMessenger, NOTIFICATION_CHANNEL).setMethodCallHandler { call, result ->
//             when (call.method) {
//                 "checkNotificationListenerPermission" -> {
//                     result.success(isNotificationServiceEnabled())
//                 }
//                 "requestNotificationListenerPermission" -> {
//                     val intent = Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS)
//                     // Kiểm tra xem có Activity nào xử lý Intent này không
//                     if (intent.resolveActivity(packageManager) != null) {
//                         startActivity(intent)
//                         // Không thể biết ngay kết quả, trả về true để Flutter biết đã mở Settings
//                         result.success(true)
//                     } else {
//                          println("MainActivity: Could not open Notification Listener Settings.")
//                          result.success(false) // Không mở được Settings
//                     }
//                 }
//                 "startListenerService" -> {
//                     // Service thường tự khởi động nếu được khai báo đúng trong Manifest
//                     // Gọi startService ở đây có thể không cần thiết hoặc dùng để đảm bảo
//                     try {
//                        val intent = Intent(this, NotificationListener::class.java)
//                        startService(intent)
//                        println("MainActivity: Attempted to start NotificationListener service.")
//                        result.success(true)
//                     } catch (e: Exception) {
//                        println("MainActivity: Error starting NotificationListener service: ${e.message}")
//                        result.error("SERVICE_START_ERROR", e.message, null)
//                     }
//                 }
//                 else -> result.notImplemented()
//             }
//         }

//         // --- Event Channel ---
//         EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(
//             object : EventChannel.StreamHandler {
//                 override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
//                     NotificationListener.eventSink = events // Lưu sink để Service sử dụng
//                     println("MainActivity: EventChannel onListen")
//                 }

//                 override fun onCancel(arguments: Any?) {
//                     NotificationListener.eventSink = null // Xóa sink khi Flutter không lắng nghe nữa
//                     println("MainActivity: EventChannel onCancel")
//                 }
//             }
//         )
//     }

//     // Kiểm tra xem Notification Listener Service có đang được bật hay không
//     private fun isNotificationServiceEnabled(): Boolean {
//         val pkgName = packageName
//         val flat = Settings.Secure.getString(contentResolver, "enabled_notification_listeners")
//         if (!TextUtils.isEmpty(flat)) {
//             val names = flat.split(":".toRegex()).dropLastWhile { it.isEmpty() }.toTypedArray()
//             for (name in names) {
//                 val cn = ComponentName.unflattenFromString(name)
//                 if (cn != null) {
//                     if (TextUtils.equals(pkgName, cn.packageName)) {
//                         return true
//                     }
//                 }
//             }
//         }
//         return false
//     }
// }

