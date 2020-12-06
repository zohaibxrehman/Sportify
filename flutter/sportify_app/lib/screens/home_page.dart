import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sportify_app/screens/chat_page.dart';
import 'package:sportify_app/screens/home_page_event.dart';
import 'package:sportify_app/screens/profile_creation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportify_app/screens/edit_profile.dart';
import 'package:sportify_app/screens/event_creation_page.dart';
import 'package:sportify_app/screens/chats_page.dart';
import 'package:http/http.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var data = {};
  var loggedInUser;

  _getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString('uid');
    setState(() {
      loggedInUser = uid;
    });
  }

  @override
  void initState() {
    super.initState();
    _getEventsRequest();
    _getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf1f1f1),
      appBar: AppBar(
        toolbarHeight: 65.0,
        leading: (IconButton(
          icon: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
            child: Icon(
              Icons.account_circle,
              color: Colors.black,
              size: 50.0,
            ),
          ),
          onPressed: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditProfile()),
            )
          },
        )),
        centerTitle: true,
        title: Text(
          'Events',
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
            child: IconButton(
              icon: Image.asset('images/chat_button.png'),
              iconSize: 45.0,
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatsPage()),
                )
              },
            ),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 50.0,
        ),
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EventCreation()),
          )
        },
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: data.keys.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePageEvent(
                  '${data[data.keys.elementAt(index)]['sport']}.png', '${data[data.keys.elementAt(index)]['title']}',
                  '${data[data.keys.elementAt(index)]['sport']} event', '${data[data.keys.elementAt(index)]['location']}',
                  '${data[data.keys.elementAt(index)]['description']}', '${data[data.keys.elementAt(index)]['owner']}'
                  , '${DateFormat("yyyy-MM-dd").format(
                  (DateFormat("yyyy-MM-dd").parse(data[data.keys.elementAt(index)]['date'].toString())))}',
                '${data.keys.elementAt(index)}'
              ),),
            ),
            child: EventWidget(
              image: '${data[data.keys.elementAt(index)]['sport']}'.toLowerCase(),
              title: '${data[data.keys.elementAt(index)]['title']}',
              event: '${data[data.keys.elementAt(index)]['sport']} event',
              location: '${data[data.keys.elementAt(index)]['location']}',
              description: '${data[data.keys.elementAt(index)]['description']}',
              author: '${data[data.keys.elementAt(index)]['owner']}',
              date: '${DateFormat("yyyy-MM-dd").format(
              (DateFormat("yyyy-MM-dd").parse(data[data.keys.elementAt(index)]['date'].toString())))}',
              eventId: '${data.keys.elementAt(index)}',
              userId: loggedInUser,
              attend: (data[data.keys.elementAt(index)]['users']?.containsKey(loggedInUser) ?? false ) ? 'Attending' : 'Attend'
            ),
          );
        },
      ),
    );
  }

  _getEventsRequest() async {
    print('>>');
    final Dio dio = new Dio();
    try {
      var response = await dio.get(_localhost('/events'));
      var responseData = response.data;
      if (response.statusCode != 200)
        throw Exception('Failed to link with backend');
      print('>>');
      print(responseData[responseData.keys.elementAt(0)]['users']);
      setState(() {
        data = responseData;
      });
    } on DioError catch (e) {
      print(e);
    }
  }

}

_putAttendEvent(eventId, userId) async {
  final Dio dio = new Dio();
  try {
    var response = await dio.put(_localhost('/event/$eventId/$userId/unattend'));
    print(response.statusCode);
    if (response.statusCode != 200)
      throw Exception('Failed to link with backend');
  } on DioError catch (e) {
    print(e);
  }
}

_putAttendingEvent(eventId, userId) async {
  final Dio dio = new Dio();
  try {
    var response = await dio.put(_localhost('/event/$eventId/$userId/attend'));
    print(response.statusCode);
    if (response.statusCode != 200)
      throw Exception('Failed to link with backend');
  } on DioError catch (e) {
    print(e);
  }
}

String _localhost(uri) {
  if (Platform.isAndroid)
    return 'http://10.0.2.2:3000' + uri;
  else // for iOS simulator
    return 'http://localhost:3000' + uri;
}

class EventWidget extends StatefulWidget {
  final title;
  final image;
  final event;
  final location;
  final description;
  final author;
  final date;
  final eventId;
  final userId;
  var attend;

  EventWidget({this.image, this.title, this.event, this.location, this.description, this.author,this.date, this.eventId, this.userId, this.attend});

  @override
  _EventWidgetState createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 22, 20, 5),
      child: Container(
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(15.0),
        color: Colors.white),
        padding: EdgeInsets.symmetric(horizontal: 17, vertical: 15),
        child: Column(
          children: [Container(height: 100,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage('images/${widget.image}.png'),
              ),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Text(widget.title, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),)),
                SizedBox(width: 10,),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 15,),
                    SizedBox(width: 2),
                    Text(widget.location, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  ],
                ),
              ],
            ),
            SizedBox(height: 3),
            Container(
              alignment: Alignment.topLeft,
              child: Text(widget.event, style: TextStyle(fontSize: 15, color: Colors.blueGrey),),),

            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Text(widget.description, overflow: TextOverflow.ellipsis, maxLines: 3,),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Text('- ${widget.author}', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16),)),
                Text(widget.date, style: TextStyle(fontSize: 16),),
              ],
            ),
            SizedBox(height: 25,),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: ()  {
                      if (widget.attend == 'Attend'){
                        _putAttendingEvent(widget.eventId, widget.userId);
                        setState(() {
                          widget.attend = 'Attending';
                        });
                      }
                      else {
                        _putAttendEvent(widget.eventId, widget.userId);
                        setState(() {
                          widget.attend = 'Attend';
                        });
                      }

                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Text(widget.attend, style: TextStyle(color: Colors.white),), decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(10.0),
                      color: Colors.lightBlue,
                    ),),),
                ),
                SizedBox(width: 5,),
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatScreen(
                           widget.eventId
                        ),),
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Text('Chat', style: TextStyle(color: Colors.white),), decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(10.0),
                      color: Colors.lightGreen,
                    ),),),
                ),
              ],
            ),
          ],
        ),
      ),);
  }
}
