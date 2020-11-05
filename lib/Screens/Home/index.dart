import 'dart:async';
import 'dart:convert';
import 'package:flushbar/flushbar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:petmatch/Components/swipeButton.dart';
import 'package:petmatch/Screens/Home/detail.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<Widget> cardList;
  Future apiData;
  Size screenSize;

  void initState() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((postition) async {
      final storage = new FlutterSecureStorage();
      final token = await storage.read(key: 'token');
      final String url =
          'https://us-central1-petmatch-firebase-api.cloudfunctions.net/api/profile/location';

      final Map requestBody = {
        "latitude": postition.latitude.toString(),
        "longitude": postition.longitude.toString(),
      };

      await http
          .put(url, body: requestBody, headers: {'x-access-token': token});
    });

    apiData = _search();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return new Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        margin: EdgeInsets.only(top: 50),
        child: Center(
          child: FutureBuilder(
            future: apiData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Stack(
                  alignment: Alignment.center,
                  children: cardList,
                );
              }

              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }

  void _removeCard() {
    setState(() {
      cardList.removeLast();
    });
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0.5,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      title: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Text(
            "Buscar",
            style: new TextStyle(
              color: new Color.fromRGBO(92, 107, 122, 1.0),
              fontSize: 25.0,
              fontFamily: "Poppins",
            ),
          ),
          new Container(
            width: 15.0,
            height: 15.0,
            margin: new EdgeInsets.only(bottom: 20.0),
            alignment: Alignment.center,
            child: new Text(
              '0',
              style: new TextStyle(fontSize: 10.0),
            ),
            decoration:
                new BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          )
        ],
      ),
    );
  }

  Future<List> _search() async {
    final storage = new FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final String url =
        'https://us-central1-petmatch-firebase-api.cloudfunctions.net/api/pets/search';
    final response = await http.get(url, headers: {'x-access-token': token});

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      if (responseData['success']) {
        List pets = responseData['pets'];
        List<Widget> cards = [];
        int index = 0;

        pets.forEach((pet) {
          cards.add(Positioned(
            top: double.parse(((index + 1) * 10).toString()),
            child: Draggable(
              onDragEnd: (drag) {
                if (drag.offset.direction > 1) {
                  _removeCard();
                } else {
                  _match();
                }
              },
              childWhenDragging: Container(),
              feedback: Card(
                elevation: 12,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  width: screenSize.width * 0.9,
                  height: 500,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        width: screenSize.width * 0.9,
                        child: Image.network(
                          pet['photo'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        height: 500 * 0.2,
                        width: screenSize.width * 0.9,
                        color: Colors.white,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new SwipeButton(
                              text: "NÃO",
                              onClick: () {
                                _removeCard();
                              },
                            ),
                            new SwipeButton(
                              text: "SIM",
                              onClick: () {
                                _match();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              child: Hero(
                tag: 'pet' + pet['id'].toString(),
                child: Card(
                  elevation: 12,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    width: screenSize.width * 0.9,
                    height: 500,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailPage(
                                        pet: pet,
                                        yes: _match,
                                        no: _removeCard,
                                      )),
                            );
                          },
                          child: Container(
                            width: screenSize.width * 0.9,
                            child: Image.network(
                              pet['photo'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          height: 500 * 0.2,
                          width: screenSize.width * 0.9,
                          color: Colors.white,
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              new SwipeButton(
                                text: "NÃO",
                                onClick: () {
                                  _removeCard();
                                },
                              ),
                              new SwipeButton(
                                text: "SIM",
                                onClick: () {
                                  _match();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ));

          index++;
        });

        cardList = cards;

        return responseData['pets'];
      }
    }

    return [];
  }

  _match() {
    Flushbar(
      message: 'MATCH!!!',
      duration: Duration(seconds: 5),
      leftBarIndicatorColor: Colors.green.shade300,
      backgroundColor: Colors.green.shade300,
      icon: Icon(
        Icons.error_outline,
        size: 28,
        color: Colors.white,
      ),
    ).show(context);

    _removeCard();
  }
}
