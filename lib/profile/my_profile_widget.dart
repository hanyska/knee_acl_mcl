import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:knee_acl_mcl/components/rounded_button.dart';
import 'package:knee_acl_mcl/components/rounded_input.dart';
import 'package:knee_acl_mcl/main/app_bar.dart';
import 'package:knee_acl_mcl/models/user_model.dart';

class MyProfileWidget extends StatefulWidget {
  static const routeName = "/my-profile";

  final User user;

  MyProfileWidget({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<MyProfileWidget> createState() => _MyProfileWidgetState();
}

class _MyProfileWidgetState extends State<MyProfileWidget> {
  TextEditingController _userNameController = new TextEditingController();
  TextEditingController _operationDateController = new TextEditingController();


  @override
  void initState() {
    _userNameController.text = widget.user.username ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: 'My profile'),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Nick"),
            RoundedInput(
              controller: _userNameController,
              inputType: InputType.TEXT,
              hintText: tr('textField.username'),
            ),
            SizedBox(height: 25),
            Text('Data operacji'),
            RoundedInput(
              controller: _operationDateController,
              inputType: InputType.DATE,
              hintText: "Data operacji",
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        SizedBox(
          width: double.infinity,
          child: RoundedButton(text: 'Zapisz', onClicked: () => print('Save'))
        )
      ],
    );
  }
}
