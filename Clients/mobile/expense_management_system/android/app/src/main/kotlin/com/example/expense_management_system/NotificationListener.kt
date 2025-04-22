// package com.example.expense_management_system 

// import android.app.Notification
// import android.os.Build
// import android.os.Bundle
// import android.service.notification.NotificationListenerService
// import android.service.notification.StatusBarNotification
// import androidx.work.Constraints
// import androidx.work.NetworkType
// import androidx.work.OneTimeWorkRequestBuilder
// import androidx.work.WorkManager
// import androidx.work.workDataOf
// import io.flutter.plugin.common.EventChannel // Giữ lại nếu vẫn dùng EventChannel
// import org.json.JSONObject // Import JSONObject

// class NotificationListener : NotificationListenerService() {

//     // Giữ lại EventChannel.EventSink nếu bạn vẫn muốn gửi sự kiện cho Flutter khi app chạy
//     companion object {
//          var eventSink: EventChannel.EventSink? = null
//     }

//     override fun onListenerConnected() {
//         super.onListenerConnected()
//         println("NotificationListener: Service Connected")
//     }

//     override fun onNotificationPosted(sbn: StatusBarNotification?) {
//         super.onNotificationPosted(sbn)
//         sbn?.notification?.let { notification ->
//             val packageName = sbn.packageName ?: "unknown"
//             val title = notification.extras.getString(Notification.EXTRA_TITLE) ?: ""
//             val text = notification.extras.getString(Notification.EXTRA_TEXT) ?: ""
//             val timestamp = sbn.postTime

//             // Lấy extras (nếu cần) - Chuyển thành JSON string để đưa vào WorkData
//             val extrasBundle: Bundle? = notification.extras
//             var extrasJsonString: String? = null
//             if (extrasBundle != null) {
//                 try {
//                     val extrasMap = bundleToMap(extrasBundle)
//                     extrasJsonString = JSONObject(extrasMap).toString()
//                 } catch (e: Exception) {
//                     println("NotificationListener: Error converting extras to JSON: ${e.message}")
//                 }
//             }


//             println("NotificationListener: Notification Posted from $packageName")
//             println("NotificationListener: Title: $title, Text: $text")

//             // --- Gửi dữ liệu qua WorkManager ---
//             val workDataBuilder = workDataOf(
//                 SendNotificationWorker.KEY_PACKAGE_NAME to packageName,
//                 SendNotificationWorker.KEY_TITLE to title,
//                 SendNotificationWorker.KEY_TEXT to text,
//                 SendNotificationWorker.KEY_TIMESTAMP to timestamp
//             )
//             if (extrasJsonString != null) {
//                 workDataBuilder.put(SendNotificationWorker.KEY_EXTRAS, extrasJsonString)
//             }
//             val workData = workDataBuilder.build()


//             // Đặt ràng buộc (ví dụ: chỉ chạy khi có mạng)
//             val constraints = Constraints.Builder()
//                 .setRequiredNetworkType(NetworkType.CONNECTED)
//                 .build()

//             // Tạo WorkRequest
//             val workRequest = OneTimeWorkRequestBuilder<SendNotificationWorker>()
//                 .setInputData(workData)
//                 .setConstraints(constraints)
//                 // .setBackoffCriteria(...) // Cấu hình retry backoff nếu cần
//                 .build()

//             // Đưa vào hàng đợi WorkManager
//             WorkManager.getInstance(applicationContext).enqueue(workRequest)
//             println("NotificationListener: Enqueued work request for package $packageName")
//             // --- Kết thúc gửi qua WorkManager ---


//             // --- (TÙY CHỌN) Gửi dữ liệu qua EventChannel cho Flutter UI (nếu app đang chạy) ---
//              eventSink?.success(mapOf(
//                  "packageName" to packageName,
//                  "title" to title,
//                  "text" to text,
//                  "timestamp" to timestamp,
//                  // "extras" to extrasMap // Gửi map nếu cần
//              ))
//             // --- Kết thúc gửi qua EventChannel ---
//         }
//     }

//     override fun onNotificationRemoved(sbn: StatusBarNotification?) {
//         super.onNotificationRemoved(sbn)
//         // Có thể xử lý khi notification bị xóa nếu cần
//     }

//     override fun onListenerDisconnected() {
//         super.onListenerDisconnected()
//         println("NotificationListener: Service Disconnected")
//     }

//     // Hàm helper để chuyển Bundle thành Map (cần thiết cho JSON)
//     private fun bundleToMap(bundle: Bundle): Map<String, Any?> {
//         val map = mutableMapOf<String, Any?>()
//         for (key in bundle.keySet()) {
//             val value = bundle.get(key)
//             // Xử lý các kiểu dữ liệu phổ biến
//             when (value) {
//                 is Bundle -> map[key] = bundleToMap(value)
//                 is Array<*> -> {
//                     // Cần xử lý array cẩn thận hơn nếu cần JSON hóa chính xác
//                     map[key] = value.map { if (it is Bundle) bundleToMap(it) else it }.toList()
//                 }
//                 else -> map[key] = value
//             }
//         }
//         return map
//     }
// }
