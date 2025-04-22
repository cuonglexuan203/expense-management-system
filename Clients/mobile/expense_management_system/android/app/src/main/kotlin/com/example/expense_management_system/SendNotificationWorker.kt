// package com.example.expense_management_system

// import android.content.Context
// import androidx.work.CoroutineWorker
// import androidx.work.WorkerParameters
// import androidx.work.workDataOf
// import kotlinx.coroutines.Dispatchers
// import kotlinx.coroutines.withContext
// import java.io.OutputStreamWriter
// import java.net.HttpURLConnection
// import java.net.URL
// import org.json.JSONObject // Import JSONObject

// class SendNotificationWorker(appContext: Context, workerParams: WorkerParameters) :
//     CoroutineWorker(appContext, workerParams) {

//     companion object {
//         const val KEY_PACKAGE_NAME = "packageName"
//         const val KEY_TITLE = "title"
//         const val KEY_TEXT = "text"
//         const val KEY_TIMESTAMP = "timestamp"
//         const val KEY_EXTRAS = "extras"
//     }

//     override suspend fun doWork(): Result = withContext(Dispatchers.IO) {
//         val packageName = inputData.getString(KEY_PACKAGE_NAME) ?: return@withContext Result.failure()
//         val title = inputData.getString(KEY_TITLE) ?: ""
//         val text = inputData.getString(KEY_TEXT) ?: ""
//         val timestamp = inputData.getLong(KEY_TIMESTAMP, System.currentTimeMillis())
//         val extrasJsonString = inputData.getString(KEY_EXTRAS)

//         // TODO: Thay thế bằng URL API Backend của bạn
//         // val apiUrl = "YOUR_BACKEND_API_ENDPOINT/system-notifications"
//         val apiUrl = assets.

//         // Tạo JSON Payload
//         val jsonPayload = JSONObject()
//         jsonPayload.put("packageName", packageName)
//         jsonPayload.put("title", title)
//         jsonPayload.put("text", text)
//         jsonPayload.put("timestamp", timestamp)
//         // if (extrasJsonString != null) {
//         //     try {
//         //         jsonPayload.put("extras", JSONObject(extrasJsonString))
//         //     } catch (e: JSONException) {
//         //         // Xử lý lỗi nếu extras không phải JSON hợp lệ
//         //     }
//         // }


//         println("SendNotificationWorker: Sending notification data to $apiUrl")
//         println("SendNotificationWorker: Payload: ${jsonPayload.toString()}")

//         var connection: HttpURLConnection? = null
//         try {
//             val url = URL(apiUrl)
//             connection = url.openConnection() as HttpURLConnection
//             connection.requestMethod = "POST"
//             connection.setRequestProperty("Content-Type", "application/json; charset=UTF-8")
//             connection.setRequestProperty("Accept", "application/json")
//             // TODO: Thêm Header Authorization nếu API yêu cầu (ví dụ: API Key)
//             // connection.setRequestProperty("Authorization", "Bearer YOUR_API_KEY_OR_TOKEN")
//             connection.doOutput = true // Cho phép gửi body
//             connection.connectTimeout = 15000 // 15 giây
//             connection.readTimeout = 15000 // 15 giây

//             // Gửi JSON payload
//             val outputStream = connection.outputStream
//             val writer = OutputStreamWriter(outputStream, "UTF-8")
//             writer.write(jsonPayload.toString())
//             writer.flush()
//             writer.close()
//             outputStream.close()

//             val responseCode = connection.responseCode
//             println("SendNotificationWorker: Response Code: $responseCode")

//             // Kiểm tra response code
//             if (responseCode in 200..299) {
//                 println("SendNotificationWorker: Successfully sent notification data.")
//                 Result.success() // Gửi thành công
//             } else {
//                 // Đọc response body nếu có lỗi (tùy chọn)
//                 // val errorStream = connection.errorStream?.bufferedReader()?.use { it.readText() }
//                 // println("SendNotificationWorker: Error response: $errorStream")

//                 // Thử lại nếu là lỗi server hoặc mạng (ví dụ: 5xx)
//                 if (responseCode >= 500) {
//                      println("SendNotificationWorker: Server error, retrying...")
//                      Result.retry()
//                 } else {
//                      println("SendNotificationWorker: Client error or other issue, failing.")
//                      Result.failure() // Lỗi không nên thử lại (ví dụ: 4xx)
//                 }
//             }
//         } catch (e: Exception) {
//             println("SendNotificationWorker: Exception during API call: ${e.message}")
//             Result.retry() // Thử lại nếu có lỗi mạng hoặc exception khác
//         } finally {
//             connection?.disconnect()
//         }
//     }
// }
