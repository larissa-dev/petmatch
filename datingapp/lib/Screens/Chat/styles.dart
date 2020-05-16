import 'package:flutter/material.dart';

DecorationImage logo = new DecorationImage(
  image: new ExactAssetImage('assets/first.png'),
  fit: BoxFit.cover,
);
ImageProvider avatar1 = new ExactAssetImage('assets/img1.png');
ImageProvider avatar2 = new ExactAssetImage('assets/img2.jpg');
ImageProvider avatar3 = new ExactAssetImage('assets/img3.jpg');
ImageProvider avatar4 = new ExactAssetImage('assets/img4.jpg');
ImageProvider avatar5 = new ExactAssetImage('assets/img5.jpg');
List avatarData = [avatar1, avatar2, avatar3, avatar4, avatar5];
