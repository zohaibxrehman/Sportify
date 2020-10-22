import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileCreation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfileCreationState();
  }
}

class ProfileCreationState extends State<ProfileCreation> {
  String _firstName;
  String _lastName;
  String _dateOfBirth;
  String _sportsInterests;
  String _favTeam;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildFirstName() {
    return TextFormField(
        decoration: InputDecoration(
            hintText: 'First Name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Name is Required';
          }
          return null;
        },
        onSaved: (String value) {
          _firstName = value;
        });
  }

  Widget _buildLastName() {
    return TextFormField(
        decoration: InputDecoration(
            hintText: 'Last Name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Name is Required';
          }
          return null;
        },
        onSaved: (String value) {
          _lastName = value;
        });
  }

  Widget _buildDOB() {
    return null;
  }

  Widget _buildSportsInterests() {
    return TextFormField(
        decoration: InputDecoration(
            hintText: 'Sports You Play',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Enter Sports';
          }
          return null;
        },
        onSaved: (String value) {
          _sportsInterests = value;
        });
  }

  Widget _buildFavTeam() {
    return TextFormField(
        decoration: InputDecoration(
            hintText: 'Favorite Team',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Enter a Valid Name';
          }
          return null;
        },
        onSaved: (String value) {
          _favTeam = value;
        });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Profile",
            style: TextStyle(
              fontSize: 32,
              color: Colors.black,
            )),
        backgroundColor: Colors.white,
        elevation: 0,
        brightness: Brightness.light,
      ),
      body: Container(
          child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildFirstName(),
                      SizedBox(height: 20),
                      _buildLastName(),
                      SizedBox(height: 20),
                      _buildSportsInterests(),
                      SizedBox(height: 20),
                      _buildFavTeam(),
                      // _buildDOB(),
                      SizedBox(
                        height: 200,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: RaisedButton(
                            child: Text(
                              'Edit Profile',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            color: Colors.blueAccent,
                            onPressed: () {
                              if (!_formKey.currentState.validate()) {
                                return;
                              }
                              _formKey.currentState.save();
                            }),
                      )
                    ],
                  )))),
    );
  }
}
