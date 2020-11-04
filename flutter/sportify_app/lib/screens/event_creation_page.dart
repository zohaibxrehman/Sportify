import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

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
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
        },
      ),
    ]);
  }
}

class SportPicker extends StatefulWidget {
  @override
  _SportPickerState createState() {
    return _SportPickerState();
  }
}

class _SportPickerState extends State<SportPicker> {
  String _value;

  @override
  Widget build(BuildContext context) {
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
              _value = value;
            });
          },
          hint: Text('Select Sport'),
          value: _value,
        ),
      ),
    );
  }
}

class EventCreationState extends State<EventCreation> {
  String _title;
  String _sport;
  String _location;
  String _date;
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
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Sport',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Sport is required';
        }
        return null;
      },
      onSaved: (String value) {
        _sport = value;
      },
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
        // contentPadding: const EdgeInsets.fromLTRB(5, 0, 0, 90),
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
                SportPicker(),
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
                    onPressed: () {
                      if (!_formKey.currentState.validate()) {
                        return;
                      }
                      _formKey.currentState.save();
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