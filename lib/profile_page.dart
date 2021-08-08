import 'package:flutter/material.dart';
import 'package:knee_acl_mcl/main/app_bar.dart';
import 'package:knee_acl_mcl/models/user_model.dart';
import 'package:knee_acl_mcl/providers/user_service.dart';
import 'package:knee_acl_mcl/utils/utils.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = '/profile';

  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<User?> getUser() async {
    return UserService.getUser();
  }

  void logout() {
    UserService.logout();
  }

  Widget _profileItem(IconData mainIcon, String text, Function onClick) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Card(
        color: Colors.grey.shade50,
        child: ListTile(
          onTap: () => onClick(),
          leading: Icon(mainIcon, color: kPrimaryColor),
          trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey.shade600),
          title: Text(text, style: TextStyle(color: Colors.grey.shade700)),
        ),
      ),
    );
  }

  Widget _photoWidget(User? user) {
    return ElevatedButton(
      onPressed: () => print('Change avatar!'),
      style: ElevatedButton.styleFrom(shape: CircleBorder()),
      child: Stack(
        children: [
          CircleAvatar(
            maxRadius: 75.0,
            backgroundColor: Colors.grey.shade50,
            child: user == null || user.imageUrl == null
                ? Icon(Icons.person, size: 100, color: Theme.of(context).primaryColor)
                : Image.network(user.imageUrl!),
          ),
          Positioned(
              bottom: 10,
              right: 10,
              child: CircleAvatar(
                maxRadius: 15.0,
                backgroundColor: Colors.grey.shade200,
                child: Icon(Icons.photo_camera, color: Colors.grey.shade700, size: 18)
              )
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: myAppBar(title: 'Profile'),
        body: FutureBuilder<User?>(
          future: getUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              User? _user = snapshot.data;

              return RefreshIndicator(
                  onRefresh: getUser,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        _photoWidget(_user),
                        SizedBox(height: 20),
                        _profileItem(Icons.person, 'Mój profil', () => print('Mój profil')),
                        _profileItem(Icons.notifications, 'Powiadomienia', () => print('Powiadomienia')),
                        _profileItem(Icons.settings, 'Ustawienia', () => print('Ustawienia')),
                        _profileItem(Icons.language, 'Język', () => print('Język')),
                        _profileItem(Icons.logout, 'Logout', UserService.logout),
                      ],
                    ),
                  ));
            } else {
              return Center(child: CircularProgressIndicator(strokeWidth: 1.5));
            }
          },
        )
    );
  }
}
