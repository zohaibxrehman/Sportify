import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'transition_button.dart';
import 'package:sportify_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';

// This file deals with the login of a an existing user. This file is similar to
// the registration screen, except it will redirect directly to the home screen
// once the user is authorized with the correct email and password

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  String uid;

  // This allows the App to know which user is logged in
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
                    email = value;
                    //Do something with the user input.
                  },
                  decoration:
                      kTextField.copyWith(hintText: 'Enter your email')),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                style: TextStyle(color: Colors.black),
                onChanged: (value) {
                  password = value;
                  //Do something with the user input.
                },
                decoration:
                    kTextField.copyWith(hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              TransitionBlock(
                color: Colors.lightBlueAccent,
                title: 'Log In',
                onPressed: () async {
                  try {
                    final user = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);

                    uid = user.user.uid;

                    saveValue();

                    if (user != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    }
                  } catch (e) {
                    _showToast(context, e);
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
