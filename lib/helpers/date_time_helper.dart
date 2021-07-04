class DateTimeHelper {
  static DateTime? toDateTime(String? date) {
    if (date == "" || date == null) return null;

    return DateTime.parse(date);
  }
}