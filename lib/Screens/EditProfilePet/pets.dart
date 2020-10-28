import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:petmatch/Screens/EditProfilePet/create.dart';
import 'package:petmatch/Screens/EditProfilePet/index.dart';
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePet(),
            ),
          );
        },
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: FutureBuilder(
          future: petsData,
          builder: (_context, _snapshot) {
            if (_snapshot.hasData &&
                _snapshot.connectionState == ConnectionState.done) {
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditPet(_snapshot.data['pets'][index]),
                            ),
                          );
                        },
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: new Text("Remover Pet?"),
                                content: new Text(
                                    "Esta ação não poderá ser desfeita."),
                                actions: <Widget>[
                                  // define os botões na base do dialogo
                                  new FlatButton(
                                    child: new Text("Fechar"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  new FlatButton(
                                    child: new Text("Excluir"),
                                    onPressed: () {
                                      deletePet(
                                          _snapshot.data['pets'][index]['id']);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          width: 200.0,
                          height: 280.0,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(15.0),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      _snapshot.data['pets'][index]['photo']),
                                  fit: BoxFit.cover)),
                        ),
                      );
                    }, childCount: _snapshot.data['pets'].length))
              ]);
            }

            if (_snapshot.connectionState == ConnectionState.done) {
              return Container();
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

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return data;
    }

    Flushbar(
      message: 'Houve um erro ao processar as informações.',
      duration: Duration(seconds: 5),
      leftBarIndicatorColor: Colors.red.shade300,
      backgroundColor: Colors.red.shade300,
      icon: Icon(
        Icons.error_outline,
        size: 28,
        color: Colors.white,
      ),
    ).show(context);

    return null;
  }

  deletePet(int id) async {
    Flushbar(
      message: 'Estamos processando suas informações, aguarde.',
      duration: Duration(seconds: 5),
      leftBarIndicatorColor: Colors.orange.shade300,
      backgroundColor: Colors.orange.shade300,
      icon: Icon(
        Icons.warning_rounded,
        size: 28,
        color: Colors.white,
      ),
    ).show(context);

    final storage = new FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final String url =
        'https://us-central1-petmatch-firebase-api.cloudfunctions.net/api/pets/$id';
    final response = await http.delete(url, headers: {'x-access-token': token});

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PetsPage()),
      );

      return;
    }

    Flushbar(
      message: 'Houve um erro ao processar as informações.',
      duration: Duration(seconds: 5),
      leftBarIndicatorColor: Colors.red.shade300,
      backgroundColor: Colors.red.shade300,
      icon: Icon(
        Icons.error_outline,
        size: 28,
        color: Colors.white,
      ),
    ).show(context);

    return null;
  }
}
