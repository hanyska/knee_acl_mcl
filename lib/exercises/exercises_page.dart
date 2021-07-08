import 'package:flutter/material.dart';
import 'package:knee_acl_mcl/exercises/exercise_item.dart';
import 'package:knee_acl_mcl/exercises/exercises.dart';

class ExercisesPage extends StatefulWidget {
  @override
  _ExercisesPageState createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          children: exercises
            .map((e) => ExerciseItem(exercise: e))
            .toList()
        )
      ),
    );
  }
}