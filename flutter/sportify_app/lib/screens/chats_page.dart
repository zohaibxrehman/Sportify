import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:sportify_app/screens/chat_page.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

// This screen is displayed when the user clicks the top right icon in
// the home screen. This screen is where the user can see all of the group
// chats that they are in. The user can simply click the specific event card
// to be taken to that chat.

// Currently, the dates are configured to be the date of the event instead of
// the date of the last sent message. Hope to develop the latter.

class ChatsPage extends StatefulWidget {
  @override
  ChatsPageState createState() {
    return new ChatsPageState();
  }
}

class ChatsPageState extends State<ChatsPage> {
  TextEditingController editingController = TextEditingController();
  // final _fireStore = FirebaseFirestore.instance;

  @override
  void initState() {
    _configureData();
    super.initState();
  }

  var data = List<dynamic>();
  var chatIndex = 0;
  var items = List<dynamic>();

  // This function will filter the search results of the group chats
  // based on the title of the event
  void filterSearchResults(String query) {
    List<dynamic> dummySearchList = List<dynamic>();
    returnData(dummySearchList);

    if (query.isNotEmpty) {
      List<dynamic> dummyListData = List<dynamic>();
      dummySearchList.forEach((item) {
        if (item["title"]
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        returnData(items);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          onPressed: () async => {
            Navigator.pop(
              context,
            )
          },
        )),
        centerTitle: true,
        title: Text(
          'Group Chats',
          style: TextStyle(
            fontSize: 26,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    focusColor: Colors.green,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Card(
                      child: ListTile(
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(items[index]['id']),
                        ),
                      )
                    },
                    title: Text('${items[index]["title"]}',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    leading: Image(
                      image: AssetImage(
                          'images/${items[index]["sport"]}'.toLowerCase() +
                              '.png'),
                      width: 45,
                      height: 45,
                    ),
                    trailing: Wrap(
                      spacing: 4,
                      children: <Widget>[
                        Text(
                          '${items[index]["date"]}',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 3.5, 0.0, 0.0),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: 10.0,
                          ),
                        ),
                      ],
                    ),
                  ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Adds the sorted data to the items List to be used to create the widgets
  returnData(List<dynamic> dataList) {
    data.forEach((element) {
      dataList.add(element);
    });
  }

  // Will return the required platform protocol for API calls
  String _localhost() {
    if (Platform.isAndroid)
      return 'http://10.0.2.2:3000';
    else // for iOS simulator
      return 'http://localhost:3000';
  }

  // This function will collect and sort the data from the firebase database
  // into a list called 'items' that we can use to construct our widgets
  _configureData() async {
    final Dio dio = new Dio();

    var userID = (await SharedPreferences.getInstance()).getString('uid');

    try {
      Response<dynamic> response =
          await dio.get(_localhost() + '/user/$userID/events');

      var dataList = List<dynamic>.from(response.data);
      var dataMap = {};
      var element;

      for (var i = 0; i < dataList.length; i++) {
        element = dataList[i];
        var eventResponse = await dio.get(_localhost() + '/event/$element');
        eventResponse.data['id'] = element;
        dataMap[element] = eventResponse.data;
      }

      // Testing for setting chat time to last recent message time
      // Currently in development
      // var unref = [];
      // _fireStore.collection("messages").get().then((querySnapshot) {
      //   querySnapshot.docs.forEach((result) {
      // print(result.data());
      // print(result.data()['id']);
      //     unref.add(result.data()['datetime']);
      //   });
      // });

      setState(() {
        dataMap.forEach((key, value) {
          data.add(value);
        });
      });

      data.sort((a, b) {
        return a['date'].compareTo(b['date']);
      });

      formatDates();
      returnData(items);

      if (response.statusCode != 200)
        throw Exception('Failed to link with backend');
    } on DioError catch (e) {
      print(e.response.data);
      print(e.response.headers);
      print(e.response.request);
    }
  }

  // This function reconfigures the date objects so that they can be read easily
  // by the user. For example, writing 'Tuesday' is better than 12/15/2020
  formatDates() {
    var tempDate;
    var now = DateTime.now();
    var difference;
    var newDate;
    var minutes;

    setState(() {
      for (int i = 0; i < data.length; i++) {
        tempDate = DateTime.parse(data[i]['date']);
        difference = now.difference(tempDate).inHours;

        if (difference < 24 && now.day == tempDate.day) {
          minutes = now.difference(tempDate).inMinutes;
          if (minutes < 60) {
            if (minutes < 1) {
              newDate = 'now';
            } else {
              newDate = minutes.toString() + ' m';
            }
          } else {
            newDate = difference.toString() + ' h';
          }
        } else if (difference < 168) {
          newDate = DateFormat('EEEE').format(tempDate);
        } else {
          if (now.year == tempDate.year) {
            newDate = new DateFormat.MMMd().format(tempDate);
          } else {
            newDate = new DateFormat.yMMMd().format(tempDate);
          }
        }
        data[i]['date'] = newDate;
      }
    });
  }
}
