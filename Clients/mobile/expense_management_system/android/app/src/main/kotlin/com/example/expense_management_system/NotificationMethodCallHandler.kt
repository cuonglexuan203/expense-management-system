package com.example.expense_management_system

import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.provider.Settings
import android.text.TextUtils
import android.util.Log
import androidx.core.app.NotificationManagerCompat
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import android.service.notification.NotificationListenerService
import android.os.Build


class NotificationMethodCallHandler(private val context: Context) : MethodChannel.MethodCallHandler {

    companion object {
        private const val TAG = "NotificationMethodCall"
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "checkNotificationListenerPermission" -> {
                val hasPermission = isNotificationServiceEnabled()
                Log.d(TAG, "Check Permission: $hasPermission")
                result.success(hasPermission)
            }
            "requestNotificationListenerPermission" -> {
                try {
                    val intent = Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS)
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    context.startActivity(intent)
                    Log.d(TAG, "Opened Notification Listener Settings.")
                    result.success(true)
                } catch (e: Exception) {
                    Log.e(TAG, "Error opening Notification Listener Settings: ${e.message}")
                    result.error("SETTINGS_ERROR", "Could not open Notification Listener settings.", e.message)
                }
            }
            "startListenerService" -> {
                 try {
                     val componentName = ComponentName(context, MyNotificationListener::class.java)
                     if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                         NotificationListenerService.requestRebind(componentName)
                         Log.d(TAG, "Requested rebind for MyNotificationListener.")
                         result.success(true)
                     } else {
                         Log.w(TAG, "Requesting rebind is only supported on Android N+.")
                         result.success(false)
                     }
                 } catch (e: Exception) {
                     Log.e(TAG, "Error requesting rebind for listener service: ${e.message}")
                     result.error("REBIND_ERROR", "Could not request rebind.", e.message)
                 }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun isNotificationServiceEnabled(): Boolean {
        val pkgName = context.packageName
        val flat = Settings.Secure.getString(context.contentResolver, "enabled_notification_listeners")
        if (!TextUtils.isEmpty(flat)) {
            val names = flat.split(":".toRegex()).dropLastWhile { it.isEmpty() }.toTypedArray()
            for (name in names) {
                val cn = ComponentName.unflattenFromString(name)
                if (cn != null) {
                    if (TextUtils.equals(pkgName, cn.packageName)) {
                        return true
                    }
                }
            }
        }
        return false
    }
}
