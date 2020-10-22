import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'screens/landing_page.dart';
import 'screens/event_creation_page.dart';

void main() {
  runApp(
    MaterialApp(
      home: EventCreation(),
    ),
  );
}
