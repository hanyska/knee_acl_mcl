import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:knee_acl_mcl/exercises/exercise_details_page.dart';
import 'package:knee_acl_mcl/exercises/exercises.dart';
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
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
  }

  void _goToExercise() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ExerciseDetailsPage(exercise: widget.exercise)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
              leading: SizedBox(
                width: MediaQuery.of(context).size.width / 7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        widget.exercise.count.toString(),
                        style: TextStyle(color: kPrimaryColor, fontSize: 28)
                    ),
                    Text(
                      widget.exercise.type == ExerciseType.SECONDS
                        ? 'sekund'
                        : 'powtórzeń',
                      style: TextStyle(color: kLightGrey, fontSize: 11)
                    )
                  ],
                ),
              ),
              title: Text(widget.exercise.title),
              subtitle: Text(widget.exercise.subtitle),
              trailing: IconButton(
                icon: Icon(Icons.play_arrow),
                onPressed: () => _goToExercise(),
              )
          ),
        ],
      ),
    );
  }
}
