import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatsPage extends StatefulWidget {
  @override
  ChatsPageState createState() {
    return new ChatsPageState();
  }
}

class ChatsPageState extends State<ChatsPage> {
  TextEditingController editingController = TextEditingController();
  final _fireStore = FirebaseFirestore.instance;

  @override
  void initState() {
    _getRequest();
    // printEmail();
    super.initState();
  }

  var data = List<dynamic>();
  var chatIndex = 0;
  var items = List<dynamic>();

  //
  // getValue() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String d = prefs.getString('uid');
  //   return d;
  // }

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
                      // TODO: Add a way to click on each event page
                    },
                    title: Text('${items[index]["title"]}',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    leading: Image(
                      image: AssetImage('images/${items[index]["image"]}'),
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

  returnData(List<dynamic> dataList) {
    data.forEach((element) {
      dataList.add(element);
    });
  }

  String _localhost(userID) {
    if (Platform.isAndroid)
      return 'http://10.0.2.2:3000/user/$userID/events';
    else // for iOS simulator
      return 'http://localhost:3000/user/$userID/events';
  }

  _getRequest() async {
    final Dio dio = new Dio();

    var userID = (await SharedPreferences.getInstance()).getString('uid');

    try {
      var response = await dio.get(_localhost(userID));
      print(response.data.toString());
      var dataList = Map<String, dynamic>.from(response.data);

      //print(new DateFormat.yMMMd().format(new DateTime.now()));
      //print(DateTime.now());
      // print(_fireStore
      //     .collection('messages'));
      // var document = _fireStore.collection('messages');

      var dates = [];
      var unref = [];

      _fireStore.collection("messages").get().then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          print(result.data());
          print(result.data()['id']);
          unref.add(result.data()['datetime']);
        });
      });

      // print(v);
      // print(_fireStore
      //     .collection('messages')
      //     .orderBy('datetime', descending: true)
      //     .snapshots());
      // var chats = _fireStore.collection("messages");
      // chats.get().then((value) => null)

      var keys = [];
      dataList.forEach((key, value) {
        keys.add(key);
      });
      //print(keys);

      setState(() {
        dataList.forEach((key, value) {
          data.add(value);
        });
      });
      data.sort((a, b) {
        return -a['date'].compareTo(b['date']);
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
