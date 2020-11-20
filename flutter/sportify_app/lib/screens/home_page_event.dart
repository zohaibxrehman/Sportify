import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sportify_app/screens/profile_creation.dart';
import 'package:sportify_app/screens/event_creation_page.dart';
import 'package:sportify_app/screens/chats_page.dart';

class HomePageEvent extends StatelessWidget {
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
        image: 'cricket.png',
        title: 'Football at park',
        event: 'Basketball Event',
        location: 'High Park',
        description: "I am hosting a friendly basketball match at high park. "
            "I will be bringing the basketball and a carton full of juice boxes!"
            "My friends will also be attending. We are looking for"
            "7-8 more people.",
        author: 'Angela',
        date: 'Sept. 11, 2020',
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

  EventWidget({this.image, this.title, this.event, this.location, this.description, this.author,this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Container(
        decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(10.0),
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
              margin: EdgeInsets.symmetric(vertical: 35),
              child: Text(description, style: TextStyle(fontSize: 15),),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('- $author', style: TextStyle(fontSize: 16),),
                Text(date, style: TextStyle(fontSize: 16),),
              ],
            ),
          ],
        ),
      ),);
  }
}

