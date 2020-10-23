import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:petmatch/theme/styles.dart';
import 'package:http/http.dart' as http;

class PetsPage extends StatefulWidget {
  @override
  _PetsPageState createState() => _PetsPageState();
}

class _PetsPageState extends State<PetsPage> {
  Future petsData;

  @override
  void initState() {
    petsData = getPets();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(239, 239, 245, 1.0),
      appBar: new AppBar(
        elevation: 2.0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        title: new Text(
          "Pets",
          style: new TextStyle(
            color: new Color.fromRGBO(92, 107, 122, 1.0),
            fontSize: 25.0,
            fontFamily: "Poppins",
            // fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: false,
        leading: new FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child:
                new Image(image: new ExactAssetImage("assets/back-arrow.png"))),
        automaticallyImplyLeading: true,
        actions: [],
      ),
      floatingActionButton: FloatingActionButton(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: new BoxDecoration(
              gradient: new LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [gradientOne, gradientTwo, gradientThree],
                tileMode: TileMode.repeated,
              ),
              borderRadius: new BorderRadius.all(new Radius.circular(50.0))),
          child: Icon(Icons.add),
        ),
        onPressed: () {
          Navigator.of(context).pushNamed("/pet");
        },
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: FutureBuilder(
          future: petsData,
          builder: (_context, _snapshot) {
            if (_snapshot.hasData) {
              return CustomScrollView(slivers: [
                SliverGrid(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300.0,
                      mainAxisSpacing: 20.0,
                      crossAxisSpacing: 20.0,
                      childAspectRatio: 1.0,
                    ),
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext __context, int index) {
                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              image: DecorationImage(
                                  image: NetworkImage(_snapshot.data['pets']
                                      [index]['pictures'][0]),
                                  fit: BoxFit.cover)),
                        ),
                      );
                    }, childCount: _snapshot.data['pets'].length))
              ]);
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  getPets() async {
    final storage = new FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final String url =
        'https://us-central1-petmatch-firebase-api.cloudfunctions.net/api/pets';
    final response = await http.get(url, headers: {'x-access-token': token});
    final data = jsonDecode(response.body);

    print(data);

    return data;
  }
}
