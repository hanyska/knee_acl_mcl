import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:knee_acl_mcl/exercises/exercise_details_page.dart';
import 'package:knee_acl_mcl/exercises/exercise_item.dart';
import 'package:knee_acl_mcl/exercises/exercises.dart';
import 'package:knee_acl_mcl/main/app_bar.dart';
import 'package:knee_acl_mcl/utils/utils.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  User? user;
  int _exercisesCount = 0;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() {
    user = FirebaseAuth.instance.currentUser;
  }

  void _startAll() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ExerciseDetailsPage(exercise: exercises[_exercisesCount])),
    ).then((isSuccess) {
      if (isSuccess is bool && isSuccess == true) {
        _exercisesCount++;
        if (_exercisesCount < exercises.length) Future.delayed(Duration(seconds: 5), _startAll);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: 'Ćwiczenia ACL'),
      body: SafeArea(
        child: Container(
          child: Column(
            children: exercises
              .map((e) => ExerciseItem(exercise: e))
              .toList()
          )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_arrow, color: kWhite,),
        onPressed: _startAll,
      ),
    );
  }
}
