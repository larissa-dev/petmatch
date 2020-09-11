import 'dart:async';
import 'dart:io';


import 'package:petmatch/Components/profileImages.dart';
import 'package:petmatch/Components/profileInputs.dart';
import 'package:petmatch/Screens/EditProfile/grid.dart';
import 'package:petmatch/theme/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => new _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  Future<File> _imageFile;
  bool instaValue = true;

  DataListBuilder dataListBuilder = new DataListBuilder();
  getImage(int index) {
    List<GridImage> list = dataListBuilder.gridData;
    if (list[index].imageFile != null) {
      list[index].imageFile = null;
      setState(() {
        _imageFile = null;
      });
    } else {
      _imageFile = ImagePicker.pickImage(source: ImageSource.gallery);

      _imageFile.then((onValue) {
        print(onValue);
        if (onValue != null) {
          list[index].imageFile = _imageFile;
          setState(() {
            _imageFile = null;
          });
        }
      });
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
      ),
      body: new SingleChildScrollView(
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
                    iconOnClick: () {
                      getImage(3);
                    },
                  ),
                ],
              ),
              new ProfileInputs(
                title: "Sobre (Nome do Perfil)",
                placeholder: "Escreva uma pequena descrição sobre você...",
                lines: 5,
              ),

              new ProfileInputs(
                title: "Idade",
                placeholder: "Informe sua idade:",
                lines: 1,
              ),
              
              new ProfileInputs(
                title: "Contato",
                placeholder: "(DDD)X.XXXX-XXXX",
                lines: 1,
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
                    new Container(
                      width: 150.0,
                      height: 50.0,
                      alignment: Alignment.center,
                      decoration: new BoxDecoration(
                          border:
                              new Border.all(width: 2.0, color: gradientThree),
                          borderRadius:
                              new BorderRadius.all(new Radius.circular(50.0))),
                      child: new Text(
                        "Masculino",
                        style: new TextStyle(
                            fontSize: 18.0,
                            letterSpacing: 0.6,
                            color: gradientThree,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    new Container(
                      width: 150.0,
                      height: 50.0,
                      alignment: Alignment.center,
                      decoration: new BoxDecoration(
                          color: gradientOne,
                          border:
                              new Border.all(width: 2.0, color: gradientOne),
                          borderRadius:
                              new BorderRadius.all(new Radius.circular(50.0))),
                      child: new Text(
                        "Feminino",
                        style: new TextStyle(
                            fontSize: 18.0,
                            letterSpacing: 0.6,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
