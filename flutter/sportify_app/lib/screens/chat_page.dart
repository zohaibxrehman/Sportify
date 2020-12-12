import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dio/dio.dart';
import 'dart:io';

// This screen is displayed when the user clicks the chat icon on the home page
// for each event or in the group chats view. This screen is where the user can
// chat with others in the particular events group chat.

class ChatScreen extends StatefulWidget {
  final id;

  ChatScreen([this.id]);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final _fireStore = FirebaseFirestore.instance;
  var loggedInUser = {};

  String messageText;
  final msgController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  // api request for getting information about the current user
  _getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString('uid');
    final Dio dio = new Dio();
    try {
      var response = await dio.get(_localhost('/user/$uid'));
      var responseData = response.data;
      if (response.statusCode != 200)
        throw Exception('Failed to link with backend');
      setState(() {
        loggedInUser['uid'] = uid;
        loggedInUser['name'] = responseData["firstName"];
      });
    } on DioError catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf1f1f1),
      appBar: AppBar(
        centerTitle: true,
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
                //Implement logout functionality
              }),
        ],
        title: Text('️Messages'),
        backgroundColor: Color(0xFF2F80ED),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: _fireStore.collection('messages').where('id', isEqualTo: widget.id).orderBy('datetime', descending: true).snapshots(),
              // ignore: missing_return
              builder: (context, snapshot) {
                List<MessageBubble> messageWidgets = [];
                if (!snapshot.hasData) {
                  return Column();
                }
                final messages = snapshot.data.docs;
                for (var message in messages) {
                  bool isUser;
                  print(message['sender'] + ': ' + message['text']);
                  if (message['sender_id'] == loggedInUser['uid']) {
                    isUser = true;
                  } else {
                    isUser = false;
                  }
                  final messageWidget = MessageBubble(
                    messageText: message['text'],
                    messageSender: message['sender'],
                    isUser: isUser,
                  );
                  messageWidgets.add(messageWidget);
                }
                return Expanded(
                    child: ListView(
                        reverse: true,
                        padding: EdgeInsets.all(10),
                        children: messageWidgets));
              },
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFF2F80ED), width: 2.0),
                ),
              ),
              child: Container(
                color: Colors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        style: TextStyle(color: Colors.black),
                        onChanged: (value) {
                          messageText = value;
                          //Do something with the user input.
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                          hintText: 'Type your message here...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        msgController.clear();
                        _fireStore.collection('messages').add(
                            {'id': widget.id, 'text': messageText, 'sender': loggedInUser['name'], 'sender_id': loggedInUser['uid'], 'datetime': DateTime.now().toUtc(),});
                      },
                      child: Icon(Icons.send, color: Color(0xFF2F80ED),),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// This is to build the ui component - individual chat bubble

class MessageBubble extends StatelessWidget {
  MessageBubble({this.messageText, this.messageSender, this.isUser});

  final String messageText;
  final String messageSender;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
        isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          isUser ? SizedBox(height:0):
          Text(
            '  ' + messageSender,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          SizedBox(height: 1,),
          Material(
            borderRadius: isUser ? BorderRadius.only(
                topLeft: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0))
                : BorderRadius.only(
              topLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
            color: isUser ? Color(0xFF2F80ED) : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Text(
                '$messageText',
                style: TextStyle(
                    fontSize: 15,
                    color: isUser ? Colors.white : Color(0xFF2F80ED)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//Used for connecting to localhost - api request

String _localhost(uri) {
  if (Platform.isAndroid)
    return 'http://10.0.2.2:3000' + uri;
  else // for iOS simulator
    return 'http://localhost:3000' + uri;
}