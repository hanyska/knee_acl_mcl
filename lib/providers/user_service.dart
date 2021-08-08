import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:knee_acl_mcl/helpers/navigation_service.dart';
import 'package:knee_acl_mcl/login_page.dart';
import 'package:knee_acl_mcl/models/user_model.dart';
import 'package:knee_acl_mcl/providers/firebase_service.dart';

class UserService {
  static CollectionReference _mainCollection =  FirebaseFirestore.instance.collection('users');
  static CollectionReference _userCollection = _mainCollection.doc(FirebaseService.userId).collection('data');
  static User? _user;

  static User? get user => _user;

  static Future<bool> addUserDetails(User user) {
    return _userCollection
      .add(user.toJson())
      .then((_) => true)
      .catchError((_) => false);
  }

  static Future<User?> getUser() {
    return _userCollection
      .get()
      .then((QuerySnapshot querySnapshot) {
        dynamic json = querySnapshot.docs[0];
        if (json == null) return null;

        _user = User.fromJson(json.id, json.data());
        return _user!;
    }).catchError((_) => null);
  }

  static Future<void> logout() async {
    BuildContext _context = NavigationService.navigatorKey.currentContext!;

    await fb.FirebaseAuth.instance
      .signOut()
      .then((value) {
        Navigator.of(_context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false
        );
    });
  }

}
