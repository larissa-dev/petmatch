import 'package:petmatch/Screens/Chat/chatting.dart';
import 'package:petmatch/Screens/Chat/styles.dart';
import 'package:petmatch/Screens/Home/data.dart';
import 'package:flutter/material.dart';


class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => new _ChatListState();
}

class _ChatListState extends State<ChatList> {
  List name = nameData;
  List data = avatarData;

  @override
  Widget build(BuildContext context) {
    var i = -1;

    return new Scaffold(
      appBar: new AppBar(
        elevation: 2.0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: new Text(
          "Combinações",
          style: new TextStyle(
            color: new Color.fromRGBO(92, 107, 122, 1.0),
            fontSize: 25.0,
            fontFamily: "Poppins",
            //fontWeight: FontWeight.bold
          ),
        ),
        leading: new FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child:
                new Image(image: new ExactAssetImage("assets/back-arrow.png"))),
        automaticallyImplyLeading: true,
      ),
      body: ListView(
          children: name.map((item) {
        ++i;
        return Container(
          decoration: new BoxDecoration(
              color: Colors.white,
              border: new Border(
                  bottom: new BorderSide(width: 0.5, color: Colors.grey[300]))),
          child: new ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChattingScreen(name: item),
                ),
              );
            },
            leading: new CircleAvatar(backgroundImage: data[i]),
            title: new Text(item),
            subtitle: new Text(
              "2km away, 20 min ago",
              style: new TextStyle(fontSize: 12.0),
            ),
          ),
        );
      }).toList()),
    );
  }
}
