import 'package:datingapp/theme/styles.dart';
import 'package:flutter/material.dart';

const String _name = "Active user";

class ChattingScreen extends StatefulWidget {
  final String name;
  const ChattingScreen({Key key, this.name}) : super(key: key);
  @override
  _ChattingScreenState createState() => new _ChattingScreenState(name: name);
}

class _ChattingScreenState extends State<ChattingScreen>
    with TickerProviderStateMixin {
  String name;
  _ChattingScreenState({this.name});

  final TextEditingController _textController = new TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];
  AnimationController animationController;
  bool _isComposing = false;
  void _handleSubmitted(String text) {
    setState(() {
      _isComposing = false;
    });
    _textController.clear();
    if (text != "") {
      ChatMessage message = new ChatMessage(
        text: text,
        animationController: new AnimationController(
          duration: new Duration(milliseconds: 700),
          vsync: this,
        ),
      );
      setState(() {
        _messages.insert(0, message);
      });
      message.animationController.forward();
    }
  }

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
      duration: new Duration(milliseconds: 700),
      vsync: this,
    );
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: gradientOne),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                onSubmitted: _handleSubmitted,
                decoration:
                    new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: _isComposing
                      ? () => _handleSubmitted(_textController.text)
                      : null,
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          elevation: 2.0,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          title: new Text(
            name.toString(),
            style: new TextStyle(
                color: new Color.fromRGBO(92, 107, 122, 1.0),
                fontSize: 25.0,
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
          leading: new FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: new Image(
                  image: new ExactAssetImage("assets/back-arrow.png"))),
          automaticallyImplyLeading: true,
        ),
        body: new IconTheme(
          data: new IconThemeData(color: gradientOne),
          child: new Column(
            children: <Widget>[
              new Flexible(
                child: new ListView.builder(
                  padding: new EdgeInsets.all(8.0),
                  reverse: true,
                  itemBuilder: (_, int index) => _messages[index],
                  itemCount: _messages.length,
                ),
              ),
              new Divider(height: 1.0),
              new Container(
                decoration:
                    new BoxDecoration(color: Theme.of(context).cardColor),
                child: _buildTextComposer(),
              ),
            ],
          ),
        ));
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});
  final String text;
  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
        sizeFactor: new CurvedAnimation(
            parent: animationController, curve: Curves.easeOut),
        axisAlignment: 0.0,
        child: new Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: new CircleAvatar(
                  child: new Text(_name[0]),
                  backgroundColor: gradientOne,
                ),
              ),
              new Expanded(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(_name, style: Theme.of(context).textTheme.subhead),
                    new Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: new Text(text),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
