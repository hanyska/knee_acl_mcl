import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static String? get userId => FirebaseAuth.instance.currentUser?.uid ?? null;

  static String getMessageFromErrorCode(String errorCode) {
    switch (errorCode) {
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return "Adres e-mail jest już używany! Przejdź do strony logowania.";
        
      case "weak-password":
        return "Podane hasło jest za słabe!";
        
      case "ERROR_WRONG_PASSWORD":
        return "Zły email lub hasło";
        
      case "ERROR_USER_DISABLED":
        return "Użytkownik jest zablokowany!";
        
      case "ERROR_TOO_MANY_REQUESTS":
      case "operation-not-allowed":
        return "Zbyt wiele żądań zalogowania się na to konto!";
        
      case "ERROR_OPERATION_NOT_ALLOWED":
      case "operation-not-allowed":
        return "Błąd serwera, spróbuj ponownie później!";
        
      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        return "Adres email jest nieprawidłowy!";
        
      case "wrong-password":
        return "Niepoprawny email lub hasło";
      default:
        return errorCode;
        // return "Logowanie nie powiodło się. Proszę spróbuj ponownie.";
        
    }
  }
}