import 'package:knee_acl_mcl/exercises/widgets/exercise_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:knee_acl_mcl/providers/firebase_service.dart';

class ExercisesService {
  static CollectionReference _mainCollection = FirebaseFirestore.instance.collection('exercises');
  static CollectionReference _exercisesCollection = _mainCollection.doc(FirebaseService.userId!).collection('items');
  static Duration breakBetweenExercises = Duration(seconds: 5);
  static List<Exercise> _exercises = [];

  static List<Exercise> get exercises => [..._exercises];


  static Future<bool> addExercise(Exercise exercise) {
    return _exercisesCollection
      .add(exercise.toJson())
      .then((_) => true)
      .catchError((_) => false);
  }

  static Future<bool> updatedOrderId(Exercise exercise) {
    return _exercisesCollection
      .doc(exercise.id)
      .update({'orderId': exercise.orderId})
      .then((_) => true)
      .catchError((_) => false);
  }

  static Future<bool> updatedExercise(Exercise exercise) {
    return _exercisesCollection
      .doc(exercise.id)
      .update(exercise.toJson())
      .then((_) {
        getMyExercises();
        return true;
      })
      .catchError((_) => false);
  }

  static Future<bool> updatedOrderIdExercises(List<Exercise> exercises) {
    return Future.forEach(exercises, updatedOrderId)
      .then((value) => true)
      .catchError((_) => false);
  }

  static Future<bool> deleteExercise(String exerciseId) {
    return _exercisesCollection
      .doc(exerciseId)
      .delete()
      .then((_) {
        getMyExercises();
        return true;
      })
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
