import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:knee_acl_mcl/exercises/exercises.dart';
import 'package:knee_acl_mcl/main/app_bar.dart';
import 'package:knee_acl_mcl/utils/utils.dart';

class ExerciseDetailsPage extends StatefulWidget {
  final Exercise exercise;

  const ExerciseDetailsPage({
    Key? key,
    required this.exercise,
  }) : super(key: key);

  @override
  _ExerciseDetailsPageState createState() => _ExerciseDetailsPageState();
}

class _ExerciseDetailsPageState extends State<ExerciseDetailsPage> {
  FlutterTts flutterTts = FlutterTts();
  AudioPlayer player = AudioPlayer();
  bool _startCounter = false;

  @override
  void initState() {
    _playSound();
    flutterTts.setCompletionHandler(() {
      setState(() {
        _startCounter = true;
      });
      _playStart();
    });

    super.initState();
  }
  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void _playStart() async {
    await player.setAsset('assets/audio/start.mp3');
    player.play();
  }

  void _playSound() async {
    await flutterTts.awaitSpeakCompletion(false);
    await flutterTts.speak(widget.exercise.title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: widget.exercise.title),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(widget.exercise.title, style: TextStyle(fontSize: 48, color: kPrimaryColor), textAlign: TextAlign.center),
            Text(widget.exercise.subtitle, style: TextStyle(fontSize: 24, color: kLightGrey), textAlign: TextAlign.center),
          ],
        ),
      )
    );
  }
}
