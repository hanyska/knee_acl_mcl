import 'package:knee_acl_mcl/exercises/exercises.dart';

class ExercisesService {
  static Duration breakBetweenExercises = Duration(seconds: 5);

  static List<Exercise> get exercises => [...databaseExercise];


  static Duration get getTotalExercisesTime {
    Duration _totalDuration = Duration(seconds: 0);

    exercises.forEach((exercise) {
      _totalDuration += (exercise.time * exercise.repeat) + exercise.pauseTime;
    });

    return _totalDuration;
  }

}