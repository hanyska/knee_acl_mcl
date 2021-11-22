import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:knee_acl_mcl/helpers/navigation_service.dart';
import 'package:knee_acl_mcl/utils/utils.dart';

class ProgressBar {
  BuildContext _context = NavigationService.navigatorKey.currentContext!;

  void hide() {
    Navigator.of(_context).pop();
  }

  void show() {
    showDialog(
      context: _context,
      barrierDismissible: false,
      builder: (BuildContext context) => _progressBar
    );
  }
}

Widget get _progressBar {
  return Center(
      child: MyIconSpinner()
  );
}

class MyIconSpinner extends StatefulWidget {
  @override
  _MyIconSpinnerState createState() => _MyIconSpinnerState();
}

class _MyIconSpinnerState extends State<MyIconSpinner> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 700),
        vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);

    _controller.addListener(() {
      if (_controller.isCompleted) {
        _controller.repeat(reverse: true);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();

    return ScaleTransition(
      scale: Tween(begin: 0.5, end: 1.0).animate(_animation),
      child: Icon(
        Icons.favorite_border_outlined,
        size: MediaQuery.of(context).size.width * 0.5,
        color: kPrimaryColor
      ),
    );
  }
}