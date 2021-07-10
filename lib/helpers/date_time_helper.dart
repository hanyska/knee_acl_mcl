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
}