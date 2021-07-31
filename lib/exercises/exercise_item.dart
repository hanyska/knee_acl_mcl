import 'package:flutter/material.dart';
import 'package:knee_acl_mcl/components/toast.dart';
import 'package:knee_acl_mcl/exercises/exercise_details_page.dart';
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: kVeryLightGrey,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  color: kPrimaryColor,
                  width: 65,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      iconWithText(Icons.timer, "${widget.exercise.time.inSeconds}s"),
                      iconWithText(Icons.repeat, "${widget.exercise.repeat.toString()}"),
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
}
