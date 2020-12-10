import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:sportify_app/screens/home_page.dart';
import 'package:uuid/uuid.dart';

const Sports = {
  "one": "Cricket",
  "Cricket": "one",
  "two": "BasketBall",
  "BasketBall": "two",
  "three": "Hockey",
  "Hockey": "three",
  "four": "Football",
  "Football": "four",
  "five": "Badminton",
  "Badminton": "five",
  "six": "Tennis",
  "Tennis": "six",
  "seven": "Soccer",
  "Soccer": "seven",
  "eight": "Volleyball",
  "Volleyball": "eight",
  "nine": "Baseball",
  "Baseball": "nine",
  "ten": "Bowling",
  "Bowling": "ten",
  "eleven": "Table Tennis",
  "Table Tennis": "eleven",
  "twelve": "Golf",
  "Golf": "twelve",
  "thirteen": "Field Hockey",
  "Field Hockey": "thirteen",
  "fourteen": "Softball",
  "Softball": "fourteen",
  "fifteen": "Skate Boarding",
  "Skate Boarding": "fifteen",
  "sixteen": "Rowing",
  "Rowing": "sixteen",
};

var dates;

class EventCreation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EventCreationState();
  }
}

class BasicDateField extends StatelessWidget {
  final format = DateFormat("yyyy-MM-dd");
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      DateTimeField(
        decoration: InputDecoration(
          hintText: 'Date',
          suffixIcon: Icon(
            Icons.date_range,
            size: 30,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        format: format,
        onShowPicker: (context, currentValue) async {
          DateTime newSelectedDate = await showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
          if (newSelectedDate != null) {
            dates = newSelectedDate;
          }
          return dates;
        },
      ),
    ]);
  }
}

class EventCreationState extends State<EventCreation> {
  String _title;
  String _sport;
  String _location;
  String _description;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildTitle() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Title',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is required';
        }
        return null;
      },
      onSaved: (String value) {
        _title = value;
      },
    );
  }

  Widget _buildSport() {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(style: BorderStyle.solid, width: 0.80),
        ),
        child: DropdownButton<String>(
          isExpanded: true,
          items: [
            DropdownMenuItem<String>(
              child: Text('Cricket'),
              value: 'one',
            ),
            DropdownMenuItem<String>(
              child: Text('Basketball'),
              value: 'two',
            ),
            DropdownMenuItem<String>(
              child: Text('Hockey'),
              value: 'three',
            ),
            DropdownMenuItem<String>(
              child: Text('Football'),
              value: 'four',
            ),
            DropdownMenuItem<String>(
              child: Text('Badminton'),
              value: 'five',
            ),
            DropdownMenuItem<String>(
              child: Text('Tennis'),
              value: 'six',
            ),
            DropdownMenuItem<String>(
              child: Text('Soccer'),
              value: 'seven',
            ),
            DropdownMenuItem<String>(
              child: Text('Volleyball'),
              value: 'eight',
            ),
            DropdownMenuItem<String>(
              child: Text('Baseball'),
              value: 'nine',
            ),
            DropdownMenuItem<String>(
              child: Text('Bowling'),
              value: 'ten',
            ),
            DropdownMenuItem<String>(
              child: Text('Table Tennis'),
              value: 'eleven',
            ),
            DropdownMenuItem<String>(
              child: Text('Golf'),
              value: 'twelve',
            ),
            DropdownMenuItem<String>(
              child: Text('Field Hockey'),
              value: 'thirteen',
            ),
            DropdownMenuItem<String>(
              child: Text('Softball'),
              value: 'fourteen',
            ),
            DropdownMenuItem<String>(
              child: Text('Skate Boarding'),
              value: 'fifteen',
            ),
            DropdownMenuItem<String>(
              child: Text('Rowing'),
              value: 'sixteen',
            ),
          ],
          onChanged: (String value) {
            setState(() {
              _sport = Sports[value];
            });
          },
          hint: Text('Select Sport'),
          value: Sports[_sport],
        ),
      ),
    );
  }

  Widget _buildLocation() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Location',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Location is required';
        }
        return null;
      },
      onSaved: (String value) {
        _location = value;
      },
    );
  }

  Widget _buildDescription() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Description',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      keyboardType: TextInputType.multiline,
      maxLines: 6,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Description is required';
        }
        return null;
      },
      onSaved: (String value) {
        _description = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: (IconButton(
          icon: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 40.0,
            ),
          ),
          onPressed: () => {
            Navigator.pop(
              context,
            )
          },
        )),
        title: Text(
          "Create an Event",
          style: TextStyle(
            color: Colors.black,
            fontSize: 32,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        brightness: Brightness.light,
      ),
      body: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SportPicker(),
                _buildSport(),
                SizedBox(
                  height: 20,
                ),
                // _buildSport(),
                _buildTitle(),
                SizedBox(
                  height: 20,
                ),
                _buildLocation(),
                SizedBox(
                  height: 20,
                ),
                BasicDateField(),
                SizedBox(
                  height: 20,
                ),
                _buildDescription(),
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: RaisedButton(
                    child: Text(
                      'Add New Event',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.blueAccent)),
                    color: Colors.blueAccent,
                    onPressed: () async {
                      if (!_formKey.currentState.validate()) {
                        return;
                      }
                      _formKey.currentState.save();
                      _makePostRequest({
                        "utorid": (await SharedPreferences.getInstance())
                            .getString('uid'),
                        "sport": _sport,
                        "title": _title,
                        "description": _description,
                        "location": _location,
                        "date": dates.toString()
                      });
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

_makePostRequest(body) async {
  final Dio dio = new Dio();
  try {
    var response = await dio.post(_localhost('/event/new'), data: body);
    if (response.statusCode != 200)
      throw Exception('Failed to link with backend');
  } on DioError catch (e) {
    print(e);
  }
}

String _localhost(String route) {
  if (Platform.isAndroid)
    return 'http://10.0.2.2:3000' + route;
  else // for iOS simulator
    return 'http://localhost:3000' + route;
}
