import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:knee_acl_mcl/components/progress_bar.dart';
import 'package:knee_acl_mcl/components/rounded_input.dart';
import 'package:knee_acl_mcl/components/rounded_wrapper.dart';
import 'package:knee_acl_mcl/components/toast.dart';
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
  final ProgressBar _progressBar = new ProgressBar();
  User? _user;



  Future<User?> getUser() async {
    return UserService.getUser();
  }

  void logout() {
    UserService.logout();
  }

  void _pickImage(ImageSource source) async {
    final XFile? image = await ImagePicker().pickImage(source: source);

    if (image == null) return;

    _progressBar.show();
    UserService
      .addUpdateAvatar(_user!.id, File(image.path))
      .then((value) {
        if (value) setState(() {});
        _progressBar.hide();
      });
  }

  void _onUpdateAvatar() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      builder: (BuildContext context) {
       return Column(
         mainAxisSize: MainAxisSize.min,
         children: [
           _profileItem(Icons.photo_camera, tr('profile.takePhoto'), () => _pickImage(ImageSource.camera)),
           _profileItem(Icons.photo, tr('profile.chooseFromGallery'), () => _pickImage(ImageSource.gallery)),
         ],
       );
    });
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

  void _showMyProfileWidget() {
    TextEditingController _userNameController = new TextEditingController();
    _userNameController.text = _user!.username ?? '';

    showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: MediaQuery.of(context).viewInsets,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RoundedInput(
              controller: _userNameController,
              inputType: InputType.TEXT,
              hintText: tr('textField.username'),
            ),
            SizedBox(width: 5),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(29),
                child: ElevatedButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: Text(tr('button.send'), style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    _progressBar.show();

                    User user = _user!;
                    user.username = _userNameController.text;
                    UserService
                      .updateUser(user)
                      .then((value) {
                        Toaster.show(tr('profile.updatedUser'));
                        _progressBar.hide();
                        Navigator.of(context).pop();
                      })
                      .catchError((_) { _progressBar.hide(); });
                  },
                ),
              ),
            )
          ],
        ),
      )
    );
  }

  void _showLanguageWidget() {
    String lang = _user!.langCode;
    List<String> _langList = context.supportedLocales.map((e) => e.languageCode.toLowerCase()).toList();

    showModalBottomSheet(
        useRootNavigator: true,
        context: context,
        isScrollControlled: true,
        builder: (context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) => Container(
            padding: MediaQuery.of(context).viewInsets,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RoundedWrapper(
                  child: DropdownButton<String>(
                    value: lang,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 42,
                    underline: SizedBox(),
                    onChanged: (String? newValue) => setState(() => lang = newValue!),
                    items: _langList.map((String value) => DropdownMenuItem(
                      value: value,
                      child: Text(tr('language.$value'))
                    )).toList(),
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(29),
                    child: ElevatedButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      child: Text(tr('button.send'), style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        _progressBar.show();

                        User user = _user!;
                        user.langCode = lang;
                        UserService
                          .updateUser(user)
                          .then((value) async {
                            await context.setLocale(Locale(lang));
                            await Future.delayed(Duration(seconds: 1));
                            Toaster.show(tr('profile.updatedUser'));
                            _progressBar.hide();
                            Navigator.of(context).pop();
                          })
                          .catchError((_) { _progressBar.hide(); });
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }

  Widget get _photoWidget {
    return ElevatedButton(
      onPressed: _onUpdateAvatar,
      style: ElevatedButton.styleFrom(shape: CircleBorder()),
      child: Stack(
        children: [
          CircleAvatar(
            radius: 75.0,
            backgroundColor: Colors.grey.shade50,
            backgroundImage: NetworkImage(
                _user == null || _user!.imageUrl == null
                  ? 'https://palmbayprep.org/wp-content/uploads/2015/09/user-icon-placeholder.png'
                  : _user!.imageUrl!
            ),
          ),
          Positioned(
              bottom: 10,
              right: 10,
              child: CircleAvatar(
                radius: 15.0,
                backgroundColor: Colors.grey.shade200,
                child: Icon(Icons.photo_camera, color: Color(0xff929190), size: 18)
              )
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: myAppBar(title: tr('profile.myProfile')),
        body: FutureBuilder<User?>(
          future: getUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _user = snapshot.data;

              return RefreshIndicator(
                  onRefresh: getUser,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        _photoWidget,
                        SizedBox(height: 20),
                        _profileItem(Icons.person, tr('profile.myProfile'), _showMyProfileWidget),
                        // _profileItem(Icons.notifications, 'Powiadomienia', () => print('Powiadomienia')),
                        _profileItem(Icons.settings, tr('profile.settings'), () => print('Ustawienia')),
                        _profileItem(Icons.language, tr('profile.language'), _showLanguageWidget),
                        _profileItem(Icons.logout, tr('profile.logout'), UserService.logout),
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
