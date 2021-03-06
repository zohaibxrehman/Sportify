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
import 'package:pull_to_refresh/pull_to_refresh.dart';

// After you log in this is the view that you come across. Here, you will
// see all the active events and have the ability to view your profile, chat,
// and mark your attendance for your event.

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var data = [];
  var loggedInUser;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    _getEventsRequest();
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    _refreshController.loadComplete();
  }

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
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: ClassicHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("pull up load");
            } else if (mode == LoadStatus.loading) {
              body = CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text("Load Failed!Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              body = Text("release to load more");
            } else {
              body = Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            var creator = loggedInUser == '${data[index]['owner']}';
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return HomePageEvent(
                      '${data[index]['sport']}'.toLowerCase(),
                      '${data[index]['title']}',
                      '${data[index]['sport']} event',
                      '${data[index]['location']}',
                      '${data[index]['description']}',
                      '${data[index]['userInfo']['firstName']} ${data[index]['userInfo']['lastName']}',
                      '${DateFormat("yyyy-MM-dd").format((DateFormat("yyyy-MM-dd").parse(data[index]['date'].toString())))}',
                      '${data[index]['eventId']}',
                      creator,
                    );
                  },
                ),
              ),
              child: EventWidget(
                  image: '${data[index]['sport']}'.toLowerCase(),
                  title: '${data[index]['title']}',
                  event: '${data[index]['sport']} event',
                  location: '${data[index]['location']}',
                  description: '${data[index]['description']}',
                  author:
                      '${data[index]['userInfo']['firstName']} ${data[index]['userInfo']['lastName']}',
                  date:
                      '${DateFormat("yyyy-MM-dd").format((DateFormat("yyyy-MM-dd").parse(data[index]['date'].toString())))}',
                  eventId: '${data[index]['eventId']}',
                  userId: loggedInUser,
                  attend:
                      (data[index]['users']?.containsKey(loggedInUser) ?? false)
                          ? 'Attending'
                          : 'Attend'),
            );
          },
        ),
      ),
    );
  }

  // request to get all active events
  _getEventsRequest() async {
    final Dio dio = new Dio();
    try {
      var response = await dio.get(_localhost('/events'));
      var responseData = response.data;
      if (response.statusCode != 200)
        throw Exception('Failed to link with backend');
      for (var i = 0; i < responseData.length; i++) {
        responseData[i]['userInfo'] =
            await _getUserById(responseData[i]['owner']);
      }
      setState(() {
        data = responseData;
      });
    } on DioError catch (e) {
      print(e);
    }
  }

  // request to get information about the current user
  _getUserById(id) async {
    final Dio dio = new Dio();
    try {
      var response = await dio.get(_localhost('/user/$id'));
      var responseData = response.data;
      if (response.statusCode != 200)
        throw Exception('Failed to link with backend');
      return responseData;
    } on DioError catch (e) {
      print(e);
    }
  }
}

// request to modify attendance - un attending

_putAttendEvent(eventId, userId) async {
  final Dio dio = new Dio();
  try {
    var response =
        await dio.put(_localhost('/event/$eventId/$userId/unattend'));
    if (response.statusCode != 200)
      throw Exception('Failed to link with backend');
  } on DioError catch (e) {
    print(e);
  }
}

// request to modify attendance - attending

_putAttendingEvent(eventId, userId) async {
  final Dio dio = new Dio();
  try {
    var response = await dio.put(_localhost('/event/$eventId/$userId/attend'));
    if (response.statusCode != 200)
      throw Exception('Failed to link with backend');
  } on DioError catch (e) {
    print(e);
  }
}

//Used for connecting to localhost - api request
String _localhost(uri) {
  if (Platform.isAndroid)
    return 'http://10.0.2.2:3000' + uri;
  else // for iOS simulator
    return 'http://localhost:3000' + uri;
}

// This is for building the ui component - individual event card you see on the
// home page.

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

  EventWidget(
      {this.image,
      this.title,
      this.event,
      this.location,
      this.description,
      this.author,
      this.date,
      this.eventId,
      this.userId,
      this.attend});

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
            borderRadius: new BorderRadius.circular(15.0), color: Colors.white),
        padding: EdgeInsets.symmetric(horizontal: 17, vertical: 15),
        child: Column(
          children: [
            Container(
              height: 100,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: AssetImage('images/${widget.image}.png'),
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: Text(
                  widget.title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                )),
                SizedBox(
                  width: 10,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 15,
                    ),
                    SizedBox(width: 2),
                    Text(
                      widget.location,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 3),
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                widget.event,
                style: TextStyle(fontSize: 15, color: Colors.blueGrey),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                widget.description,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: Text(
                  '- ${widget.author}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16),
                )),
                Text(
                  widget.date,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (widget.attend == 'Attend') {
                        _putAttendingEvent(widget.eventId, widget.userId);
                        setState(() {
                          widget.attend = 'Attending';
                        });
                      } else {
                        _putAttendEvent(widget.eventId, widget.userId);
                        setState(() {
                          widget.attend = 'Attend';
                        });
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Text(
                        widget.attend,
                        style: TextStyle(color: Colors.white),
                      ),
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.circular(10.0),
                        color: Colors.lightBlue,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(widget.eventId),
                        ),
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Text(
                        'Chat',
                        style: TextStyle(color: Colors.white),
                      ),
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.circular(10.0),
                        color: Colors.lightGreen,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
