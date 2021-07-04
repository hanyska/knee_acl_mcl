import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:knee_acl_mcl/components/progress_bar.dart';
import 'package:knee_acl_mcl/components/rounded_button.dart';
import 'package:knee_acl_mcl/components/rounded_input.dart';
import 'package:knee_acl_mcl/home_page.dart';
import 'package:knee_acl_mcl/providers/firebase_service.dart';
import 'package:knee_acl_mcl/register_page.dart';
import 'package:knee_acl_mcl/utils/utils.dart';

import 'components/toast.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  String passwordError = "";
  final _formKey = GlobalKey<FormState>();

  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    ProgressBar().show();
    UserCredential? userCredential;
    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (error) {
      String errorMessage = FirebaseService.getMessageFromErrorCode(error.code);
      _passwordController.clear();
      setState(() => passwordError = errorMessage);
      Toaster.show(errorMessage, toasterType: ToasterType.DANGER, isLongLength: true);
    }
    ProgressBar().hide();
    if (userCredential?.user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }


  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 20.0),
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Zaloguj się',
                  style: Theme.of(context).textTheme.headline1,
                ),
                SvgPicture.asset(
                  "assets/images/login.svg",
                  height: size.height * 0.4,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        RoundedInput(
                          controller: _emailController,
                          icon: Icon(Icons.email, color: kPrimaryColor),
                          inputType: InputType.EMAIL,
                          hintText: 'Email',
                        ),
                        RoundedInput(
                          controller: _passwordController,
                          icon: Icon(Icons.lock, color: kPrimaryColor),
                          hintText: 'Hasło',
                          inputType: InputType.PASSWORD,
                        ),
                      ],
                    )
                ),
                if (passwordError.isNotEmpty)
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 30.0, bottom: 10, top: 15),
                    child: Text(
                      passwordError,
                      style: TextStyle(color: kPrimaryColor),
                    ),
                  ),
                RoundedButton(
                    text: "Zaloguj się".toUpperCase(),
                    onClicked: _login
                ),
                SizedBox(height: size.height * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Nie masz konta?'),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      ),
                      child: Text(
                        'Zarejestruj się',
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
    );
  }
}
