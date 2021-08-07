import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:knee_acl_mcl/components/toast.dart';
import 'package:knee_acl_mcl/exercises/exercise_details_page.dart';
import 'package:knee_acl_mcl/exercises/exercises.dart';
import 'package:knee_acl_mcl/providers/exercises_service.dart';
import 'package:knee_acl_mcl/exercises/exercise.dart';
import 'package:knee_acl_mcl/models/progress.dart';
import 'package:knee_acl_mcl/providers/progress_service.dart';
import 'package:knee_acl_mcl/utils/utils.dart';

class ExerciseItem extends StatefulWidget {
  final Exercise exercise;

  const ExerciseItem({
    Key? key,
    required this.exercise,
  }) : super(key: key);

  @override
  _ExerciseItemState createState() => _ExerciseItemState();
}

class _ExerciseItemState extends State<ExerciseItem> {
  final SlidableController slidableController = SlidableController();

  void _goToExercise() {
    ProgressService.addIfNotExistProgress(Progress());

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ExerciseDetailsPage(exercise: widget.exercise)),
    ).then((isSuccess) {
      if (isSuccess is bool && isSuccess == true) {
        ProgressService.updateProgress(Progress(
          doneIdExercises: [widget.exercise.id]
        ));
        Toaster.show('SUPEERR!!');
      }
    });
  }

  Widget iconWithText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: kWhite, size: 18),
        Text(
          text,
          style: TextStyle(color: kWhite, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ]
    );
  }

  Widget get _mainExerciseItem {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          color: kVeryLightGrey,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  color: kPrimaryColor,
                  width: 65,
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      iconWithText(Icons.timer, "${widget.exercise.time.inSeconds}s"),
                      iconWithText(Icons.repeat, "${widget.exercise.repeat.toString()}"),
                      iconWithText(Icons.info, "${widget.exercise.orderId.toString()}"),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(widget.exercise.title, style: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(widget.exercise.subtitle, style: TextStyle(color: kLightGrey))
                      ],
                    ),
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  splashRadius: 0.1,
                  splashColor: kPrimaryColor,
                  icon: Icon(Icons.arrow_forward_ios, color: kPrimaryColor),
                  onPressed: _goToExercise,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onEditExercise() {
    TextEditingController _titleController = TextEditingController();
    TextEditingController _subtitleController = TextEditingController();
    TextEditingController _repeatController = TextEditingController();
    TextEditingController _timeController = TextEditingController();
    TextEditingController _pauseTimeController = TextEditingController();

    _titleController.text = widget.exercise.title;
    _subtitleController.text = widget.exercise.subtitle;
    _repeatController.text = widget.exercise.repeat.toString();
    _timeController.text = widget.exercise.time.inSeconds.toString();
    _pauseTimeController.text = widget.exercise.pauseTime.inSeconds.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(widget.exercise.title),
          content: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Nazwa'),
              ),
              TextField(
                controller: _subtitleController,
                decoration: InputDecoration(labelText: 'Opis'),
              ),
              TextField(
                controller: _repeatController,
                decoration: InputDecoration(labelText: 'Ilość powtórek'),
              ),
              TextField(
                controller: _timeController,
                decoration: InputDecoration(labelText: 'Czas jednego powtórzenia'),
              ),
              TextField(
                controller: _pauseTimeController,
                decoration: InputDecoration(labelText: 'Przerwa między ćwiczeniami'),

              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Anuluj'),
              style: TextButton.styleFrom(primary: kBlack),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Zapisz'),
              style: TextButton.styleFrom(primary: kPrimaryColor,),
              onPressed: () {
                ExercisesService.updatedExercise(Exercise(
                  id: widget.exercise.id,
                  title: _titleController.text,
                  subtitle: _subtitleController.text,
                  repeat: int.parse(_repeatController.text),
                  time: Duration(seconds: int.parse(_timeController.text)),
                )).then((value) {
                  print(value);
                  Navigator.of(context).pop(true);
                });
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> onDeleteExercise() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(widget.exercise.title),
          content: Text('Czy na pewno chcesz usunąć to ćwiczenie?'),
          actions: <Widget>[
            TextButton(
              child: Text('Anuluj'),
              style: TextButton.styleFrom(primary: kBlack),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Ok'),
              style: TextButton.styleFrom(primary: kRed,),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    ).then((value) => Future.value(value));
  }

  void deleteExercise() {
    Toaster.show('Firebase usunal cwiczenie ${widget.exercise.title.toLowerCase()}');
  }

  @override
  Widget build(BuildContext context) {
    return Slidable.builder(
      key: Key(widget.exercise.id.toString()),
      controller: slidableController,
      direction: Axis.horizontal,
      actionPane: SlidableStrechActionPane(),
      actionExtentRatio: 0.25,
      child: _mainExerciseItem,
      dismissal: SlidableDismissal(
        child: SlidableDrawerDismissal(),
        closeOnCanceled: true,
        onWillDismiss: (_) => onDeleteExercise(),
        onDismissed: (actionType) => deleteExercise(),
      ),
      secondaryActionDelegate: SlideActionBuilderDelegate(
        actionCount: 2,
        builder: (context, index, animation, renderingMode) {
          if (index == 0) {
            return Container(
              margin: EdgeInsets.only(left: 5.0),
              child: ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
                child: IconSlideAction(
                  caption: 'More',
                  color: Colors.grey.shade200.withOpacity(animation!.value),
                  icon: Icons.more_horiz,
                  onTap: onEditExercise,
                  closeOnTap: false,
                ),
              ),
            );
          } else {
            return ClipRRect(
              borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
              child: IconSlideAction(
                caption: 'Delete',
                color: Colors.red.withOpacity(animation!.value),
                icon: Icons.delete,
                onTap: () {
                  onDeleteExercise().then((bool isDelete) {
                    if (isDelete) deleteExercise();
                  });
                },
              ),
            );
          }
        }),
    );
  }
}
