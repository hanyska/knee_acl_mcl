package com.janua.knee_acl_mcl

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Intent
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.janua"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "setOperationDate") {
                val date: String? = call.argument<String>("date")
                val success: Boolean = setOperationDate(date)

                if (success) {
                    result.success(true)
                } else {
                    result.error(null, null, null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun setOperationDate(date: String?): Boolean {
        return try {
            val intent = Intent(context, CounterOperaction::class.java)
            intent.action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
            val ids: IntArray = AppWidgetManager.getInstance(context.applicationContext).getAppWidgetIds(ComponentName(context, CounterOperaction::class.java))
            intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
            intent.putExtra("DATE", date)
            context.sendBroadcast(intent)
            true
        } catch (classException: ClassNotFoundException) {
            false
        }
    }
}
