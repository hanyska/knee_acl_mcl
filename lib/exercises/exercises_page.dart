import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:knee_acl_mcl/exercises/exercise_details_page.dart';
import 'package:knee_acl_mcl/exercises/exercise_item.dart';
import 'package:knee_acl_mcl/exercises/exercise.dart';
import 'package:knee_acl_mcl/helpers/date_time_helper.dart';
import 'package:knee_acl_mcl/helpers/main_helper.dart';
import 'package:knee_acl_mcl/providers/exercises_service.dart';
import 'package:knee_acl_mcl/utils/utils.dart';

class ExercisesPage extends StatefulWidget {
  static const routeName = '/exercises';

  @override
  _ExercisesPageState createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> with TickerProviderStateMixin {
  User? user;
  int _exercisesCount = 0;
  List<Exercise> _exercises = [];

  @override
  void initState() {
    getCurrentUser();
    getExercises();
    super.initState();
  }

  void getCurrentUser() {
    user = FirebaseAuth.instance.currentUser;
  }

  Future<List<Exercise>> getExercises() async {
    return ExercisesService
      .getMyExercises();
  }

  void _startExercises([List<Exercise>? exercises]) {
    List<Exercise> _exercisesList = exercises ?? _exercises;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ExerciseDetailsPage(exercise: _exercisesList[_exercisesCount])),
    ).then((isSuccess) async {
      if (isSuccess is bool && isSuccess == true) {
        _exercisesCount++;
        if (_exercisesCount < _exercisesList.length) {
          await FlutterTts().speak('PRZERWA');
          Future.delayed(ExercisesService.breakBetweenExercises, _startExercises);
        }
      }
    });
  }

  Widget _timeWidget(String text, [List<Exercise>? exercises]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: kRed)),
          ),
          Text(DateTimeHelper.timerText(ExercisesService.getTotalExercisesTime(exercises), true), style: TextStyle(fontSize: 16, color: kGrey)),
        ]),
        if (exercises != null) TextButton(
          onPressed: () => _startExercises(exercises),
          child: Text('Start', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: kRed)),
        )
      ],
    );
  }

  Widget _titleWidget(String text) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        MainHelper.enumToString(text),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21, color: kRed),
        textAlign: TextAlign.center
      ),
    );
  }

  Widget _sectionWidget(List<Exercise> exercises) {
    exercises = exercises..sort((a, b) {
      int result;
      if (a.orderId == null) {
        result = 1;
      } else if (b.orderId == null) {
        result = -1;
      } else {
        // Ascending Order
        result = a.orderId!.compareTo(b.orderId!);
      }
      return result;
    });

    return Card(
      color: kYellow,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(children: [
          SizedBox(height: 10),
          ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            itemCount: exercises.length,
            itemBuilder: (context, index) => ExerciseItem(exercise: exercises[index]),
            separatorBuilder: (_, __) => SizedBox(height: 15),
          ),
          _timeWidget('Czas: ', exercises)
        ]),
      )
    );
  }

  List<Widget> get _items {
    List<Widget> _widgets = [];

    List<dynamic> keys = ExercisesService.groupedExercises.keys.toList()..sort();

    for (String key in keys) {
      _widgets.add(_titleWidget(key));
      _widgets.add(_sectionWidget(ExercisesService.groupedExercises[key]!.toList()));
    }
    return _widgets;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Exercise>>(
      future: getExercises(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Exercise>? _exs = snapshot.data;
          return RefreshIndicator(
              onRefresh: getExercises,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ..._items,
                    SizedBox(height: 10),
                    _timeWidget('Całkowity czas: ', _exs),
                    SizedBox(height: 10),
                  ],
                ),
              )
          );
        } else {
          return Center(child: CircularProgressIndicator(strokeWidth: 1.5));
          }
      },
    );
  }
}
