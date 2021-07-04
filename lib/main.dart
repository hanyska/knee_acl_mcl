import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:knee_acl_mcl/helpers/colors.dart';
import 'package:knee_acl_mcl/helpers/navigation_service.dart';
import 'package:knee_acl_mcl/home_page.dart';
import 'package:knee_acl_mcl/login_page.dart';
import 'package:knee_acl_mcl/utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? firebaseUser = FirebaseAuth.instance.currentUser;

    return MaterialApp(
      title: 'Knee ACL MCL',
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.navigatorKey,
      theme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
          primarySwatch: createMaterialColor(kPrimaryColor),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Lato',
          textTheme: TextTheme(
              headline1: TextStyle(
                fontFamily: 'Dancing',
                fontWeight: FontWeight.bold,
                fontSize: 52,
              )
          )
      ),
      routes: {
        // NewRecipeScreen.routeName: (context) => NewRecipeScreen(),
      },
      home: firebaseUser != null
        ? HomePage()
        : LoginPage(),
    );
  }
}
