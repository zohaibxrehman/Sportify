import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'profile_creation.dart';

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final auth = FirebaseAuth.instance;
  User user;
  Timer timer;

  @override
  void initState() {
    user = auth.currentUser;
    user.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFf1f1f1),
        body: Container(
          decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(15.0),
              color: Colors.white),
          margin: EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: AssetImage('images/shield.png')),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25,vertical: 5),
                child: Center(
                  child: Text(
                      'An email has been sent to ${user.email}.', style: TextStyle(fontSize: 14,  color: Colors.blue,),textAlign: TextAlign.center,),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                child: Center(
                  child: Text(
                    'Please verify your email to proceed with profile creation.', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.blueGrey,),textAlign: TextAlign.center,),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser;
    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ProfileCreation()));
    }
  }
}
