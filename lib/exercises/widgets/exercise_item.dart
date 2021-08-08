import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:knee_acl_mcl/components/progress_bar.dart';
import 'package:knee_acl_mcl/components/toast.dart';
import 'package:knee_acl_mcl/exercises/exercise_details_page.dart';
import 'package:knee_acl_mcl/exercises/widgets/exercise_form_dialog.dart';
import 'package:knee_acl_mcl/exercises/widgets/exercise_model.dart';
import 'package:knee_acl_mcl/models/progress.dart';
import 'package:knee_acl_mcl/providers/exercises_service.dart';
import 'package:knee_acl_mcl/providers/progress_service.dart';
import 'package:knee_acl_mcl/utils/utils.dart';

class ExerciseItem extends StatefulWidget {
  final Exercise exercise;
  final bool inMainList;
  final Function? onEdit;
  final Function? onDelete;

  const ExerciseItem({
    Key? key,
    required this.exercise,
    this.inMainList = false,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  _ExerciseItemState createState() => _ExerciseItemState();
}

class _ExerciseItemState extends State<ExerciseItem> {
  final SlidableController slidableController = SlidableController();
  final ProgressBar _progressBar = new ProgressBar();

  @override
  void dispose() {
    super.dispose();
  }

  void _goToExercise() {
    ProgressService.addIfNotExistProgress(Progress());

    ExerciseDetailsPage
      .show(widget.exercise)
      .then((isSuccess) {
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

  Widget get _suffixButton {
    return IconButton(
      visualDensity: VisualDensity.compact,
      splashRadius: 0.1,
      splashColor: kPrimaryColor,
      icon: Icon(widget.inMainList ? Icons.arrow_forward_ios : Icons.add, color: kPrimaryColor),
      onPressed: widget.inMainList ? _goToExercise : _addOrRemoveToMainList,
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
                      if(widget.inMainList) iconWithText(Icons.info, "${widget.exercise.orderId.toString()}"),
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
                _suffixButton
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onEditExercise() {
    ExerciseFormDialog
      .show(widget.exercise)
      .then((value) {
        if (widget.onEdit != null) widget.onEdit!(value);
      });
  }

  void onDeleteExercise() {
    _progressBar.show();

    ExercisesService
      .deleteExercise(widget.exercise.id!)
      .then((value) {
        _progressBar.hide();
        if (value) Toaster.show('Firebase usunal cwiczenie ${widget.exercise.title.toLowerCase()}');
        if (widget.onDelete != null) widget.onDelete!(value);
      });
  }

  void _addOrRemoveToMainList([bool addToMainList = true]) {
    Exercise _exercise = widget.exercise;
    _exercise.inMainList = addToMainList;

    ExercisesService
      .updatedExercise(_exercise)
      .then((value) {
        Toaster.show(addToMainList ? 'Dodano do listy głównej' : 'Usunięto z listy głównej');
        if (widget.onEdit != null) widget.onEdit!(value);
      });
  }

  Future<bool> deleteExerciseDialog() {
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
              style: TextButton.styleFrom(primary: kRed),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    ).then((value) => Future.value(value));
  }


  @override
  Widget build(BuildContext context) {
    return Slidable.builder(
      key: Key(widget.exercise.id.toString()),
      controller: SlidableController(),
      direction: Axis.horizontal,
      actionPane: SlidableStrechActionPane(),
      actionExtentRatio: 0.25,
      child: _mainExerciseItem,
      dismissal: SlidableDismissal(
        child: SlidableDrawerDismissal(),
        closeOnCanceled: true,
        onWillDismiss: (_) => widget.inMainList ? Future.value(true) :deleteExerciseDialog(),
        onDismissed: (actionType) => widget.inMainList ? _addOrRemoveToMainList(false) : onDeleteExercise(),
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
                  closeOnTap: true,
                ),
              ),
            );
          } else {
            return ClipRRect(
              borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
              child: IconSlideAction(
                caption: widget.inMainList ? 'Remove' : 'Delete',
                color: Colors.red.withOpacity(animation!.value),
                icon: widget.inMainList ? Icons.remove : Icons.delete,
                onTap: () {
                  widget.inMainList
                    ? _addOrRemoveToMainList(false)
                    : deleteExerciseDialog().then((bool isDelete) { if (isDelete) onDeleteExercise(); });
                },
              ),
            );
          }
        }),
    );
  }
}
