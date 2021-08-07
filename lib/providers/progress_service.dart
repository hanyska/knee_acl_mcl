import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:knee_acl_mcl/models/progress.dart';
import 'package:knee_acl_mcl/providers/exercises_service.dart';
import 'package:knee_acl_mcl/providers/firebase_service.dart';

class ProgressService {
  static CollectionReference _mainCollection =  FirebaseFirestore.instance.collection('progress');
  static CollectionReference _progressCollection = _mainCollection.doc(FirebaseService.userId).collection('items');
  static List<Progress> _progress = [];

  static List<Progress> get progress => [..._progress];


  static Future<bool> addProgress(Progress progress) {
    return _progressCollection
      .add(progress.toJson())
      .then((_) => true)
      .catchError((_) => false);
  }

  static Future<bool> addIfNotExistProgress(Progress progress) {
    return _progressCollection
      .where('date', isEqualTo: progress.date.toString())
      .get()
      .then((QuerySnapshot querySnapshot) => querySnapshot.docs.isEmpty
          ? addProgress(progress)
          : Future.value(false)
      );
  }

  static Future<bool> updateProgress(Progress progress) {

    return _progressCollection
      .where('date', isEqualTo: progress.date.toString())
      .get()
      .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          Progress _progress = Progress.fromJson(doc.id, doc.data() as Map<String, dynamic>);

          doc.reference.update({
            'doneIdExercises': FieldValue.arrayUnion(progress.doneIdExercises),
            'isDone': ExercisesService.exercises.length == _progress.doneIdExercises.length
          });

          // doc.reference.update({
          //   'doneIdExercises': FieldValue.arrayUnion(progress.doneIdExercises),
          // });
        });

        return true;
      })
      .catchError((e) {
        print(e);
        return false;
    });
  }

  static Future<List<Progress>> getProgress() {
    return _progressCollection
      .get()
      .then((QuerySnapshot querySnapshot) {
        _progress = Progress.fromJsonToList(querySnapshot.docs);
        return Progress.fromJsonToList(querySnapshot.docs);
    });
  }
}
