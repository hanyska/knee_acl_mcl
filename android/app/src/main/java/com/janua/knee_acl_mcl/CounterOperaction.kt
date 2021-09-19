package com.janua.knee_acl_mcl

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import java.lang.Math.floor
import java.text.SimpleDateFormat
import java.util.*
import java.util.concurrent.TimeUnit

/**
 * Implementation of App Widget functionality.
 */
class CounterOperaction : AppWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }
}

internal fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
    val views = RemoteViews(context.packageName, R.layout.counter_operaction)
    val dateFormat = SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH)
    val now = Date()
    val operationDate: Date = dateFormat.parse("2021-06-24")!!
    val diff: Long = now.time - operationDate.time
    var inDays: Int = (TimeUnit.DAYS.convert(diff, TimeUnit.MILLISECONDS)).toInt()
    var inWeeks: Int = kotlin.math.floor((inDays / 7).toDouble()).toInt()

    views.setTextViewText(R.id.operationDate, SimpleDateFormat("dd MMMM yyyy", Locale("pl")).format(operationDate))
    views.setTextViewText(R.id.daysCount, inDays.toString())
    views.setTextViewText(R.id.weeksCount, inWeeks.toString())

    appWidgetManager.updateAppWidget(appWidgetId, views)
}