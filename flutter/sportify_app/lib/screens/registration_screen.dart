import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'transition_button.dart';
import 'package:sportify_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_creation.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  String uid;

  saveValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('uid', uid);
  }

  void _showToast(BuildContext context, e) {
    final scaffold = Scaffold.of(context);
    var index = e.toString().indexOf(']');
    scaffold.showSnackBar(SnackBar(
      content: new Text(e.toString().substring(index + 1)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(
        builder: (context) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/sportify_logo.jpeg'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.black),
                onChanged: (value) {
                  //Do something with the user input.
                  email = value;
                },
                decoration: kTextField.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                style: TextStyle(color: Colors.black),
                onChanged: (value) {
                  //Do something with the user input.
                  password = value;
                },
                decoration:
                    kTextField.copyWith(hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              TransitionBlock(
                color: Colors.blueAccent,
                title: 'Register',
                onPressed: () async {
                  if (email.endsWith("utoronto.ca")) {
                    try {
                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                              email: email, password: password);

                      // print(newUser.additionalUserInfo);
                      uid = newUser.user.uid;

                      saveValue();

                      if (newUser != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileCreation()),
                        );
                      }
                    } catch (e) {
                      _showToast(context, e);
                    }
                  } else {
                    _showToast(context,
                        "]The email is not a valid University of Toronto email address");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
