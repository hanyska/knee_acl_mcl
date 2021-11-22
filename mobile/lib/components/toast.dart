import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:knee_acl_mcl/utils/utils.dart';

enum ToasterType { SUCCESS, WARNING, DANGER, DEFAULT }

class Toaster {

  static Color _getBackgroundColor(ToasterType toasterType) {
    switch(toasterType) {
      case ToasterType.SUCCESS:
        return kGreen;
      case ToasterType.WARNING:
        return kYellow;
      case ToasterType.DANGER:
        return kPrimaryColor;
      case ToasterType.DEFAULT:
      default:
        return kGrey;
    }
  }

 static show(String message, {ToasterType toasterType = ToasterType.DEFAULT, bool isLongLength = false}) {
    Color backgroundColor = _getBackgroundColor(toasterType);

    Fluttertoast.showToast(
     msg: message,
     toastLength: isLongLength ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
     gravity: ToastGravity.BOTTOM,
     backgroundColor: backgroundColor,
     textColor: Colors.white,
     fontSize: 16.0
    );
 }
}