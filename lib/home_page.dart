import 'package:flutter/material.dart';
import 'package:knee_acl_mcl/exercises/widgets/exercise_form_dialog.dart';
import 'package:knee_acl_mcl/exercises/exercises_page.dart';
import 'package:knee_acl_mcl/main/app_bar.dart';
import 'package:knee_acl_mcl/utils/utils.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: 'Ćwiczenia ACL'),
      body: ExercisesPage(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ExerciseFormDialog
            .show()
            .then((value) {if (value) setState(() {});});
        },
        child: Icon(Icons.add, color: kWhite),
      ),
    );
  }
}
