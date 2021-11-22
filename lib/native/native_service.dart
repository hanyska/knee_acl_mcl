import 'package:flutter/services.dart';

class NativeService {
    static const platform = MethodChannel('com.janua');


  static Future<bool> setOperationDate(DateTime date) async {
    bool success = false;
    try {
      success = await platform.invokeMethod('setOperationDate', {"date": date.toString()});
    } on PlatformException catch (_) {
      success = false;
    }

    return success;
  }


}