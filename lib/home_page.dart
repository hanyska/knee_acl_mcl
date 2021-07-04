import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:knee_acl_mcl/main/app_bar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  User? user;

  @override
  void initState() {
    getCurrentUser();

    super.initState();
  }

  void getCurrentUser() {
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        title: 'Ćwiczenia ACL',
      ),
      // drawer: myDrawer,
      body: SafeArea(
        child: Container(
          child: Text('Cześć ${user!.email}'),
        ),
      ),
    );
  }
}
