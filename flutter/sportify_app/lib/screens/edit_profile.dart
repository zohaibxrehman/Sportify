import 'package:http/http.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportify_app/screens/home_page.dart';
import 'package:dio/dio.dart';

class EditProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EditProfileState();
  }
}

class EditProfileState extends State<EditProfile> {
  String _firstName;
  String _lastName;
  String _favTeam;
  List sports = [];
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _favTeamController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _makeGetRequestCopy() async {
    _makeGetRequest((await SharedPreferences.getInstance()).getString('uid'),
        _firstNameController, _lastNameController, _favTeamController);
  }

  @override
  void initState() {
    super.initState();
    _makeGetRequestCopy();
  }

  Widget _buildFirstName() {
    return TextFormField(
        controller: _firstNameController,
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
        controller: _lastNameController,
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

  //Divider
  Container categoryDivider() {
    return Container(
      height: 1.0,
      width: MediaQuery.of(context).size.width,
      color: Colors.grey,
      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
    );
  }

  Widget _buildFavTeam() {
    return TextFormField(
        controller: _favTeamController,
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

  _makeGetRequest(id, TextEditingController firstCont,
      TextEditingController lastCont, TextEditingController favTeamCont) async {
    final Dio dio = new Dio();
    try {
      var response = await dio.get(_localhost('/user/' + id));
      // print(response.data);
      // firstCont.text = response.data['firstName'].toString();
      // lastCont.text = response.data['lastName'].toString();
      // favTeamCont.text = response.data['favoriteTeam'].toString();
      // var sportsList = [];
      // for (var i = 0; i < 16; i++) {
      //   print(response.data['sportsInterests'][i][0]);
      //   sportsList.add(filterChipWidget(
      //     chipName: response.data['sportsInterests'][i][0],
      //     selected: response.data['sportsInterests'][i][1],
      //   ));
      // }
      //
      // sports = sportsList;

      if (response.statusCode != 200)
        throw Exception('Failed to link with backend');
      print(response.data);
      firstCont.text = response.data['firstName'].toString();
      lastCont.text = response.data['lastName'].toString();
      favTeamCont.text = response.data['favoriteTeam'].toString();
      var sportsList = [];
      for (var i = 0; i < 16; i++) {
        print(response.data['sportsInterests'][i][0]);
        sportsList.add(filterChipWidget(
          chipName: response.data['sportsInterests'][i][0],
          selected: response.data['sportsInterests'][i][1],
        ));
      }
      setState(() {
        sports = sportsList;
      });

      return response;
    } on DioError catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65.0,
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
        centerTitle: true,
        title: Text("Profile",
            style: TextStyle(
              fontSize: 32,
              color: Colors.black,
            )),
        backgroundColor: Colors.white,
        brightness: Brightness.light,
      ),
      body: Container(
          child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildFirstName(),
                      SizedBox(height: 20),
                      _buildLastName(),
                      SizedBox(height: 20),
                      categoryDivider(),
                      //Offer heading
                      Container(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Sports you Play',
                          style: TextStyle(
                            color: Color(0xff005ce6),
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),

                      //Chips
                      Wrap(
                        spacing: 5.0,
                        runSpacing: 5.0,
                        children: <Widget>[
                          for (var sport in sports) sport,
                        ],
                      ),
                      categoryDivider(),
                      SizedBox(height: 20),
                      _buildFavTeam(),
                      // _buildDOB(),
                      SizedBox(
                        height: 100,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: RaisedButton(
                            child: Text(
                              'Save Profile',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            color: Colors.blueAccent,
                            onPressed: () async {
                              if (!_formKey.currentState.validate()) {
                                return;
                              }
                              List retrievedData = [];
                              _formKey.currentState.save();
                              for (var sport in sports)
                                retrievedData
                                    .add([sport.chipName, sport.selected]);

                              _makePutRequest(
                                {
                                  "utorid":
                                      (await SharedPreferences.getInstance())
                                          .getString('uid'),
                                  "firstName": _firstName,
                                  "lastName": _lastName,
                                  "sportsInterests": retrievedData,
                                  "favoriteTeam": _favTeam,
                                },
                                (await SharedPreferences.getInstance())
                                    .getString('uid'),
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()),
                              );
                            }),
                      )
                    ],
                  )))),
    );
  }
}

class filterChipWidget extends StatefulWidget {
  final String chipName;
  var selected;

  filterChipWidget({Key key, this.chipName, this.selected}) : super(key: key);

  @override
  _filterChipWidgetState createState() => _filterChipWidgetState();
}

class _filterChipWidgetState extends State<filterChipWidget> {
  //var _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.chipName),
      labelStyle: TextStyle(
          color: Color(0xff005ce6),
          fontSize: 16.0,
          fontWeight: FontWeight.bold),
      selected: widget.selected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: Color(0xffededed),
      onSelected: (isSelected) {
        setState(() {
          //_isSelected = isSelected;
          widget.selected = isSelected;
        });
      },
      selectedColor: Color(0xffb3d1ff),
    );
  }
}

_makePutRequest(body, id) async {
  final Dio dio = new Dio();
  try {
    print(body);
    var response = await dio.put(_localhost('/user/' + id), data: body);

    if (response.statusCode != 200)
      throw Exception('Failed to link with back end');
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
