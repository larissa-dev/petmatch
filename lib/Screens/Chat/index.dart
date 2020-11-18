import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:petmatch/Screens/Chat/chatting.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => new _ChatState();
}

class _ChatState extends State<Chat> {
  TabController controller;
  Future apiData;
  String currentUserUid;

  void initState() {
    apiData = _getMatchedUsers();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        elevation: 1.0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        title: new Text(
          "Combinações",
          style: new TextStyle(
            color: new Color.fromRGBO(92, 107, 122, 1.0),
            fontSize: 25.0,
            fontFamily: "Poppins",
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: FutureBuilder(
          future: apiData,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.data.runtimeType == QuerySnapshot) {
              QuerySnapshot data  = snapshot.data;

              return ListView.builder(
                itemCount: data.docs.length,
                itemBuilder: (context, index) {
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
                            builder: (context) => ChattingScreen(
                              name: data.docs[index].get('nickname'),
                              currentUserUid: currentUserUid,
                              peerId: data.docs[index].get('id'),
                              peerAvatar: data.docs[index].get('photoUrl'),
                            ),
                          ),
                        );
                      },
                      leading: new CircleAvatar(backgroundImage: NetworkImage(data.docs[index].get('photoUrl'))),
                      title: new Text(data.docs[index].get('nickname')),
                    ),
                  );
                },
              );
            }

            return Container();
          },
        ),
      ),
    );
  }

  //Future<QuerySnapshot> firestoreResult = FirebaseFirestore.instance.collection('users').get();
  _getMatchedUsers() async {
    final storage = new FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final String url =
        'https://us-central1-petmatch-firebase-api.cloudfunctions.net/api/matches';
    final response = await http.get(url, headers: {'x-access-token': token});
    final currentUser = jsonDecode(await storage.read(key: 'currentUser'));

    currentUserUid = currentUser['googleId'];

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['success']) {
        List matches = data['matches'];
        List ids = matches.where((e) => e['google_id'] != currentUser['googleId'])
          .toList()
          .map((e) => e['google_id'])
          .toList();

        if (ids.isNotEmpty) {
          QuerySnapshot firestoreResult = 
            await FirebaseFirestore.instance
              .collection('users')
              .where('id', whereIn: ids)
              .get();

          return firestoreResult;
        }
      }

      return [];
    }

    return [];
  }
}
