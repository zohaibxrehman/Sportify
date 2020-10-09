import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:io';
import 'package:sportify_app/screens/home_page.dart';

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
          child: GestureDetector(
            child: Container(
              height: 60,
              margin: EdgeInsets.symmetric(horizontal: 70, vertical: 30),
              alignment: Alignment.center,
              child: Text(
                'Log In',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.pink,
              ),
            ),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              ),
              _makeGetRequest()
            },
          ),
        ),
      ),
    );
  }

  _makeGetRequest() async {
    Response response = await get(_localhost());
    if (response.statusCode != 200)
      throw Exception('Failed to link with backend.');
    //  V  for when there is a response to be sent
    //else
    // setState(() {
    //   serverResponse = response.body;
    // });
  }

  String _localhost() {
    if (Platform.isAndroid)
      return 'http://10.0.2.2:3000/login';
    else // for iOS simulator
      return 'http://localhost:3000/login';
  }
}
