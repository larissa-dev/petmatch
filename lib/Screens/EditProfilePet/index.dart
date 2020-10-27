import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:petmatch/Components/profileImages.dart';
import 'package:petmatch/Components/profileInputs.dart';
import 'package:petmatch/Screens/EditProfile/grid.dart';
import 'package:petmatch/theme/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class EditProfilePet extends StatefulWidget {
  @override
  _EditProfilePetState createState() => new _EditProfilePetState();
}

class _EditProfilePetState extends State<EditProfilePet> {
  @override
  void initState() {
    print(ModalRoute.of(context).settings.name);

    super.initState();
  }

  Future<File> _imageFile;
  bool instaValue = true;
  final name = TextEditingController();
  final about = TextEditingController();
  final age = TextEditingController();
  final species = TextEditingController();
  String gender = '';
  String profileName = '(Nome do Perfil)';
  List images = [];
  bool adocao = false;
  bool desaparecidos = false;
  bool cruzamento = false;
  DataListBuilder dataListBuilder = new DataListBuilder();

  getImage(int index) {
    List<GridImage> list = dataListBuilder.gridData;
    print(list[index].url);
    if (list[index].imageFile != null && list[index].url != null) {
      //list[index].imageFile = null;
      setState(() {
        images.removeAt(index);
        _imageFile = null;
      });
    } else {
      _imageFile = ImagePicker.pickImage(source: ImageSource.gallery);

      _imageFile.then((onValue) {
        if (onValue != null) {
          list[index].imageFile = _imageFile;
          setState(() {
            images.add(_imageFile);
            _imageFile = null;
          });
        }
      });
    }
  }

  createPet() async {
    final storage = new FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final String url =
        'https://us-central1-petmatch-firebase-api.cloudfunctions.net/api/pets';
    String status = "";

    if (adocao) {
      status = "adocao";
    }

    if (cruzamento) {
      status = "cruzamento";
    }

    if (desaparecidos) {
      status = "desaparecidos";
    }

    final Map requestBody = {
      'name': name.text,
      'about': about.text,
      'age': age.text,
      'species': species.text,
      'gender': gender,
      'status': status
    };
    print(images);
    print(requestBody);

    final response = await http
        .post(url, body: requestBody, headers: {'x-access-token': token});

    final data = jsonDecode(response.body);

    if (data['success']) {
      Flushbar(
        message: 'Salvo com sucesso.',
        duration: Duration(seconds: 5),
        leftBarIndicatorColor: Colors.green.shade300,
        backgroundColor: Colors.green.shade300,
        icon: Icon(
          Icons.error_outline,
          size: 28,
          color: Colors.white,
        ),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<GridImage> list = dataListBuilder.gridData;
    Size screenSize = MediaQuery.of(context).size;
    return new Scaffold(
      backgroundColor: const Color.fromRGBO(239, 239, 245, 1.0),
      appBar: new AppBar(
        elevation: 2.0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        title: new Text(
          "Editar Perfil",
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
        actions: [
          FlatButton(
              onPressed: () {
                createPet();
              },
              child: Text(
                'Salvar',
                style:
                    new TextStyle(fontSize: 20.0, fontFamily: "PoppinsRegular"),
              ))
        ],
      ),
      body: SingleChildScrollView(
          padding: new EdgeInsets.all(10.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(10.0),
                child: new Text(
                  "Fotos",
                  style: new TextStyle(
                      fontSize: 20.0, fontFamily: "PoppinsRegular"),
                ),
              ),
              new Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: new Text(
                        "Nome",
                        style: new TextStyle(
                            fontSize: 20.0, fontFamily: "PoppinsRegular"),
                      ),
                    ),
                    new Card(
                      elevation: 0.0,
                      child: new TextFormField(
                        controller: name,
                        maxLines: 1,
                        decoration: new InputDecoration(
                          hintText: "Informe o nome:",
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(15.0),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              new Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: new Text(
                        "Sobre",
                        style: new TextStyle(
                            fontSize: 20.0, fontFamily: "PoppinsRegular"),
                      ),
                    ),
                    new Card(
                      elevation: 0.0,
                      child: new TextFormField(
                        controller: about,
                        maxLines: 5,
                        decoration: new InputDecoration(
                          hintText: "Escreva uma pequena descrição...",
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(15.0),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              new Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: new Text(
                        "Idade",
                        style: new TextStyle(
                            fontSize: 20.0, fontFamily: "PoppinsRegular"),
                      ),
                    ),
                    new Card(
                      elevation: 0.0,
                      child: new TextFormField(
                        controller: age,
                        maxLines: 1,
                        decoration: new InputDecoration(
                          hintText: "Informe a idade:",
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(15.0),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              new Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: new Text(
                        "Espécie",
                        style: new TextStyle(
                            fontSize: 20.0, fontFamily: "PoppinsRegular"),
                      ),
                    ),
                    new Card(
                      elevation: 0.0,
                      child: new TextFormField(
                        controller: species,
                        maxLines: 1,
                        decoration: new InputDecoration(
                          hintText: "Informe a espécie:",
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(15.0),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              new Container(
                width: screenSize.width,
                padding: new EdgeInsets.only(top: 12.0, bottom: 12.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    /* new Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new Text("Mostre-me"),
                        ),*/

                    new ListTile(
                      title: new Text(
                        "Categoria",
                        style: new TextStyle(
                            fontSize: 20.0, fontFamily: "PoppinsRegular"),
                      ),
                      //trailing: new Text(_values.start.round().toString() +
                      //  " - " +
                      //_values.end.round().toString()),
                    ),
                    new ListTile(
                      title: new Text("Adoção"),
                      trailing: defaultTargetPlatform == TargetPlatform.android
                          ? new Switch(
                              value: adocao,
                              onChanged: (bool newValue) {
                                setState(() {
                                  adocao = newValue;
                                });
                              },
                              activeColor: gradientOne,
                              activeTrackColor: gradientOne,
                            )
                          : new CupertinoSwitch(
                              value: adocao,
                              onChanged: (bool newValue) {
                                setState(() {
                                  adocao = newValue;
                                });
                              },
                              activeColor: gradientOne,
                            ),
                    ),
                    new ListTile(
                      title: new Text("Desaparecido"),
                      trailing: defaultTargetPlatform == TargetPlatform.android
                          ? new Switch(
                              value: desaparecidos,
                              onChanged: (bool newValue) {
                                setState(() {
                                  desaparecidos = newValue;
                                });
                              },
                              activeColor: gradientOne,
                              activeTrackColor: gradientOne,
                            )
                          : new CupertinoSwitch(
                              value: desaparecidos,
                              onChanged: (bool newValue) {
                                setState(() {
                                  desaparecidos = newValue;
                                });
                              },
                              activeColor: gradientOne,
                            ),
                    ),
                    new ListTile(
                      title: new Text("ruzamento"),
                      trailing: defaultTargetPlatform == TargetPlatform.android
                          ? new Switch(
                              value: cruzamento,
                              onChanged: (bool newValue) {
                                setState(() {
                                  cruzamento = newValue;
                                });
                              },
                              activeColor: gradientOne,
                              activeTrackColor: gradientOne,
                            )
                          : new CupertinoSwitch(
                              value: cruzamento,
                              onChanged: (bool newValue) {
                                setState(() {
                                  cruzamento = newValue;
                                });
                              },
                              activeColor: gradientOne,
                            ),
                    ),
                  ],
                ),
              ),
              new Container(
                margin: const EdgeInsets.only(top: 10.0),
                padding: const EdgeInsets.all(10.0),
                child: new Text(
                  "Sexo",
                  style: new TextStyle(
                      fontSize: 20.0, fontFamily: "PoppinsRegular"),
                ),
              ),
              new Container(
                padding: const EdgeInsets.all(12.0),
                width: screenSize.width,
                height: 100.0,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new GestureDetector(
                      child: new Container(
                        width: 150.0,
                        height: 50.0,
                        alignment: Alignment.center,
                        decoration: new BoxDecoration(
                            border: new Border.all(
                                width: 2.0, color: gradientThree),
                            borderRadius: new BorderRadius.all(
                                new Radius.circular(50.0))),
                        child: new Text(
                          "Masculino",
                          style: new TextStyle(
                              fontSize: 18.0,
                              letterSpacing: 0.6,
                              color: gradientThree,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          gender = 'M';
                        });
                      },
                    ),
                    new GestureDetector(
                      child: Container(
                        width: 150.0,
                        height: 50.0,
                        alignment: Alignment.center,
                        decoration: new BoxDecoration(
                            color: gradientOne,
                            border:
                                new Border.all(width: 2.0, color: gradientOne),
                            borderRadius: new BorderRadius.all(
                                new Radius.circular(50.0))),
                        child: new Text(
                          "Feminino",
                          style: new TextStyle(
                              fontSize: 18.0,
                              letterSpacing: 0.6,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          gender = 'F';
                        });
                      },
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
