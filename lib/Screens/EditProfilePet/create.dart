import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:petmatch/Components/profileImages.dart';
import 'package:petmatch/Screens/EditProfile/grid.dart';
import 'package:petmatch/Screens/EditProfilePet/pets.dart';
import 'package:petmatch/theme/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class CreatePet extends StatefulWidget {
  @override
  _CreatePetState createState() => new _CreatePetState();
}

class _CreatePetState extends State<CreatePet> {
  File imageFileData;
  bool instaValue = true;
  final about = TextEditingController();
  final age = TextEditingController();
  String gender = '';
  String profileName = '(Nome do Perfil)';
  String photoUrl = '';

  DataListBuilder dataListBuilder = new DataListBuilder();

  bool cruzamento = false;

  bool desaparecidos = false;

  bool adocao = false;

  final species = TextEditingController();

  final name = TextEditingController();

  bool cachorro = false;

  bool gato = false;

  bool passaros = false;

  bool roedores = false;

  bool loading = false;

  getImage() async {
    try {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          imageFileData = image;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> uploadImage(File imageToUpload) async {
    var imageFileName = DateTime.now().millisecondsSinceEpoch.toString();

    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(imageFileName);

    StorageUploadTask uploadTask = firebaseStorageRef.putFile(imageToUpload);

    StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;

    var downloadUrl = await storageSnapshot.ref.getDownloadURL();

    if (uploadTask.isComplete) {
      var url = downloadUrl.toString();

      return url;
    }

    return null;
  }

  setPet() async {
    setState(() {
      loading = true;
    });
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
        'https://us-central1-petmatch-firebase-api.cloudfunctions.net/api/pets';

    if (imageFileData != null) {
      photoUrl = await uploadImage(imageFileData);
    }

    String type = '';
    String category = '';

    if (cruzamento) {
      category = 'Cruzamento';
    }

    if (adocao) {
      category = 'Adoção';
    }

    if (desaparecidos) {
      category = 'Desaparecido';
    }

    if (cachorro) {
      type = 'Cachorro';
    }

    if (gato) {
      type = 'Gato';
    }

    if (passaros) {
      type = 'Passaro';
    }

    if (roedores) {
      type = 'Roedor';
    }

    Map requestBody = {
      'about': about.text ?? '',
      'age': age.text ?? null,
      'gender': gender ?? '',
      'photo': photoUrl ?? '',
      'type': type,
      'category': category,
      'species': species.text,
      'name': name.text
    };

    final response = await http
        .post(url, body: requestBody, headers: {'x-access-token': token});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['success']) {
        Flushbar(
          message: 'Salvo com sucesso.',
          duration: Duration(seconds: 5),
          leftBarIndicatorColor: Colors.green.shade300,
          backgroundColor: Colors.green.shade300,
          icon: Icon(
            Icons.check,
            size: 28,
            color: Colors.white,
          ),
        ).show(context);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PetsPage()),
        );

        setState(() {
          loading = false;
        });

        return;
      }

      setState(() {
        loading = false;
      });
    }

    Flushbar(
      message: 'Houve um problema ao salvar as informações.',
      duration: Duration(seconds: 5),
      leftBarIndicatorColor: Colors.red.shade300,
      backgroundColor: Colors.red.shade300,
      icon: Icon(
        Icons.error_outline,
        size: 28,
        color: Colors.white,
      ),
    ).show(context);
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
            "Criar Pet",
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
                Navigator.of(context).pushNamed("/pets");
              },
              child: new Image(
                  image: new ExactAssetImage("assets/back-arrow.png"))),
          automaticallyImplyLeading: true,
          actions: [
            FlatButton(
                onPressed: () {
                  setPet();
                },
                child: loading ? CircularProgressIndicator() : Text(
                  'Salvar',
                  style: new TextStyle(
                      fontSize: 20.0, fontFamily: "PoppinsRegular"),
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
                new Row(
                  //  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    new ProfileImage(
                      margin: 10.0,
                      width: 200.0,
                      height: 280.0,
                      numtext: "1",
                      imageFile: imageFileData,
                      imageUrl: photoUrl.length > 0 ? photoUrl : null,
                      iconOnClick: () {
                        getImage();
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
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      new Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: new Text(
                          "Espécie",
                          style: new TextStyle(
                              fontSize: 20.0, fontFamily: "PoppinsRegular"),
                        ),
                      ),
                      new Container(
                        width: screenSize.width,
                        padding: new EdgeInsets.only(top: 12.0, bottom: 12.0),
                        child: new Column(
                          children: <Widget>[
                            new ListTile(
                              title: new Text("Cães"),
                              trailing: defaultTargetPlatform ==
                                      TargetPlatform.android
                                  ? new Switch(
                                      value: cachorro,
                                      onChanged: (bool newValue) {
                                        setState(() {
                                          cachorro = newValue;
                                          if (newValue) {
                                            gato = false;
                                            roedores = false;
                                            passaros = false;
                                          }
                                        });
                                      },
                                      activeColor: gradientOne,
                                      activeTrackColor: gradientOne,
                                    )
                                  : new CupertinoSwitch(
                                      value: cachorro,
                                      onChanged: (bool newValue) {
                                        setState(() {
                                          cachorro = newValue;
                                          if (newValue) {
                                            gato = false;
                                            roedores = false;
                                            passaros = false;
                                          }
                                        });
                                      },
                                      activeColor: gradientOne,
                                    ),
                            ),
                            new ListTile(
                              title: new Text("Gatos"),
                              trailing: defaultTargetPlatform ==
                                      TargetPlatform.android
                                  ? new Switch(
                                      value: gato,
                                      onChanged: (bool newValue) {
                                        setState(() {
                                          gato = newValue;
                                          if (newValue) {
                                            cachorro = false;
                                            roedores = false;
                                            passaros = false;
                                          }
                                        });
                                      },
                                      activeColor: gradientOne,
                                      activeTrackColor: gradientOne,
                                    )
                                  : new CupertinoSwitch(
                                      value: gato,
                                      onChanged: (bool newValue) {
                                        setState(() {
                                          gato = newValue;
                                          if (newValue) {
                                            cachorro = false;
                                            roedores = false;
                                            passaros = false;
                                          }
                                        });
                                      },
                                      activeColor: gradientOne,
                                    ),
                            ),
                            new ListTile(
                              title: new Text("Pássaros"),
                              trailing: defaultTargetPlatform ==
                                      TargetPlatform.android
                                  ? new Switch(
                                      value: passaros,
                                      onChanged: (bool newValue) {
                                        setState(() {
                                          passaros = newValue;
                                          if (newValue) {
                                            cachorro = false;
                                            roedores = false;
                                            gato = false;
                                          }
                                        });
                                      },
                                      activeColor: gradientOne,
                                      activeTrackColor: gradientOne,
                                    )
                                  : new CupertinoSwitch(
                                      value: passaros,
                                      onChanged: (bool newValue) {
                                        setState(() {
                                          passaros = newValue;
                                          if (newValue) {
                                            cachorro = false;
                                            roedores = false;
                                            gato = false;
                                          }
                                        });
                                      },
                                      activeColor: gradientOne,
                                    ),
                            ),
                            new ListTile(
                              title: new Text("Roedores"),
                              trailing: defaultTargetPlatform ==
                                      TargetPlatform.android
                                  ? new Switch(
                                      value: roedores,
                                      onChanged: (bool newValue) {
                                        setState(() {
                                          roedores = newValue;
                                          if (newValue) {
                                            cachorro = false;
                                            gato = false;
                                            passaros = false;
                                          }
                                        });
                                      },
                                      activeColor: gradientOne,
                                      activeTrackColor: gradientOne,
                                    )
                                  : new CupertinoSwitch(
                                      value: roedores,
                                      onChanged: (bool newValue) {
                                        setState(() {
                                          roedores = newValue;
                                          if (newValue) {
                                            cachorro = false;
                                            gato = false;
                                            passaros = false;
                                          }
                                        });
                                      },
                                      activeColor: gradientOne,
                                    ),
                            ),
                          ],
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
                          "Raça",
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
                            hintText: "Informe a raça:",
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
                      new ListTile(
                        title: new Text(
                          "Categoria",
                          style: new TextStyle(
                              fontSize: 20.0, fontFamily: "PoppinsRegular"),
                        ),
                      ),
                      new ListTile(
                        title: new Text("Adoção"),
                        trailing:
                            defaultTargetPlatform == TargetPlatform.android
                                ? new Switch(
                                    value: adocao,
                                    onChanged: (bool newValue) {
                                      setState(() {
                                        adocao = newValue;
                                        if (newValue) {
                                          desaparecidos = false;
                                          cruzamento = false;
                                        }
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
                                        if (newValue) {
                                          desaparecidos = false;
                                          cruzamento = false;
                                        }
                                      });
                                    },
                                    activeColor: gradientOne,
                                  ),
                      ),
                      new ListTile(
                        title: new Text("Desaparecido"),
                        trailing:
                            defaultTargetPlatform == TargetPlatform.android
                                ? new Switch(
                                    value: desaparecidos,
                                    onChanged: (bool newValue) {
                                      setState(() {
                                        desaparecidos = newValue;
                                        if (newValue) {
                                          adocao = false;
                                          cruzamento = false;
                                        }
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
                                        if (newValue) {
                                          adocao = false;
                                          cruzamento = false;
                                        }
                                      });
                                    },
                                    activeColor: gradientOne,
                                  ),
                      ),
                      new ListTile(
                        title: new Text("Cruzamento"),
                        trailing:
                            defaultTargetPlatform == TargetPlatform.android
                                ? new Switch(
                                    value: cruzamento,
                                    onChanged: (bool newValue) {
                                      setState(() {
                                        cruzamento = newValue;
                                        if (newValue) {
                                          adocao = false;
                                          desaparecidos = false;
                                        }
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
                                        if (newValue) {
                                          adocao = false;
                                          desaparecidos = false;
                                        }
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
                                  color: gender == 'M' ? gradientThree : Colors.transparent,
                                  border: new Border.all(
                                      width: 2.0, color: gradientThree),
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(50.0))),
                              child: new Text(
                                "Macho",
                                style: new TextStyle(
                                    fontSize: 18.0,
                                    letterSpacing: 0.6,
                                    color: gender == 'M' ? Colors.white : gradientThree,
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
                                  color: gender == 'F' ? gradientOne : Colors.transparent,
                                  border: new Border.all(
                                      width: 2.0, color: gradientOne),
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(50.0))),
                              child: new Text(
                                "Fêmea",
                                style: new TextStyle(
                                    fontSize: 18.0,
                                    letterSpacing: 0.6,
                                    color: gender == 'F' ? Colors.white : gradientOne,
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
            )));
  }
}
