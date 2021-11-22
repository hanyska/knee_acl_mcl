package com.janua.knee_acl_mcl

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import android.widget.RemoteViews
import java.lang.Math.floor
import java.text.SimpleDateFormat
import java.util.*
import java.util.concurrent.TimeUnit

/**
 * Implementation of App Widget functionality.
 */
class CounterOperaction : AppWidgetProvider() {
    var date: String = ""

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId, date)
        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }

    override fun onReceive(context: Context?, intent: Intent) {
        date = intent.getStringExtra("DATE")!!
        super.onReceive(context, intent)
    }
}

private fun _scheduleNextUpdate(context: Context) {
    val alarmManager: AlarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
    val midnight = Calendar.getInstance()
    midnight[Calendar.HOUR_OF_DAY] = 0
    midnight[Calendar.MINUTE] = 0
    midnight[Calendar.SECOND] = 1
    midnight[Calendar.MILLISECOND] = 0
    midnight.add(Calendar.DAY_OF_YEAR, 1)
    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.KITKAT) {
        alarmManager.set(AlarmManager.RTC_WAKEUP, midnight.timeInMillis, pendingIntent)
    } else {
        alarmManager.setExact(AlarmManager.RTC_WAKEUP, midnight.timeInMillis, pendingIntent)
    }
}

internal fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int, date: String) {
    val views = RemoteViews(context.packageName, R.layout.counter_operaction)
    val dateFormat = SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH)
    val now = Date()
    val operationDate: Date = dateFormat.parse(date)!!
    val diff: Long = now.time - operationDate.time
    var inDays: Int = (TimeUnit.DAYS.convert(diff, TimeUnit.MILLISECONDS)).toInt()
    var inWeeks: Int = kotlin.math.floor((inDays / 7).toDouble()).toInt()

    views.setTextViewText(R.id.operationDate, SimpleDateFormat("dd MMMM yyyy", Locale("pl")).format(operationDate))
    views.setTextViewText(R.id.daysCount, inDays.toString())
    views.setTextViewText(R.id.weeksCount, inWeeks.toString())

    appWidgetManager.updateAppWidget(appWidgetId, views)
}