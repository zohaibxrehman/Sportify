import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sportify_app/screens/profile_page.dart';
import 'package:sportify_app/screens/event_creation_page.dart';
import 'package:sportify_app/screens/chats_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              MaterialPageRoute(builder: (context) => ProfilePage()),
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
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
            child: IconButton(
              icon: Icon(
                Icons.chat_bubble,
                color: Colors.black,
                size: 45.0,
              ),
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
            MaterialPageRoute(builder: (context) => EventCreationPage()),
          )
        },
      ),
    );
  }
}
