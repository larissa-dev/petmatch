import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:petmatch/theme/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => new _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool discoverablity = true;
  bool adocao = true;
  bool desaparecidos = true;
  bool cachorro = true;
  bool gato = true;
  bool roedores = true;
  bool passaros = true;
  bool cruzamento = true;
  bool matches = true;
  bool messages = true;
  double distance = 0.0;
  double ageRangeLeft = 0.0;
  double ageRangeRight = 0.0;
  bool loading = false;

  Future settingsData;
  @override
  void initState() {
    settingsData = _getSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return new Scaffold(
        appBar: new AppBar(
          elevation: 2.0,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          title: new Text(
            "Configurações",
            style: new TextStyle(
              color: new Color.fromRGBO(92, 107, 122, 1.0),
              fontSize: 25.0,
              fontFamily: "Poppins",
              //fontWeight: FontWeight.bold
            ),
          ),
          centerTitle: false,
          leading: new FlatButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/home");
              },
              child: new Image(
                  image: new ExactAssetImage("assets/back-arrow.png"))),
          automaticallyImplyLeading: true,
          actions: [
            FlatButton(
                onPressed: () {
                  _saveSettings();
                },
                child: loading ? CircularProgressIndicator() : Text(
                  'Salvar',
                  style: new TextStyle(
                      fontSize: 20.0, fontFamily: "PoppinsRegular"),
                ))
          ],
        ),
        body: FutureBuilder(
          future: settingsData,
          builder: (_context, _snapshot) {
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
                        "Configurações de Buscas (Descobertas)",
                        style: new TextStyle(
                            fontSize: 20.0, fontFamily: "PoppinsRegular"),
                      ),
                    ),
                    new Card(
                        elevation: 3.0,
                        child: new Container(
                          width: screenSize.width,
                          padding: new EdgeInsets.only(top: 12.0, bottom: 12.0),
                          child: new ListTile(
                            title: new Text("Ativar Descoberta"),
                            trailing:
                                defaultTargetPlatform == TargetPlatform.android
                                    ? new Switch(
                                        value: discoverablity,
                                        onChanged: (bool newValue) {
                                          setState(() {
                                            discoverablity = newValue;
                                          });
                                        },
                                        activeColor: gradientOne,
                                        activeTrackColor: gradientOne,
                                      )
                                    : new CupertinoSwitch(
                                        value: discoverablity,
                                        onChanged: (bool newValue) {
                                          setState(() {
                                            discoverablity = newValue;
                                          });
                                        },
                                        activeColor: gradientOne,
                                      ),
                          ),
                        )),
                    new Card(
                        elevation: 3.0,
                        child: new Container(
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
                                title: new Text("Mostre-me"),
                                //trailing: new Text(_values.start.round().toString() +
                                //  " - " +
                                //_values.end.round().toString()),
                              ),
                              new ListTile(
                                title: new Text("Animais para Adoção"),
                                trailing: defaultTargetPlatform ==
                                        TargetPlatform.android
                                    ? new Switch(
                                        value: adocao,
                                        onChanged: (bool newValue) {
                                          setState(() {
                                            adocao = newValue;
                                            cruzamento = false;
                                            desaparecidos = false;
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
                                            cruzamento = false;
                                            desaparecidos = false;
                                          });
                                        },
                                        activeColor: gradientOne,
                                      ),
                              ),
                              new ListTile(
                                title: new Text("Animais Desaparecidos"),
                                trailing: defaultTargetPlatform ==
                                        TargetPlatform.android
                                    ? new Switch(
                                        value: desaparecidos,
                                        onChanged: (bool newValue) {
                                          setState(() {
                                            desaparecidos = newValue;
                                            adocao = false;
                                            cruzamento = false;
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
                                            adocao = false;
                                            cruzamento = false;
                                          });
                                        },
                                        activeColor: gradientOne,
                                      ),
                              ),
                              new ListTile(
                                title: new Text("Animais para cruzamento"),
                                trailing: defaultTargetPlatform ==
                                        TargetPlatform.android
                                    ? new Switch(
                                        value: cruzamento,
                                        onChanged: (bool newValue) {
                                          setState(() {
                                            cruzamento = newValue;
                                            adocao = false;
                                            desaparecidos = false;
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
                                            adocao = false;
                                            desaparecidos = false;
                                          });
                                        },
                                        activeColor: gradientOne,
                                      ),
                              ),
                            ],
                          ),
                        )),
                    new Card(
                        elevation: 3.0,
                        child: new Container(
                          width: screenSize.width,
                          padding: new EdgeInsets.only(top: 12.0, bottom: 12.0),
                          child: new Column(
                            children: <Widget>[
                              new ListTile(
                                title: new Text("Distancia da Busca"),
                                trailing: new Text(
                                    distance.round().toString() + "km."),
                              ),
                              new ListTile(
                                title: new Slider(
                                  activeColor: gradientOne,
                                  inactiveColor: Colors.grey,
                                  max: 100.0,
                                  min: 0.0,
                                  value: distance,
                                  onChanged: (double newValue) {
                                    setState(() {
                                      distance = newValue;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        )),
                    new Card(
                        elevation: 3.0,
                        child: new Container(
                          width: screenSize.width,
                          padding: new EdgeInsets.only(top: 12.0, bottom: 12.0),
                          child: new Column(
                            children: <Widget>[
                              new ListTile(
                                title: new Text("Categorias de Animais"),
                              ),
                              new ListTile(
                                title: new Text("Cães"),
                                trailing: defaultTargetPlatform ==
                                        TargetPlatform.android
                                    ? new Switch(
                                        value: cachorro,
                                        onChanged: (bool newValue) {
                                          setState(() {
                                            cachorro = newValue;
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
                                          });
                                        },
                                        activeColor: gradientOne,
                                      ),
                              ),
                            ],
                          ),
                        )),
                    new Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: new Text(
                        "Configurações do Aplicativo",
                        style: new TextStyle(
                            fontSize: 20.0, fontFamily: "PoppinsRegular"),
                      ),
                    ),
                    new Card(
                        elevation: 3.0,
                        child: new Container(
                          width: screenSize.width,
                          padding: new EdgeInsets.only(top: 12.0, bottom: 12.0),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new ListTile(
                                title: new Text("Notificações"),
                              ),
                              new ListTile(
                                title: new Text("Combinações"),
                                trailing: defaultTargetPlatform ==
                                        TargetPlatform.android
                                    ? new Switch(
                                        value: matches,
                                        onChanged: (bool newValue) {
                                          setState(() {
                                            matches = newValue;
                                          });
                                        },
                                        activeColor: gradientOne,
                                        activeTrackColor: gradientOne,
                                      )
                                    : new CupertinoSwitch(
                                        value: matches,
                                        onChanged: (bool newValue) {
                                          setState(() {
                                            matches = newValue;
                                          });
                                        },
                                        activeColor: gradientOne,
                                      ),
                              ),
                              new ListTile(
                                title: new Text("Mensagens"),
                                trailing: defaultTargetPlatform ==
                                        TargetPlatform.android
                                    ? new Switch(
                                        value: messages,
                                        onChanged: (bool newValue) {
                                          setState(() {
                                            messages = newValue;
                                          });
                                        },
                                        activeColor: gradientOne,
                                        activeTrackColor: gradientOne,
                                      )
                                    : new CupertinoSwitch(
                                        value: messages,
                                        onChanged: (bool newValue) {
                                          setState(() {
                                            messages = newValue;
                                          });
                                        },
                                        activeColor: gradientOne,
                                      ),
                              ),
                            ],
                          ),
                        )),
                    new Container(
                      width: screenSize.width,
                      margin: new EdgeInsets.only(top: 30.0),
                      padding: new EdgeInsets.all(10.0),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new FlatButton(
                            onPressed: () {
                              _logout();
                            },
                            child: new Container(
                                width: 250.0,
                                height: 50.0,
                                margin: new EdgeInsets.only(top: 40.0),
                                alignment: Alignment.center,
                                padding: new EdgeInsets.all(10.0),
                                decoration: new BoxDecoration(
                                    gradient: new LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        gradientOne,
                                        gradientTwo,
                                        gradientThree
                                      ],
                                      tileMode: TileMode.repeated,
                                    ),
                                    borderRadius: new BorderRadius.all(
                                        new Radius.circular(50.0))),
                                child: new Text(
                                  "LOGOUT",
                                  style: new TextStyle(
                                      fontSize: 18.0,
                                      letterSpacing: 0.6,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400),
                                )),
                          ),
                          new FlatButton(
                            onPressed: () {
                              _deleteAccountConfirmation();
                            },
                            child: new Container(
                                width: 250.0,
                                height: 50.0,
                                margin: new EdgeInsets.only(
                                    top: 40.0, bottom: 40.0),
                                alignment: Alignment.center,
                                padding: new EdgeInsets.all(10.0),
                                decoration: new BoxDecoration(
                                    border: new Border.all(
                                        color: gradientTwo, width: 2.0),
                                    color: Colors.white,
                                    borderRadius: new BorderRadius.all(
                                        new Radius.circular(50.0))),
                                child: new Text(
                                  "DELETAR CONTA",
                                  style: new TextStyle(
                                      fontSize: 18.0,
                                      letterSpacing: 0.6,
                                      color: gradientTwo,
                                      fontWeight: FontWeight.w400),
                                )),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }

  _logout() async {
    final storage = new FlutterSecureStorage();

    await storage.delete(key: 'currentUser');
    await storage.delete(key: 'token');

    Navigator.of(context)
        .pushNamedAndRemoveUntil("/login", ModalRoute.withName('/login'));
  }

  _deleteAccountConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Deletar Conta?"),
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
              onPressed: () async {
                await _deleteAccount();
              },
            ),
          ],
        );
      },
    );
  }

  _deleteAccount() async {
    final url =
        'https://us-central1-petmatch-firebase-api.cloudfunctions.net/api/profile';
    final storage = new FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    final response = await http
        .delete(url, headers: {'x-access-token': token});

    final data = jsonDecode(response.body);

    if (data['success']) {
      _logout();
    }
  }

  _saveSettings() async {
    setState(() {
      loading = true;
    });
    final categories = [];

    if (cachorro) {
      categories.add('cachorro');
    }

    if (gato) {
      categories.add('gato');
    }

    if (roedores) {
      categories.add('roedores');
    }

    if (passaros) {
      categories.add('passaros');
    }

    List searchBy = [];

    if (cruzamento) {
      searchBy.add('Cruzamento');
    }

    if (adocao) {
      searchBy.add('Adoção');
    }

    if (desaparecidos) {
      searchBy.add('Desaparecido');
    }

    final url =
        'https://us-central1-petmatch-firebase-api.cloudfunctions.net/api/settings';
    final storage = new FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final requestBody = {
      'active': discoverablity ? '1' : '0',
      'search_by': jsonEncode(searchBy),
      'distance': distance.toString(),
      'categories': jsonEncode(categories),
      'notifications_matches': matches ? '1' : '0',
      'notifications_messages': messages ? '1' : '0'
    };

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

      Navigator.of(context).pushNamed("/home");
    } else {
      Flushbar(
        message: 'Erro ao salvar as informações.',
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

    setState(() {
      loading = false;
    });
  }

  _getSettings() async {
    final url =
        'https://us-central1-petmatch-firebase-api.cloudfunctions.net/api/settings';
    final storage = new FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final response = await http.get(url, headers: {'x-access-token': token});
    final data = jsonDecode(response.body);

    if (data['settings'] != null) {
      List categories = data['settings']['categories'].runtimeType == String
        ? jsonDecode(data['settings']['categories'])
        : data['settings']['categories'];
      List searchBy = data['settings']['search_by'].runtimeType == String
        ? jsonDecode(data['settings']['search_by'])
        : data['settings']['search_by'];

      discoverablity = data['settings']['active'] == 1;
      cruzamento = searchBy.contains('Cruzamento');
      adocao = searchBy.contains('Adoção');
      desaparecidos = searchBy.contains('Desaparecido');
      distance = double.parse(data['settings']['distance'].toString());
      cachorro = categories.contains('cachorro');
      gato = categories.contains('gato');
      roedores = categories.contains('roedores');
      passaros = categories.contains('passaros');
      matches = data['settings']['notifications_matches'] == 1;
      messages = data['settings']['notifications_messages'] == 1;
    }

    return data;
  }
}
