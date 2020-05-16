import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  var twenty;
  Timer t2;
  String routeName;
  @override
  void initState() {
    super.initState();
    twenty = const Duration(seconds: 3);
    t2 = new Timer(twenty, () {
      routeName = "/login";
      navigate(context, routeName);
    });
  }

  @override
  void dispose() {
    super.dispose();
    t2.cancel();
  }

  navigate(BuildContext context, routename) {
    if (routename != null) {
      Navigator.of(context).pushNamed(routename);
    }
  }

  @override
  Widget build(BuildContext context) {
    return (new Scaffold(
        body: new Container(
      decoration: new BoxDecoration(
          image: new DecorationImage(
        image: new ExactAssetImage('assets/screen.png'),
        fit: BoxFit.cover,
      )),
    )));
  }
}
