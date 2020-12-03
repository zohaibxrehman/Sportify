import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sportify_app/screens/edit_event_creation.dart';
import 'package:sportify_app/screens/home_page.dart';
import 'package:sportify_app/screens/profile_creation.dart';
import 'package:sportify_app/screens/event_creation_page.dart';
import 'package:sportify_app/screens/chats_page.dart';
import 'package:dio/dio.dart';
import 'dart:io';


class HomePageEvent extends StatelessWidget {
  final image;
  final title;
  final event;
  final location;
  final description;
  final author;
  final date;
  final id;

  HomePageEvent([this.image, this.title, this.event, this.location, this.description, this.author, this.date, this.id]);

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
        title: Text(
          'Event',
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
          ),
        ),
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
      body: EventWidget(
        image: image,
        title: title,
        event: event,
        location: location,
        description: description,
        author: author,
        date: date,
        id: id,
      ),
    );
  }
}

class EventWidget extends StatelessWidget {
  final title;
  final image;
  final event;
  final location;
  final description;
  final author;
  final date;
  final id;

  EventWidget({this.image, this.title, this.event, this.location, this.description, this.author,this.date,this.id});

  _deleteEvent() async {
    final Dio dio = new Dio();
    try {
      var response = await dio.delete(_localhost('/event/' + id));
      if (response.statusCode != 200)
        throw Exception('Failed to link with backend');
      return response;
    } on DioError catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Container(
        decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(15.0),
            color: Colors.white),
        padding: EdgeInsets.symmetric(horizontal: 17, vertical: 15),
        child: Column(
          children: [Container(height: 125,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage('images/cricket.png',),
              ),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: Text(title, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),)),
                SizedBox(width: 10,),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16,),
                    SizedBox(width: 2),
                    Text(location, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),),
                  ],
                ),
              ],
            ),
            SizedBox(height: 4),

            Container(  
              alignment: Alignment.topLeft,
              child: Text(event, style: TextStyle(fontSize: 16, color: Colors.blueGrey),),),

            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Text(description, style: TextStyle(fontSize: 15),),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('- $author', style: TextStyle(fontSize: 16),),
                Text(date, style: TextStyle(fontSize: 16),),
              ],
            ),
            SizedBox(height: 25,),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditEventCreation(
                            id
                        ),),
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit, color: Colors.white, size: 13,),
                          SizedBox(width: 5,),
                          Text('Edit', style: TextStyle(color: Colors.white),),
                        ],
                      ), decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(10.0),
                      color: Colors.deepOrangeAccent,
                    ),),),
                ),
                SizedBox(width: 5,),
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      _deleteEvent();
                        Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                        },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete, color: Colors.white, size: 13,),
                          SizedBox(width: 5,),
                          Text('Delete', style: TextStyle(color: Colors.white),),
                        ],
                      ), decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(10.0),
                      color: Colors.redAccent,
                    ),),),
                ),
              ],
            ),
          ],
        ),
      ),);
  }
}

String _localhost(uri) {
  if (Platform.isAndroid)
    return 'http://10.0.2.2:3000' + uri;
  else // for iOS simulator
    return 'http://localhost:3000' + uri;
}