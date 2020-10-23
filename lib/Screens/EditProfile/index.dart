import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flushbar/flushbar.dart';
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

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => new _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  Future<File> _imageFile;
  bool instaValue = true;
  final about = TextEditingController();
  final age = TextEditingController();
  final phone = TextEditingController();
  String gender = '';
  String profileName = '(Nome do Perfil)';
  List images = [];

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

  getProfile() async {
    final storage = new FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final String url =
        'https://us-central1-petmatch-firebase-api.cloudfunctions.net/api/profile';
    final response = await http.get(url, headers: {'x-access-token': token});

    Map data = jsonDecode(response.body);

    if (data['success']) {
      about.text = data['user']['about'];
      age.text = data['user']['age'].toString();
      phone.text = data['user']['phone'];
      profileName = data['user']['name'];
      gender = data['user']['gender'];
      images = data['user']['pictures'];

      print(images);
    }

    return jsonDecode(response.body);
  }

  setProfile() async {
    final storage = new FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final String url =
        'https://us-central1-petmatch-firebase-api.cloudfunctions.net/api/profile';

    final Map requestBody = {
      'about': about.text ?? '',
      'age': age.text ?? '',
      'phone': phone.text ?? '',
      'gender': gender ?? '',
    };
    print(images);
    print(requestBody);

    final response = await http
        .put(url, body: requestBody, headers: {'x-access-token': token});

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
                setProfile();
              },
              child: Text(
                'Salvar',
                style:
                    new TextStyle(fontSize: 20.0, fontFamily: "PoppinsRegular"),
              ))
        ],
      ),
      body: FutureBuilder(
        future: getProfile(),
        builder: (_context, _snaopshot) {
          if (_snaopshot.hasData) {
            return new SingleChildScrollView(
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
                    new Row(
                      //  mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        new ProfileImage(
                          margin: 10.0,
                          width: 200.0,
                          height: 280.0,
                          numtext: "1",
                          imageFile: list[0].imageFile,
                          imageUrl:
                              _snaopshot.data['user']['pictures'].length > 0
                                  ? _snaopshot.data['user']['pictures'][0]
                                  : null,
                          iconOnClick: () {
                            getImage(0);
                          },
                        ),
                        new Column(
                          children: <Widget>[
                            new ProfileImage(
                              margin: 10.0,
                              width: 90.0,
                              height: 130.0,
                              numtext: "2",
                              imageFile: list[1].imageFile,
                              imageUrl:
                                  _snaopshot.data['user']['pictures'].length > 1
                                      ? _snaopshot.data['user']['pictures'][1]
                                      : null,
                              iconOnClick: () {
                                getImage(1);
                              },
                            ),
                            new ProfileImage(
                              margin: 10.0,
                              width: 90.0,
                              height: 130.0,
                              numtext: "3",
                              imageFile: list[2].imageFile,
                              imageUrl:
                                  _snaopshot.data['user']['pictures'].length > 1
                                      ? _snaopshot.data['user']['pictures'][2]
                                      : null,
                              iconOnClick: () {
                                getImage(2);
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                    new Row(
                      children: <Widget>[
                        new ProfileImage(
                          margin: 10.0,
                          width: 90.0,
                          height: 130.0,
                          numtext: "6",
                          imageFile: list[5].imageFile,
                          imageUrl:
                              _snaopshot.data['user']['pictures'].length > 4
                                  ? _snaopshot.data['user']['pictures'][5]
                                  : null,
                          iconOnClick: () {
                            getImage(5);
                          },
                        ),
                        new ProfileImage(
                          margin: 10.0,
                          width: 90.0,
                          height: 130.0,
                          numtext: "5",
                          imageFile: list[4].imageFile,
                          imageUrl:
                              _snaopshot.data['user']['pictures'].length > 3
                                  ? _snaopshot.data['user']['pictures'][4]
                                  : null,
                          iconOnClick: () {
                            getImage(4);
                          },
                        ),
                        new ProfileImage(
                          margin: 10.0,
                          width: 90.0,
                          height: 130.0,
                          numtext: "4",
                          imageFile: list[3].imageFile,
                          imageUrl:
                              _snaopshot.data['user']['pictures'].length > 2
                                  ? _snaopshot.data['user']['pictures'][3]
                                  : null,
                          iconOnClick: () {
                            getImage(3);
                          },
                        ),
                      ],
                    ),
                    new Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: new Text(
                              "Sobre " + profileName,
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
                                hintText:
                                    "Escreva uma pequena descrição sobre você...",
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
                                hintText: "Informe sua idade:",
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
                              "Contato",
                              style: new TextStyle(
                                  fontSize: 20.0, fontFamily: "PoppinsRegular"),
                            ),
                          ),
                          new Card(
                            elevation: 0.0,
                            child: new TextFormField(
                              controller: phone,
                              maxLines: 1,
                              decoration: new InputDecoration(
                                hintText: "(DDD)X.XXXX-XXXX",
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
                                  border: new Border.all(
                                      width: 2.0, color: gradientOne),
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
                ));
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
