import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState!.pushNamed(routeName);
  }

  void goBack() {
    return navigatorKey.currentState!.pop();
  }

  static navigateToPage(BuildContext context, Widget page) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page
      ),
    );
  }

  static navigateToNamed(BuildContext context, String? newRouteName, { Map<String,dynamic>? arguments, bool clearHistoryRoutes = false, Function? callback}) {
    if (clearHistoryRoutes) {
      Navigator.pushNamedAndRemoveUntil(context, newRouteName!, (route) => false, arguments: arguments);
      return;
    }
    Navigator.pushNamed(context, newRouteName!, arguments: arguments).then((value) {
      if (callback != null) return callback(value);
    });
  }

}
