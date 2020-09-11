import 'package:petmatch/Components/swipeButton.dart';
import 'package:petmatch/Screens/Home/data.dart';
import 'package:petmatch/theme/styles.dart';

import 'package:flutter/material.dart';

import 'package:flutter/scheduler.dart';

class DetailPage extends StatefulWidget {
  final DecorationImage type;

  const DetailPage({Key key, this.type}) : super(key: key);

  @override
  _DetailPageState createState() => new _DetailPageState(type: type);
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class _DetailPageState extends State<DetailPage> with TickerProviderStateMixin {
  AnimationController _containerController;
  Animation<double> width;
  DecorationImage type;

  _DetailPageState({this.type});

  List data = imageData;
  List name = nameData;
  double _appBarHeight = 256.0;
  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;

  void initState() {
    _containerController = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);
    super.initState();
    width = new Tween<double>(
      begin: 200.0,
      end: 220.0,
    ).animate(
      new CurvedAnimation(
        parent: _containerController,
        curve: Curves.ease,
      ),
    );

    width.addListener(() {
      setState(() {
        if (width.isCompleted) {}
      });
    });
    _containerController.forward();
  }

  @override
  void dispose() {
    _containerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.7;
    return new Theme(
      data: new ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color.fromRGBO(239, 239, 245, 1.0),
        platform: Theme
            .of(context)
            .platform,
      ),
      child: new Container(
        width: width.value,
        height: 400.0,
        color: const Color.fromRGBO(239, 239, 245, 1.0),
        child: new Hero(
          tag: "img" + data.indexOf(type).toString(),
          child: new Card(
            margin: new EdgeInsets.all(0.0),
            color: Colors.transparent,
            child: new Container(
              alignment: Alignment.center,
              width: width.value,
              height: 400.0,
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.circular(10.0),
              ),
              child: new Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  new CustomScrollView(
                    shrinkWrap: false,
                    slivers: <Widget>[
                      new SliverAppBar(
                        elevation: 0.0,
                        forceElevated: true,
                        leading: new IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: new Icon(
                            Icons.arrow_back,
                            color: gradientOne,
                            size: 30.0,
                          ),
                        ),
                        expandedHeight: _appBarHeight,
                        pinned: _appBarBehavior == AppBarBehavior.pinned,
                        floating: _appBarBehavior == AppBarBehavior.floating ||
                            _appBarBehavior == AppBarBehavior.snapping,
                        snap: _appBarBehavior == AppBarBehavior.snapping,
                        flexibleSpace: new FlexibleSpaceBar(
                          title: new Text(
                            name[data.indexOf(type)],
                            style: new TextStyle(
                              color: new Color.fromRGBO(92, 107, 122, 1.0),
                              fontSize: 25.0,
                            ),
                          ),
                          background: new Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              new Container(
                                width: width.value,
                                height: _appBarHeight,
                                decoration: new BoxDecoration(
                                  image: data[data.indexOf(type)],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      new SliverList(
                        delegate: new SliverChildListDelegate(<Widget>[
                          new Container(
                            color: Colors.white,
                            child: new Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 35.0),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Container(
                                    padding: new EdgeInsets.only(bottom: 10.0),
                                    alignment: Alignment.center,
                                    decoration: new BoxDecoration(
                                        color: Colors.white,
                                        border: new Border(
                                            bottom: new BorderSide(
                                                color: Colors.black12))),
                                    child: new Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        new Row(
                                          children: <Widget>[
                                            new Icon(
                                              Icons.pets,
                                              color: gradientOne,
                                            ),
                                            new Padding(
                                              padding:
                                              const EdgeInsets.all(4.0),
                                              child: new Text("Raça: "),
                                            )
                                          ],
                                        ),
                                        new Row(
                                          children: <Widget>[
                                            new Icon(
                                              Icons.map,
                                              color: gradientOne,
                                            ),
                                            new Padding(
                                              padding:
                                              const EdgeInsets.all(8.0),
                                              child: new Text("Distancia km"),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  new Padding(
                                    padding: const EdgeInsets.only(
                                        top: 16.0, bottom: 8.0),
                                    child: new Text(
                                      "Descrição (Sobre o animal)",
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  new Text(
                                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed the eiusmod tempor incidid ut labore et dolore magna aliqua."),
                                  new Container(
                                    margin: new EdgeInsets.only(top: 25.0),
                                    padding: new EdgeInsets.only(
                                        top: 5.0, bottom: 10.0),
                                    height: 120.0,
                                    decoration: new BoxDecoration(
                                        color: Colors.white,
                                        border: new Border(
                                            top: new BorderSide(
                                                color: Colors.black12))),
                                    child: new Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new Text(
                                          "Interesses",   //será exibido a(s) categoria(s) que o animal está cadastrado. 
                                          style: new TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        new Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                          // crossAxisAlignment:
                                          //     CrossAxisAlignment.start,
                                          children: <Widget>[
                                            new Container(
                                              width: 70.0,
                                              height: 30.0,
                                              alignment: Alignment.center,
                                              decoration: new BoxDecoration(
                                                  color: gradientOne,
                                                  borderRadius:
                                                  new BorderRadius.all(
                                                      new Radius.circular(
                                                          30.0))),
                                              child: new Text(
                                                "Adoção",
                                                style: new TextStyle(
                                                    fontSize: 15.0,
                                                    color: Colors.white,
                                                    fontWeight:
                                                    FontWeight.w400),
                                              ),
                                            ),
                                            new Container(
                                              width: 100.0,
                                              height: 30.0,
                                              alignment: Alignment.center,
                                              decoration: new BoxDecoration(
                                                  color: gradientOne,
                                                  borderRadius:
                                                  new BorderRadius.all(
                                                      new Radius.circular(
                                                          30.0))),
                                              child: new Text(
                                                "Cruzamento",
                                                style: new TextStyle(
                                                    fontSize: 15.0,
                                                    color: Colors.white,
                                                    fontWeight:
                                                    FontWeight.w400),
                                              ),
                                            ),
                                            new Container(
                                              width: 110.0,
                                              height: 30.0,
                                              alignment: Alignment.center,
                                              decoration: new BoxDecoration(
                                                  color: gradientOne,
                                                  borderRadius:
                                                  new BorderRadius.all(
                                                      new Radius.circular(
                                                          30.0))),
                                              child: new Text(
                                                "Desaparecidos",
                                                style: new TextStyle(
                                                    fontSize: 15.0,
                                                    color: Colors.white,
                                                    fontWeight:
                                                    FontWeight.w400),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  new Container(
                                    height: 250.0,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                  
                  new Container(
                      width: 600.0,
                      height: 80.0,
                      decoration: new BoxDecoration(
                        color: const Color.fromRGBO(239, 239, 245, 1.0),
                      ),
                      alignment: Alignment.center,
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new SwipeButton(
                            text: "NÃO",
                            onClick: () {},
                          ),
                          new SwipeButton(
                            text: "SIM",
                            onClick: () {},
                          ),
                        ],
                      ))

            /*new FlatButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/settings");
              },
              child: new Container(
                  width: 200.0,
                  height: 50.0,
                  margin: new EdgeInsets.only(top: 20.0),
                  alignment: Alignment.center,
                  padding: new EdgeInsets.all(10.0),
                  decoration: new BoxDecoration(
                      gradient: new LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [gradientOne, gradientTwo, gradientThree],
                        tileMode: TileMode.repeated,
                      ),
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(50.0))),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                      new Text(
                        "Configurações",
                        style: new TextStyle(
                            fontSize: 18.0,
                            letterSpacing: 0.6,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  )),
            ),*/




                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
