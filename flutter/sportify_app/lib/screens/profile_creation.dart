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
                          filterChipWidget(chipName: 'Cricket'),
                          filterChipWidget(chipName: 'Football'),
                          filterChipWidget(chipName: 'Soccer'),
                          filterChipWidget(chipName: 'Tennis'),
                          filterChipWidget(chipName: 'Basketball'),
                          filterChipWidget(chipName: 'Badminton'),
                          filterChipWidget(chipName: 'Volleyball'),
                          filterChipWidget(chipName: 'Baseball'),
                          filterChipWidget(chipName: 'Bowling'),
                          filterChipWidget(chipName: 'Table Tennis'),
                          filterChipWidget(chipName: 'Golf'),
                          filterChipWidget(chipName: 'Hockey'),
                          filterChipWidget(chipName: 'Field Hockey'),
                          filterChipWidget(chipName: 'Softball'),
                          filterChipWidget(chipName: 'Skate Boarding'),
                          filterChipWidget(chipName: 'Rowing'),
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

class filterChipWidget extends StatefulWidget {
  final String chipName;

  filterChipWidget({Key key, this.chipName}) : super(key: key);

  @override
  _filterChipWidgetState createState() => _filterChipWidgetState();
}

class _filterChipWidgetState extends State<filterChipWidget> {
  var _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.chipName),
      labelStyle: TextStyle(
          color: Color(0xff005ce6),
          fontSize: 16.0,
          fontWeight: FontWeight.bold),
      selected: _isSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: Color(0xffededed),
      onSelected: (isSelected) {
        setState(() {
          _isSelected = isSelected;
        });
      },
      selectedColor: Color(0xffb3d1ff),
    );
  }
}
