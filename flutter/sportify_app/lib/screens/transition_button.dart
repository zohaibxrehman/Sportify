import 'package:flutter/material.dart';

// This is a screen that allows the login and registration to share this class
// that they both use. Both of those screens require this button, so this allows
// for less overall code

class TransitionBlock extends StatelessWidget {
  final Color color;
  final String title;
  final Function onPressed;

  TransitionBlock({this.color, this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            title,
          ),
        ),
      ),
    );
  }
}
