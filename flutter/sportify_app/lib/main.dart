import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportify_app/screens/home_page_event.dart';
import 'screens/landing_page.dart';
import 'screens/event_creation_page.dart';
import 'screens/profile_creation.dart';
import 'screens/home_page.dart';

void main() {
  runApp(
    MaterialApp(
      home: HomePage(),
    ),
  );
}
