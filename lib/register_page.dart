import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:knee_acl_mcl/components/progress_bar.dart';
import 'package:knee_acl_mcl/components/rounded_button.dart';
import 'package:knee_acl_mcl/components/rounded_input.dart';
import 'package:knee_acl_mcl/components/toast.dart';
import 'package:knee_acl_mcl/login_page.dart';
import 'package:knee_acl_mcl/main/app_bar.dart';
import 'package:knee_acl_mcl/providers/firebase_service.dart';
import 'package:knee_acl_mcl/utils/utils.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _confirmPasswordController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _passwordError;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _passwordError = 'Hasła muszą być takie same!');
      return;
    } else {
      setState(() => _passwordError = null);
    }
    if (!_formKey.currentState!.validate()) return;

    ProgressBar().show();
    UserCredential? userCredential;

    try {
      userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (error) {
      String errorMessage = FirebaseService.getMessageFromErrorCode(error.code);
      _passwordController.clear();
      _confirmPasswordController.clear();
      Toaster.show(errorMessage, toasterType: ToasterType.DANGER, isLongLength: true);
    }

    if (userCredential?.user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
      Toaster.show('Pomyślnie założono konto. Możesz się teraz zalogować', toasterType: ToasterType.SUCCESS, isLongLength: true);
    }
    ProgressBar().hide();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: myAppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 40),
                child: Text(
                  'Zarejestruj się',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    RoundedInput(
                      controller: _emailController,
                      icon: Icon(Icons.email, color: kPrimaryColor),
                      inputType: InputType.EMAIL,
                      hintText: 'Twój email',
                    ),
                    RoundedInput(
                      controller: _passwordController,
                      icon: Icon(Icons.lock, color: kPrimaryColor),
                      hintText: 'Hasło',
                      inputType: InputType.PASSWORD,
                    ),
                    RoundedInput(
                      controller: _confirmPasswordController,
                      icon: Icon(Icons.lock, color: kPrimaryColor),
                      hintText: 'Powtórz hasło',
                      inputType: InputType.PASSWORD,
                    ),
                  ]
                )
              ),
              if (_passwordError != null)
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 30.0, bottom: 10, top: 15),
                  child: Text(
                    _passwordError!,
                    style: TextStyle(color: kPrimaryColor),
                  ),
                ),
              RoundedButton(
                text: "Zarejestruj się".toUpperCase(),
                onClicked: _register
              ),
              SizedBox(height: size.height * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Masz już konto?'),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    ),
                    child: Text(
                      'Zaloguj się',
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
