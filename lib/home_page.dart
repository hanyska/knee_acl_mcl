import 'package:flutter/material.dart';
import 'package:knee_acl_mcl/exercises/exercises_page.dart';
import 'package:knee_acl_mcl/main/app_bar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: 'Ćwiczenia ACL'),
      body: ExercisesPage()
    );
  }
}
