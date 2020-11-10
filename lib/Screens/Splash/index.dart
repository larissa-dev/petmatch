import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:petmatch/Screens/TabController/index.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  Future<bool> isUserLoggedIn;

  var twenty;
  Timer t2;
  String routeName;
  @override
  void initState() {
    isUserLoggedIn = _checkUserLogin();

    twenty = const Duration(seconds: 3);
    t2 = new Timer(twenty, () {
      navigate(context, routeName);
    });
    
    super.initState();
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

  Future<bool> _checkUserLogin() async {
    final storage = new FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    if (token == null) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
      future: Future.wait([_initialization, isUserLoggedIn]),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          routeName = snapshot.data[1] ? '/home' : '/login';
        } 

        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage('assets/screen.png'),
              fit: BoxFit.cover,
            )
          ),
        );
      },
    ));
  }
}
