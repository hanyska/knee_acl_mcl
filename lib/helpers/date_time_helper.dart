class DateTimeHelper {
  static DateTime? toDateTime(String? date) {
    if (date == "" || date == null) return null;

    return DateTime.parse(date);
  }

  static String timerText(Duration duration, [bool withAdditionalString = false]) {
    String _minutes = duration.inMinutes.toString().padLeft(2, '0');
    String _seconds = (duration.inSeconds % 60 + 1).toString().padLeft(2, '0');

    if (withAdditionalString) {
      return '$_minutes minut $_seconds sekund';
    } else {
      return '$_minutes:$_seconds';
    }
  }

  static bool isTheSameDateWithoutHours(DateTime date1, DateTime date2) {
    return date1.day == date2.day
        && date1.month == date2.month
        && date1.year == date2.year;
  }
}
