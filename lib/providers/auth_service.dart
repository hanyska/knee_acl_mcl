import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:knee_acl_mcl/components/toast.dart';
import 'package:knee_acl_mcl/models/user_model.dart';
import 'package:knee_acl_mcl/providers/firebase_service.dart';
import 'package:knee_acl_mcl/providers/user_service.dart';

class AuthService {
  static Future<dynamic> register(String email, String password) async {
    fb.UserCredential? userCredential;

    try {
      userCredential = await fb.FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on fb.FirebaseAuthException catch (error) {
      String errorMessage = FirebaseService.getMessageFromErrorCode(error.code);
      Toaster.show(errorMessage, toasterType: ToasterType.DANGER, isLongLength: true);
      return errorMessage;
    }

    if (userCredential.user == null) return false;

    User _user = new User(
      id: userCredential.user!.uid,
      email: userCredential.user!.email!,
    );
    return UserService
      .addUserDetails(_user)
      .then((value) {
        if (!value) return false;
        fb.FirebaseAuth.instance.signOut();
        Toaster.show('Pomyślnie założono konto. Możesz się teraz zalogować', toasterType: ToasterType.SUCCESS, isLongLength: true);
        return true;
      });
  }

  static Future<dynamic> login(String email, String password) async {
    fb.UserCredential? userCredential;
    try {
      userCredential = await fb.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on fb.FirebaseAuthException catch (error) {
      String errorMessage = FirebaseService.getMessageFromErrorCode(error.code);
      Toaster.show(errorMessage, toasterType: ToasterType.DANGER, isLongLength: true);
      return errorMessage;
    }

    return userCredential.user != null;
  }
}
