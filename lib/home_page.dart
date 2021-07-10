import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:knee_acl_mcl/exercises/exercise_details_page.dart';
import 'package:knee_acl_mcl/exercises/exercise_item.dart';
import 'package:knee_acl_mcl/helpers/date_time_helper.dart';
import 'package:knee_acl_mcl/main/app_bar.dart';
import 'package:knee_acl_mcl/providers/exercises_service.dart';
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
      MaterialPageRoute(builder: (context) => ExerciseDetailsPage(exercise: ExercisesService.exercises[_exercisesCount])),
    ).then((isSuccess) {
      if (isSuccess is bool && isSuccess == true) {
        _exercisesCount++;
        if (_exercisesCount < ExercisesService.exercises.length) Future.delayed(ExercisesService.breakBetweenExercises, _startAll);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: 'Ćwiczenia ACL'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Column(
                children: ExercisesService.exercises
                  .map((e) => ExerciseItem(exercise: e))
                  .toList()
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Całkowity czas: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: kRed)),
                  Text(DateTimeHelper.timerText(ExercisesService.getTotalExercisesTime, true), style: TextStyle(fontSize: 16, color: kGrey)),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_arrow, color: kWhite,),
        onPressed: _startAll,
      ),
    );
  }
}
