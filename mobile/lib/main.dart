import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:knee_acl_mcl/calendar_page.dart';
import 'package:knee_acl_mcl/exercises/exercises_page.dart';
import 'package:knee_acl_mcl/helpers/colors.dart';
import 'package:knee_acl_mcl/helpers/navigation_service.dart';
import 'package:knee_acl_mcl/home_page.dart';
import 'package:knee_acl_mcl/login_page.dart';
import 'package:knee_acl_mcl/main/bottom_bar.dart';
import 'package:knee_acl_mcl/profile_page.dart';
import 'package:knee_acl_mcl/utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('pl')],
      fallbackLocale: Locale('pl'),
      path: 'assets/translations',
      useOnlyLangCode: true,
      child: MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? firebaseUser = FirebaseAuth.instance.currentUser;

    return MaterialApp(
      title: 'Knee ACL MCL',
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.navigatorKey,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
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
        HomePage.routeName: (context) => HomePage(),
        ExercisesPage.routeName: (context) => ExercisesPage(),
        CalendarPage.routeName: (context) => CalendarPage(),
        ProfilePage.routeName: (context) => ProfilePage(),
      },
      home: firebaseUser != null
        ? MainMenu()
        : LoginPage(),
    );
  }
}


class MainMenu extends StatefulWidget {
  MainMenu({Key? key}) : super(key: key);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyBottomBar()
    );
  }
}
