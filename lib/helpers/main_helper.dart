import 'package:collection/collection.dart';

class MainHelper {
  static String enumToString(Object o) => o.toString().split('.').last;

  static T? enumFromString<T>(String key, List<T> values) => values.firstWhereOrNull((v) => key == enumToString(v!));
}