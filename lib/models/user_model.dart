import 'package:knee_acl_mcl/providers/firebase_service.dart';

class User {
  final String id;
  final String email;
  final String? username;
  final String? imageUrl;
  final bool showNotifications;
  final String langCode;

  User({
    required this.id,
    required this.email,
    this.username,
    this.imageUrl,
    this.showNotifications = true,
    this.langCode = 'pl'
  });

  Map<String, dynamic> toJson() => {
    'id': FirebaseService.userId,
    'email': email,
    'username': username,
    'imageUrl': imageUrl,
    'showNotifications': showNotifications,
    'langCode': langCode,
  };

  factory User.fromJson(String id, Map<String, dynamic> json) => User(
    id: id,
    email: json['email'],
    username: json['username'],
    imageUrl: json['imageUrl'],
    showNotifications: json['showNotifications'],
    langCode: json['langCode'],
  );
}
