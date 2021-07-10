import 'package:knee_acl_mcl/exercises/exercises.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExercisesService {
  static FirebaseFirestore _fb = FirebaseFirestore.instance;
  static CollectionReference _exercisesCollection = _fb.collection('exercises');
  static Duration breakBetweenExercises = Duration(seconds: 5);
  static List<Exercise> _exercises = [];

  static List<Exercise> get exercises => [..._exercises];


  static Future<bool> addExercise(Exercise exercise) {
    return _exercisesCollection
      .add(exercise.toJson())
      .then((_) => true)
      .catchError((_) => false);
  }

  static Future<List<Exercise>> getMyExercises() {
    return _exercisesCollection
      .get()
      .then((QuerySnapshot querySnapshot) {
        _exercises = Exercise.fromJsonToList(querySnapshot.docs);
        return Exercise.fromJsonToList(querySnapshot.docs);
      });
  }

  static Map<dynamic, List<Exercise>> get groupedExercises {
    Map<dynamic, List<Exercise>> groupedLists = {};

    exercises.forEach((product) {
      product.group.forEach((group) {
        if (groupedLists['$group'] == null) {
          groupedLists['$group'] = <Exercise>[];
        }
        (groupedLists['$group'] as List<Exercise>).add(product);
      });
    });

    return groupedLists;
  }


  static Duration getTotalExercisesTime([List<Exercise>? listOfExercises]) {
    Duration _totalDuration = Duration(seconds: 0);
    List<Exercise> _exercises = listOfExercises ?? exercises;

    _exercises.forEach((exercise) {
      _totalDuration += (exercise.time * exercise.repeat) + (exercise.pauseTime * (exercise.repeat - 1));
    });
    _totalDuration += Duration(seconds: (_exercises.length - 1) * ExercisesService.breakBetweenExercises.inSeconds);

    return _totalDuration;
  }

}