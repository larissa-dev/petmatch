import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:petmatch/Screens/Login/pages.dart';
import 'package:petmatch/Screens/Login/styles.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  PageController controller;

  var index = 0;
  bool loader = false;

  initState() {
    super.initState();
    controller = new PageController(initialPage: 0, keepPage: true);
  }

  Future<void> _login() async {
    setState(() {
      loader = true;
    });

    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final storage = new FlutterSecureStorage();

    await storage.write(key: 'currentUser', value: jsonEncode({
      'id': googleUser.id,
      'displayName': googleUser.displayName,
      'email': googleUser.email,
      'photoUrl': googleUser.photoUrl,
    }));

    Navigator.of(context).pushNamed('/home');
    setState(() {
      loader = false;
    });
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    Size screenSize = MediaQuery.of(context).size;
    return new Scaffold(
        body: new Container(
      width: screenSize.width,
      height: screenSize.height,
      padding: new EdgeInsets.all(20.0),
      decoration: new BoxDecoration(image: backgroundImage),
      child: new Column(
        //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Container(
            width: screenSize.width,
            height: screenSize.height - 200,
            child: new PageView.builder(
              onPageChanged: (value) {
                setState(() {
                  index = value;
                });
              },
              controller: controller,
              itemCount: pages.length,
              itemBuilder: (context, index) => new Pagee(
                    viewModel: pages[index],
                  ),
            ),
          ),
          new Container(
            width: 120.0,
            height: 20.0,
            margin: new EdgeInsets.only(bottom: 20.0),
            child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: pages.map((item) {
                  return new Container(
                    width: 10.0,
                    height: 10.0,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: pages[index % 4] == item
                            ? Colors.white
                            : Colors.white70),
                  );
                }).toList()),
          ),
          new FlatButton(
            onPressed: _login,
            child: new Container(
              width: 300.0,
              height: 50.0,
              alignment: Alignment.center,
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      new BorderRadius.all(new Radius.circular(50.0))),
              child: !loader
                  ? new Text(
                      "Entre com o Google",
                      style: new TextStyle(
                          fontSize: 15.0,
                          letterSpacing: 1.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w100),
                    )
                  : new CircularProgressIndicator(
                      value: null,
                      strokeWidth: 5.0,
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
            ),
          ),
        ],
      ),
    ));
  }
}
