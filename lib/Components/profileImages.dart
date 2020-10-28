import 'dart:io';

import 'package:petmatch/theme/styles.dart';
import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final double margin;
  final double width;
  final double height;
  final String numtext;
  final Function iconOnClick;
  final File imageFile;
  final String imageUrl;
  ProfileImage(
      {this.imageFile,
      this.imageUrl,
      this.margin,
      this.width,
      this.height,
      this.numtext,
      this.iconOnClick});

  List<Widget> _buildImageCard() {
    List<Widget> list = [];

    if (imageFile != null) {
      list.add(Image.file(
        imageFile,
        width: width,
        height: height,
        fit: BoxFit.cover,
      ));
    } else if (imageUrl != null) {
      list.add(Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
      ));
    }

    list.add(new Container(
      width: 25.0,
      height: 25.0,
      margin: new EdgeInsets.all(8.0),
      alignment: Alignment.center,
      decoration:
          new BoxDecoration(shape: BoxShape.circle, color: Colors.white),
      child: new Text(numtext),
    ));

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        new Container(
          margin: new EdgeInsets.all(margin),
          width: width,
          height: height,
          decoration: new BoxDecoration(color: Colors.grey),
          child: new Stack(
            alignment: Alignment.topRight,
            children: _buildImageCard(),
          ),
        ),
        new InkWell(
          onTap: iconOnClick,
          child: new Container(
            width: 30.0,
            height: 30.0,
            margin: new EdgeInsets.only(top: 20.0),
            alignment: Alignment.center,
            decoration:
                new BoxDecoration(shape: BoxShape.circle, color: gradientThree),
            child: new Icon(
              imageFile == null && imageUrl == null ? Icons.add : Icons.cancel,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
