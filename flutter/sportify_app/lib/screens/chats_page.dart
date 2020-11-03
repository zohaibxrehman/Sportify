import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'test_data.dart';

class ChatsPage extends StatefulWidget {
  @override
  ChatsPageState createState() {
    return new ChatsPageState();
  }
}

class ChatsPageState extends State<ChatsPage> {
  TextEditingController editingController = TextEditingController();
  @override
  void initState() {
    items.addAll(CHAT_DATA);
    super.initState();
  }

  var chatIndex = 0;
  var items = List<dynamic>();
  void filterSearchResults(String query) {
    List<dynamic> dummySearchList = List<dynamic>();
    dummySearchList.addAll(CHAT_DATA);

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
        items.addAll(CHAT_DATA);
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
          onPressed: () => {
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
}
