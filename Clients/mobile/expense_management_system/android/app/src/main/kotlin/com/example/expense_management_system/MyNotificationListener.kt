package com.example.expense_management_system

import android.app.Notification
import android.content.Context
import android.os.Build
import android.os.Bundle
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.util.Log
import io.ktor.client.*
import io.ktor.client.engine.android.*
import io.ktor.client.plugins.contentnegotiation.*
import io.ktor.client.request.*
import io.ktor.http.*
import io.ktor.serialization.kotlinx.json.*

import kotlinx.coroutines.*

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json
import kotlinx.serialization.decodeFromString


import java.io.IOException 
import java.security.GeneralSecurityException 


@Serializable
data class SystemNotificationPayload(
    val packageName: String,
    val title: String,
    val text: String,
    val timestamp: Long,
    val extras: Map<String, String?>?
)

@Serializable
data class StoredToken(
    val token: String? = null,
    val accessToken: String? = null,
    val refreshToken: String? = null,
    val accessTokenExpiration: String? = null,
    val refreshTokenExpiration: String? = null
)
// ----------------------------------------------------

class MyNotificationListener : NotificationListenerService() {

    companion object {
        private const val TAG = "MyNotificationListener"
        private const val API_KEY_HEADER = "X-API-Key"
        private const val AUTHORIZATION_HEADER = "Authorization"

        // --- SỬA ĐỔI CHO TEST ---
        private const val STANDARD_SHARED_PREFS_FILE_NAME = "FlutterSharedPreferences"
        private const val FLUTTER_TOKEN_KEY = "StoreKey.token"
        private const val NATIVE_STANDARD_PREFS_KEY = "flutter.$FLUTTER_TOKEN_KEY"

        private val allowedPackageNames = setOf(
            "com.google.android.gm",
            "com.VCB",           
            "vn.com.techcombank.bb.app",
            "com.mbmobile", 
            "com.zing.zalo",   
        )
    }

    private val serviceScope = CoroutineScope(Dispatchers.IO + SupervisorJob())
    private val json = Json { ignoreUnknownKeys = true; isLenient = true }
    private val httpClient = HttpClient(Android) {
        install(ContentNegotiation) { json(json) }
    }

    override fun onListenerConnected() {
        super.onListenerConnected()
        Log.i(TAG, "Notification Listener connected.")
    }

    override fun onListenerDisconnected() {
        super.onListenerDisconnected()
        Log.i(TAG, "Notification Listener disconnected.")
        serviceScope.cancel()
    }

    override fun onDestroy() {
        super.onDestroy()
        Log.i(TAG, "Notification Listener destroyed.")
        serviceScope.cancel()
        httpClient.close()
    }

    override fun onNotificationPosted(sbn: StatusBarNotification?) {
        super.onNotificationPosted(sbn)
        if (sbn == null) return

        val notification = sbn.notification ?: return
        val packageName = sbn.packageName ?: "unknown"

        if (packageName !in allowedPackageNames) {
            return
        }
        Log.d(TAG, "Processing notification from whitelisted package: $packageName")

        val postTime = sbn.postTime
        val extras = notification.extras ?: Bundle()
        val title = extras.getString(Notification.EXTRA_TITLE) ?: ""
        val text = extras.getCharSequence(Notification.EXTRA_TEXT)?.toString() ?: ""
        val bigText = extras.getCharSequence(Notification.EXTRA_BIG_TEXT)?.toString() ?: ""
        val textLines = extras.getCharSequenceArray(Notification.EXTRA_TEXT_LINES)?.mapNotNull { it?.toString() }

        var combinedText = text
        if (bigText.isNotBlank() && bigText != text) { combinedText = bigText }
        else if (!textLines.isNullOrEmpty()) {
             val linesContent = textLines.joinToString("\n")
             if (linesContent.length > text.length) { combinedText = linesContent }
        }

        Log.d(TAG, "  Title: '$title'")
        Log.d(TAG, "  Combined Text for Payload: '$combinedText'")

        val payload = SystemNotificationPayload(
            packageName = packageName,
            title = title,
            text = combinedText,
            timestamp = postTime,
            extras = bundleToSimpleMap(extras)
        )

        val accessToken = getAccessTokenFromSharedPreferences(applicationContext)

        val apiKey = "E4164EFEA68EA6A9CAC2AB5761518"
        val backendUrl = "http://103.116.104.20:9002/api/v1/notifications/analyze"
        // val backendUrl = "https://wzwmrgk9-5284.asse.devtunnels.ms/api/v1/notifications/analyze"

        if (backendUrl.isNullOrEmpty()) {
             return
        }

        if (accessToken == null) {
            Log.e(TAG, "[TEST] !!! CRITICAL: Failed to retrieve Access Token from STANDARD SharedPreferences.")
        } else {
            Log.i(TAG, "[TEST] Access Token retrieved successfully from STANDARD SharedPreferences.")
        }

        serviceScope.launch {
            sendNotificationToBackend(payload, apiKey, backendUrl, accessToken)
        }
    }

    private fun getAccessTokenFromSharedPreferences(context: Context): String? {
        try {
            val sharedPreferences = context.getSharedPreferences(
                STANDARD_SHARED_PREFS_FILE_NAME,
                Context.MODE_PRIVATE
            )

            val tokenJson = sharedPreferences.getString(NATIVE_STANDARD_PREFS_KEY, null)

            if (tokenJson != null) {
                return try {
                    val storedToken = json.decodeFromString<StoredToken>(tokenJson)
                    Log.i(TAG, "[TEST] Successfully parsed token JSON from standard SharedPreferences. AccessToken found.")
                    storedToken.accessToken
                } catch (e: Exception) {
                    Log.e(TAG, "[TEST] Failed to parse token JSON from standard SharedPreferences: ${e.message}", e)
                    null
                }
            } else {
                try {
                    val allKeys = sharedPreferences.all?.keys ?: emptySet()
                } catch (e: Exception) { Log.e(TAG, "[TEST] Error reading all keys: ${e.message}") }
                return null
            }
        } catch (e: Exception) {
            Log.e(TAG, "[TEST] Unexpected error reading access token from standard SharedPreferences: ${e.message}", e)
            return null
        }
    }


    private suspend fun sendNotificationToBackend(
        payload: SystemNotificationPayload,
        apiKey: String?,
        backendUrl: String,
        accessToken: String?
    ) {
         try {
            val response = httpClient.post(backendUrl) {
                contentType(ContentType.Application.Json)
                headers {
                    if (accessToken != null) {
                        append(AUTHORIZATION_HEADER, "Bearer $accessToken")
                    } else {
                        Log.w(TAG, "Sending request without Authorization header (token was null).")
                    }
                    // if (apiKey != null) {
                    //    append(API_KEY_HEADER, apiKey)
                    //    Log.d(TAG, "Added API Key header.")
                    // }
                }
                setBody(payload)
            }
            Log.i(TAG, "Backend response status: ${response.status}")
             if (response.status.value >= 400) {
                 Log.w(TAG, "Backend returned error status: ${response.status}")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error sending notification to backend: ${e.message}", e)
        }
    }

    private fun bundleToSimpleMap(bundle: Bundle?): Map<String, String?>? {
        if (bundle == null) return null
        val map = mutableMapOf<String, String?>()
        for (key in bundle.keySet()) {
            map[key] = bundle.get(key)?.toString()
        }
        return map.toMap()
    }
}
