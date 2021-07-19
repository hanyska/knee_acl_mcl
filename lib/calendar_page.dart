import 'package:flutter/material.dart';
import 'package:knee_acl_mcl/main/app_bar.dart';

class CalendarPage extends StatefulWidget {
  static const routeName = '/progress';

  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: 'Progress'),
      body: Text('Progress'),
    );
  }
}
