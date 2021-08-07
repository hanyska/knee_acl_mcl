class NumberUtils {
  static int? toInt(String? text) {
    if (text == null || text == '') return null;

    return int.parse(text);
  }
}
