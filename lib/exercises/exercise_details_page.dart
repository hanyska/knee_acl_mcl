import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:knee_acl_mcl/components/exercise_timer.dart';
import 'package:knee_acl_mcl/exercises/exercises.dart';
import 'package:knee_acl_mcl/helpers/date_time_helper.dart';
import 'package:knee_acl_mcl/main/app_bar.dart';
import 'package:knee_acl_mcl/utils/utils.dart';
import 'package:wakelock/wakelock.dart';

class ExerciseDetailsPage extends StatefulWidget {
  final Exercise exercise;

  const ExerciseDetailsPage({
    Key? key,
    required this.exercise,
  }) : super(key: key);

  @override
  _ExerciseDetailsPageState createState() => _ExerciseDetailsPageState();
}

class _ExerciseDetailsPageState extends State<ExerciseDetailsPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  FlutterTts flutterTts = FlutterTts();
  AudioPlayer player = AudioPlayer();
  bool _startBigCounter = false;
  String timerText = '';
  int _repeat = 0;

  String get timerString {
    Duration duration = _controller.duration! * _controller.value;
    return _controller.isAnimating
      ? DateTimeHelper.timerText(duration)
      : '00:00';
  }

  @override
  void initState() {
    Wakelock.enable();
    _repeat = widget.exercise.repeat;
    _controller = AnimationController(vsync: this, duration: widget.exercise.time);
    _speakTitle();
    _start321Go();
    _repeatExercises();


    super.initState();
  }

  @override
  void dispose() {
    flutterTts.stop();
    player.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _start321Go() {
    flutterTts.setCompletionHandler(() {
      Timer.periodic(Duration(seconds: 1), (timer) {
        int _timer = 4 - timer.tick;
        switch(5 - timer.tick) {
          case 0:
            timer.cancel();
            _toggleCounter();
            break;
          case 1:
            if(mounted) setState(() => timerText = 'START');
            break;
          case 4:
            _play321Sound();
            setState(() => timerText = _timer.toString());
            break;
          default:
            setState(() => timerText = _timer.toString());
        }
      });
    });
  }

  void _repeatExercises() {
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        _repeat--;
        FlutterTts().speak('STOP');

        _repeat == 0
            ? Navigator.of(context).pop(true)
            : Future.delayed(widget.exercise.pauseTime, _toggleCounter);

      } else if (status == AnimationStatus.reverse) {
        FlutterTts().speak('START');
      }
    });
  }

  void _play321Sound() async {
    await player.setAsset('assets/audio/start.mp3');
    player.play();
  }

  void _speakTitle() async {
    await flutterTts.awaitSpeakCompletion(false);
    await flutterTts.speak(widget.exercise.title);
  }

  void _toggleCounter() async {
    _controller.isAnimating
      ? _controller.stop()
      : _controller.reverse(from: _controller.value == 0.0 ? 1.0 : _controller.value);

    setState(() => _startBigCounter = true);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: widget.exercise.title),
      body: AnimatedBuilder(animation: _controller, builder: (context, child) => Stack(
        children: <Widget>[
          Container(
            color: kYellow,
            height: MediaQuery.of(context).size.height * _controller.value,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                children: [
                  Text(
                    widget.exercise.title,
                    style: TextStyle(fontSize: 48, color: kPrimaryColor),
                    textAlign: TextAlign.center
                  ),
                  Text(
                    widget.exercise.subtitle,
                    style: TextStyle(fontSize: 24, color: kLightGrey),
                    textAlign: TextAlign.center
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: ExerciseTimer(
                  controller: _controller,
                  text: _startBigCounter ? timerString : timerText
                ),
              )
            ],
          ),
        ],
      ))
    );
  }
}
