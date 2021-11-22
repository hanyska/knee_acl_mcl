import 'package:flutter/material.dart';
import 'package:knee_acl_mcl/components/custom_timer_painter.dart';
import 'package:knee_acl_mcl/utils/utils.dart';

class ExerciseTimer extends StatefulWidget {
  final AnimationController controller;
  final String text;

  ExerciseTimer({
    required this.controller,
    required this.text,
  });

  @override
  _ExerciseTimerState createState() => _ExerciseTimerState();
}

class _ExerciseTimerState extends State<ExerciseTimer> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: CustomPaint(
              painter: CustomTimerPainter(
                animation: widget.controller,
                backgroundColor: kGrey,
                color: kPrimaryColor,
              )
            ),
          ),
          Center(
            child: Text(
              widget.text,
              style: TextStyle(fontSize: 96.0, color: kGrey),
            ),
          ),
        ],
      ),
    );
  }
}