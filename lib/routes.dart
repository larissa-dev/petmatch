import 'package:petmatch/Screens/Chat/chatList.dart';
import 'package:petmatch/Screens/Chat/chatting.dart';
import 'package:petmatch/Screens/EditProfile/index.dart';
import 'package:petmatch/Screens/EditProfilePet/pets.dart';
import 'package:petmatch/Screens/Settings/index.dart';
import 'package:petmatch/Screens/Splash/index.dart';
import 'package:petmatch/Screens/TabController/index.dart';

import 'package:petmatch/Screens/Login/index.dart';

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
    "/pets": (BuildContext context) => new PetsPage(),
  };
  Routes() {
    runApp(new MaterialApp(
      title: "PetMatch",
      debugShowCheckedModeBanner: false,
      home: new SplashScreen(),
      routes: routes,
    ));
  }
}
