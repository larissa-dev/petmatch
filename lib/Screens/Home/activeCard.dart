import 'dart:math';

import 'package:petmatch/Components/swipeButton.dart';
import 'package:petmatch/Screens/Home/detail.dart';

import 'package:flutter/material.dart';

class ActiveCard extends StatelessWidget {
  DecorationImage img;
  double bottom;
  double right;
  double left;
  double cardWidth;
  double rotation;
  double skew;
  Function dismissImg;
  int flag;
  Function addImg;
  Function swipeRight;
  Function swipeLeft;
  String tag;
  Map pet;
  ActiveCard(
      {this.addImg,
      this.bottom,
      this.cardWidth,
      this.dismissImg,
      this.flag,
      this.img,
      this.left,
      this.right,
      this.rotation,
      this.skew,
      this.swipeLeft,
      this.swipeRight,
      this.tag,
      this.pet});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return new Positioned(
        bottom: 80.0 + bottom,
        right: flag == 0
            ? right != 0.0
                ? right
                : null
            : null,
        left: flag == 1
            ? right != 0.0
                ? right
                : null
            : null,
        child: new Dismissible(
          key: new Key(new Random().toString()),
          crossAxisEndOffset: -0.3,
          onResize: () {},
          onDismissed: (direction) {
            dismissImg(pet);
          },
          child: new Transform(
            alignment: flag == 0 ? Alignment.bottomRight : Alignment.bottomLeft,
            //transform: null,
            transform: new Matrix4.skewX(skew),
            //..rotateX(-math.pi / rotation),d
            child: new RotationTransition(
              turns: new AlwaysStoppedAnimation(
                  flag == 0 ? rotation / 360 : -rotation / 360),
              child: new Hero(
                tag: tag,
                child: new GestureDetector(
                  onTap: () {
                    if (!tag.contains("no"))
                      Navigator.of(context).push(new PageRouteBuilder(
                        pageBuilder: (_, __, ___) => new DetailPage(type: img),
                      ));
                  },
                  child: new Card(
                    color: Colors.transparent,
                    elevation: 4.0,
                    child: new Container(
                      alignment: Alignment.center,
                      width: screenSize.width / 1.2 + cardWidth,
                      height: screenSize.height / 1.7,
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.circular(8.0),
                      ),
                      child: new Column(
                        children: <Widget>[
                          new Container(
                            width: screenSize.width / 1.2 + cardWidth,
                            height: screenSize.height / 2.2,
                            decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.only(
                                  topLeft: new Radius.circular(8.0),
                                  topRight: new Radius.circular(8.0)),
                              image: img,
                            ),
                          ),
                          new Container(
                              width: screenSize.width / 1.2 + cardWidth,
                              height: screenSize.height / 1.7 -
                                  screenSize.height / 2.2,
                              alignment: Alignment.center,
                              child: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  new SwipeButton(
                                    text: "NÃO",
                                    onClick: swipeLeft,
                                  ),
                                  new SwipeButton(
                                    text: "SIM",
                                    onClick: swipeRight,
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
