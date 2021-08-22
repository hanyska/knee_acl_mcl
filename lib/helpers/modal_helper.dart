import 'package:flutter/material.dart';
import 'package:knee_acl_mcl/helpers/navigation_service.dart';

class ModalHelper {
  static showBottomSheet(Widget widget) {
    BuildContext context = NavigationService.navigatorKey.currentContext!;

    return showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      isScrollControlled: true,
      builder: (context) => widget
    );
  }
}