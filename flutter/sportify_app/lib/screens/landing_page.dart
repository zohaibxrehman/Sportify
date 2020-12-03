import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:sportify_app/screens/login_screen.dart';
import 'package:sportify_app/screens/registration_screen.dart';

class LandingPage extends StatefulWidget {
  @override
  LandingPageState createState() {
    return new LandingPageState();
  }
}

class LandingPageState extends State<LandingPage> {
  String serverResponse = 'Server response';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/sportify_logo.jpeg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            children: [
              Container(
                height: 60,
                margin: EdgeInsets.symmetric(horizontal: 70, vertical: 30),
                // alignment: Alignment.centerRight,
                child: FlatButton(
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.deepOrangeAccent,
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    ),
                    _makeGetRequest()
                  },
                ),
              ),
              Container(
                height: 60,
                // alignment: Alignment.bottomCenter,
                child: FlatButton(
                  child: Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.deepOrangeAccent,
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrationScreen()),
                    ),
                    _makeGetRequest()
                  },
                ),
              )
            ],
          )),
    ));
  }

  _makeGetRequest() async {
    final Dio dio = new Dio();
    try {
      var response = await dio.get(_localhost());
      print(response);
      if (response.statusCode != 200)
        throw Exception('Failed to link with backend');
    } on DioError catch (e) {
      print(e);
    }
  }

  String _localhost() {
    if (Platform.isAndroid)
      return 'http://10.0.2.2:3000/login';
    else // for iOS simulator
      return 'http://localhost:3000/login';
  }
}
