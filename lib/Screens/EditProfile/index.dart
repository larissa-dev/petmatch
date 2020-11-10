import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:petmatch/Components/profileImages.dart';
import 'package:petmatch/Screens/EditProfile/grid.dart';
import 'package:petmatch/theme/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => new _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File imageFileData;
  bool instaValue = true;
  TextEditingController about = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController phone = TextEditingController();
  String gender;
  String profileName = '(Nome do Perfil)';
  String photoUrl;

  DataListBuilder dataListBuilder = new DataListBuilder();

  Future apiData;

  void initState() {
    apiData = getProfile();

    super.initState();
  }

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

  getProfile() async {
    final storage = new FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final String url =
        'https://us-central1-petmatch-firebase-api.cloudfunctions.net/api/profile';
    final response = await http.get(url, headers: {'x-access-token': token});

    Map data = jsonDecode(response.body);

    if (data['success']) {
      about.text = data['user']['about'];
      age.text =
          data['user']['age'] == null ? '' : data['user']['age'].toString();
      phone.text = data['user']['phone'];
      profileName = data['user']['name'];
      gender = data['user']['gender'];
      photoUrl = data['user']['photo'];
    }

    return jsonDecode(response.body);
  }

  setProfile() async {
    Flushbar(
      message: 'Estamos processando suas informações, aguarde.',
      duration: Duration(seconds: 5),
      leftBarIndicatorColor: Colors.orange.shade300,
      backgroundColor: Colors.orange.shade300,
      icon: Icon(
        Icons.error_outline,
        size: 28,
        color: Colors.white,
      ),
    ).show(context);

    final storage = new FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final storedUser = jsonDecode(await storage.read(key: 'currentUser'));
    final String url =
        'https://us-central1-petmatch-firebase-api.cloudfunctions.net/api/profile';

    if (imageFileData != null) {
      photoUrl = await uploadImage(imageFileData);
    }

    Map requestBody = {
      'about': about.text ?? '',
      'age': age.text ?? 0,
      'phone': phone.text ?? '',
      'gender': gender ?? '',
      'photo': photoUrl ?? ''
    };

    storedUser['photoUrl'] = photoUrl ?? '';

    await storage.write(key: 'currentUser', value: jsonEncode(storedUser));

    final response = await http.put(url,
        body: jsonEncode(requestBody),
        headers: {'x-access-token': token, "Content-Type": "application/json"});

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
              Navigator.of(context).pushNamed("/home");
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
        future: apiData,
        builder: (_context, _snapshot) {
          if (_snapshot.hasData && !_snapshot.data['success']) {
            return Center(
              child: Text('Houve um problema ao trazer suas informações'),
            );
          }

          if (_snapshot.hasData) {
            return new SingleChildScrollView(
                padding: new EdgeInsets.all(10.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: new Text(
                        "Foto",
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
                                  color: gender == 'M' ? gradientThree : Colors.transparent,
                                  border: new Border.all(
                                      width: 2.0, color: gradientThree),
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(50.0))),
                              child: new Text(
                                "Masculino",
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
                                "Feminino",
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
