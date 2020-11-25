import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
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
final _sport_controller = TextEditingController();

class EditEventCreation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EditEventCreationState();
  }
}

class Place {
  String streetNumber;
  String street;
  String city;
  String zipCode;

  Place({
    this.streetNumber,
    this.street,
    this.city,
    this.zipCode,
  });

  @override
  String toString() {
    return 'Place(streetNumber: $streetNumber, street: $street, city: $city, zipCode: $zipCode)';
  }
}

class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}

class PlaceApiProvider {
  final client = Client();

  PlaceApiProvider(this.sessionToken);

  final sessionToken;

  static final String androidKey = 'AIzaSyC57XIbeDE6hgHYLulW7Pcyy-OHvnKEnu4';
  static final String iosKey = 'AIzaSyBEoQo-Fm8vf7KIvRYRDB4lf5-610QQkIs';
  final apiKey = Platform.isAndroid ? androidKey : iosKey;

  Future<List<Suggestion>> fetchSuggestions(String input, String lang) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=address&language=$lang&components=country:ch&key=$apiKey&sessiontoken=$sessionToken';
    final response = await client.get(request);

    print(response);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        // compose suggestions in a list
        return result['predictions']
            .map<Suggestion>((p) => Suggestion(p['place_id'], p['description']))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<Place> getPlaceDetailFromId(String placeId) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=address_component&key=$apiKey&sessiontoken=$sessionToken';
    final response = await client.get(request);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        final components =
            result['result']['address_components'] as List<dynamic>;
        // build result
        final place = Place();
        components.forEach((c) {
          final List type = c['types'];
          if (type.contains('street_number')) {
            place.streetNumber = c['long_name'];
          }
          if (type.contains('route')) {
            place.street = c['long_name'];
          }
          if (type.contains('locality')) {
            place.city = c['long_name'];
          }
          if (type.contains('postal_code')) {
            place.zipCode = c['long_name'];
          }
        });
        return place;
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }
}

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

class AddressSearch extends SearchDelegate<Suggestion> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Clear',
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      // We will put the api call here
      future: null,
      builder: (context, snapshot) => query == ''
          ? Container(
              padding: EdgeInsets.all(16.0),
              child: Text('Enter your address'),
            )
          : snapshot.hasData
              ? ListView.builder(
                  itemBuilder: (context, index) => ListTile(
                    // we will display the data returned from our future here
                    title: Text(snapshot.data[index]),
                    onTap: () {
                      close(context, snapshot.data[index]);
                    },
                  ),
                  itemCount: snapshot.data.length,
                )
              : Container(child: Text('Loading...')),
    );
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

class EditEventCreationState extends State<EditEventCreation> {
  String _title;
  String _sport;
  String _location;
  String _date;
  String _description;
  final _controller = TextEditingController();
  final _title_controller = TextEditingController();
  final _location_controller = TextEditingController();
  final _description_controller = TextEditingController();
  final _dates_controller = _date_controller;

  String _streetNumber = '';
  String _street = '';
  String _city = '';
  String _zipCode = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
      // onTap: () async {
      //   // generate a new token here
      //   final sessionToken = Uuid().v4();
      //   final Suggestion result = await showSearch(
      //     context: context,
      //     delegate: AddressSearch(),
      //   );
      //   print(result);
      //   if (result != null) {
      //     final placeDetails = await PlaceApiProvider(sessionToken)
      //         .getPlaceDetailFromId(result.placeId);
      //     setState(() {
      //       _controller.text = result.description;
      //       _streetNumber = placeDetails.streetNumber;
      //       _street = placeDetails.street;
      //       _city = placeDetails.city;
      //       _zipCode = placeDetails.zipCode;
      //     });
      //   }
      // },
    );
  }

  Widget _buildDescription() {
    return TextFormField(
      controller: _description_controller,
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
    _makeGetRequest('-MMwwk6LocXI_D4h3ij7', _title_controller,
        _location_controller, _description_controller, _dates_controller);
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
                      }, '-MMwwk6LocXI_D4h3ij7');
                      Navigator.pop(
                        context,
                      );
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

_makeGetRequest(
    id,
    TextEditingController titleCont,
    TextEditingController locationCont,
    TextEditingController descCont,
    TextEditingController dateCont) async {
  final Dio dio = new Dio();
  try {
    var response = await dio.get(_localhost('/events/' + id));
    titleCont.text = response.data['title'].toString();
    locationCont.text = response.data['location'].toString();
    descCont.text = response.data['description'].toString();
    dateCont.text = response.data['date'].toString();

    if (response.statusCode != 200)
      throw Exception('Failed to link with backend');
    return response;
  } on DioError catch (e) {
    print(e);
  }
}
