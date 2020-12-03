import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
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
  "Tennis": "six"
};

var dates;
final _date_controller = TextEditingController();

class BasicDateField extends StatelessWidget {
  final format = DateFormat("yyyy-MM-dd");
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      DateTimeField(
        controller: _date_controller,
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
          return newSelectedDate;
        },
      ),
    ]);
  }
}

class EditEventCreation extends StatefulWidget {
  final id;

  EditEventCreation([this.id]);
  @override
  State<StatefulWidget> createState() {
    return EditEventCreationState();
  }
}

class EditEventCreationState extends State<EditEventCreation> {
  String _title;
  String _sport;
  String _location;
  String _description;
  final _title_controller = TextEditingController();
  final _location_controller = TextEditingController();
  final _description_controller = TextEditingController();
  final _dates_controller = _date_controller;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _makeGetRequest(
      widget.id,
      _title_controller,
      _location_controller,
      _description_controller,
      _dates_controller,
    );
  }

  _makeGetRequest(
    id,
    TextEditingController titleCont,
    TextEditingController locationCont,
    TextEditingController descCont,
    TextEditingController dateCont,
  ) async {
    final Dio dio = new Dio();
    try {
      var response = await dio.get(_localhost('/event/' + id));
      if (response.statusCode != 200)
        throw Exception('Failed to link with backend');
      titleCont.text = response.data['title'].toString();
      locationCont.text = response.data['location'].toString();
      descCont.text = response.data['description'].toString();
      dateCont.text = DateFormat("yyyy-MM-dd").format(
          (DateFormat("yyyy-MM-dd").parse(response.data['date'].toString())));
      // sport = response.data['sport'].toString();
      setState(() {
        _sport = response.data['sport'].toString();
      });
      return response;
    } on DioError catch (e) {
      print(e);
    }
  }

  Widget _buildTitle() {
    return TextFormField(
      controller: _title_controller,
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
      controller: _location_controller,
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
      controller: _description_controller,
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
          "Edit Event",
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
                      'Edit Event',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.blueAccent)),
                    color: Colors.blueAccent,
                    onPressed: () {
                      if (!_formKey.currentState.validate()) {
                        return;
                      }
                      _formKey.currentState.save();
                      _makePutRequest({
                        "utorid": 1234,
                        "sport": _sport,
                        "title": _title,
                        "description": _description,
                        "location": _location,
                        "date": dates.toString()
                      }, widget.id);
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

_makePutRequest(body, id) async {
  final Dio dio = new Dio();
  try {
    var response = await dio.put(_localhost('/event/' + id), data: body);
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
