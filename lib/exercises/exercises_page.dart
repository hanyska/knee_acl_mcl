import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:knee_acl_mcl/exercises/exercise_details_page.dart';
import 'package:knee_acl_mcl/exercises/widgets/exercise_item.dart';
import 'package:knee_acl_mcl/exercises/widgets/exercise_model.dart';
import 'package:knee_acl_mcl/helpers/date_time_helper.dart';
import 'package:knee_acl_mcl/providers/exercises_service.dart';
import 'package:knee_acl_mcl/utils/utils.dart';

class ExercisesPage extends StatefulWidget {
  static const routeName = '/exercises';

  @override
  _ExercisesPageState createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> with TickerProviderStateMixin {
  int _exercisesCount = 0;
  List<Exercise> _exercises = [];

  @override
  void initState() {
    getExercises();
    super.initState();
  }

  Future<List<Exercise>> getExercises() async {
    return ExercisesService.getMyExercises();
  }

  void _startExercises([List<Exercise>? exercises]) {
    List<Exercise> _exercisesList = exercises ?? _exercises;

    ExerciseDetailsPage
      .show(_exercisesList[_exercisesCount])
      .then((isSuccess) async {
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

  Widget _list(List<Exercise> exercises) {
    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      itemCount: exercises.length,
      itemBuilder: (context, index) => ExerciseItem(
        exercise: exercises[index],
        onEdit: (bool edited) { if (edited) setState((){});},
        onDelete: (bool deleted) { if (deleted) setState((){});},
      ),
      separatorBuilder: (_, __) => SizedBox(height: 10),
    );
  }

  Widget _listReordered(List<Exercise> exercises) {
    exercises.sort((exA, exB) => exA.orderId!.compareTo(exB.orderId!));
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: exercises.length,
      itemBuilder: (context, index) => Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        key: ValueKey(exercises[index]),
        child: ExerciseItem(
          exercise: exercises[index],
          inMainList: true,
          onEdit: (bool edited) { if (edited) setState((){});},
          onDelete: (bool deleted) { if (deleted) setState((){});},
        ),
      ),
      onReorder: (int oldIndex, int newIndex) {
        if (oldIndex < newIndex) { newIndex -= 1; }
        final Exercise item = exercises.removeAt(oldIndex);
        exercises.insert(newIndex, item);
        exercises.forEach((e) => e.orderId = (exercises.indexOf(e) + 1));
        ExercisesService.updatedOrderIdExercises(exercises);
      },
    );
  }

  Widget _exercisesList(List<Exercise>? exercises, [bool isMain = false]) {
    bool _isEmpty = exercises == null || exercises.length == 0;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            isMain ? 'Ćwiczenia' : 'Pozostałe ćwiczenia',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21, color: kRed),
            textAlign: TextAlign.center
          ),
        ),
        Card(
          color: kYellow,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: exercises == null ? 100 : null,
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
            child: _isEmpty
                ? Center(child: Text('Brak ćwiczeń', style: TextStyle(color: kWhite, fontSize: 18, fontWeight: FontWeight.bold)))
                : isMain
                  ? _listReordered(exercises)
                  : _list(exercises)
          ),
        ),
        if(isMain && !_isEmpty)
          _timeWidget('Czas: ', exercises)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Exercise>>(
      future: getExercises(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Exercise> _mainExs = [];
          List<Exercise> _otherExs = [];

          snapshot.data!.forEach((element) {
            element.inMainList
              ? _mainExs.add(element)
              : _otherExs.add(element);
          });

          return RefreshIndicator(
              onRefresh: getExercises,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _exercisesList(_mainExs, true),
                    _exercisesList(_otherExs),
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
