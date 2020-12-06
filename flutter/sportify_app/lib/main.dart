import 'package:flutter/material.dart';
import 'screens/landing_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      home: LandingPage(),
    ),
  );
}
