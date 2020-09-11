import 'package:datingapp/Screens/Chat/chatList.dart';
import 'package:datingapp/Screens/Chat/chatting.dart';
import 'package:datingapp/Screens/EditProfile/index.dart';
import 'package:datingapp/Screens/Settings/index.dart';
import 'package:datingapp/Screens/Splash/index.dart';
import 'package:datingapp/Screens/TabController/index.dart';

import 'package:datingapp/Screens/Login/index.dart';

import 'package:flutter/material.dart';

class Routes {
  var routes = <String, WidgetBuilder>{
    "/splash": (BuildContext context) => new SplashScreen(),
    "/login": (BuildContext context) => new Login(),
    "/home": (BuildContext context) => new Home(),
    "/settings": (BuildContext context) => new Settings(),
    "/profile": (BuildContext context) => new EditProfile(),
    "/chatList": (BuildContext context) => new ChatList(),
    "/chatScreen": (BuildContext context) => new ChattingScreen(),
  };
  Routes() {
    runApp(new MaterialApp(
      title: "Flutter Do App",
      debugShowCheckedModeBanner: false,
      home: new SplashScreen(),
      routes: routes,
    ));
  }
}
