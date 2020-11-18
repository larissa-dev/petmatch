import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChattingScreen extends StatefulWidget {
  final String name;
  
  final String currentUserUid;
  
  final String peerId;

  final String peerAvatar;
  
  const ChattingScreen({Key key, this.name, this.currentUserUid, this.peerId, this .peerAvatar}) : super(key: key);
  
  @override
  _ChattingScreenState createState() => new _ChattingScreenState(name: name);
}

class _ChattingScreenState extends State<ChattingScreen>
    with TickerProviderStateMixin {
  
  final TextEditingController _textController = new TextEditingController();

  final ScrollController listScrollController = new ScrollController();

  final FocusNode focusNode = FocusNode();
  
  String name;
  
  _ChattingScreenState({this.name});

  AnimationController animationController;

  String groupChatId;

  List listMessage;

  bool isLoading = false;

  int _limit = 20;

  int _limitIncrement = 20;

  final themeColor = Color(0xfff5a623);
  final primaryColor = Color(0xff203152);
  final greyColor = Color(0xffaeaeae);
  final greyColor2 = Color(0xffE8E8E8);

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
      duration: new Duration(milliseconds: 700),
      vsync: this,
    );

    listScrollController.addListener(_scrollListener);

    readLocal();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      print("reach the bottom");
      setState(() {
        print("reach the bottom");
        _limit += _limitIncrement;
      });
    }
    if (listScrollController.offset <=
            listScrollController.position.minScrollExtent &&
        !listScrollController.position.outOfRange) {
      print("reach the top");
      setState(() {
        print("reach the top");
      });
    }
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
      body: WillPopScope(
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                // List of messages
                Expanded(
                  child: buildListMessage(),
                ),

                // Input content
                buildInput(),
              ],
            ),

            // Loading
            buildLoading()
          ],
        ),
        onWillPop: onBackPress,
      )
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading ? const Center(child: CircularProgressIndicator()) : Container(),
    );
  }

  Future<bool> onBackPress() {
    FirebaseFirestore.instance
      .collection('users')
      .doc(widget.currentUserUid)
      .update({'chattingWith': null});

      Navigator.pop(context);

    return Future.value(false);
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                onSubmitted: (value) {
                  _onSendMessage(_textController.text, 0);
                },
                style: TextStyle(color: primaryColor, fontSize: 15.0),
                controller: _textController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: greyColor),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => _onSendMessage(_textController.text, 0),
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: greyColor2, width: 0.5)),
          color: Colors.white),
    );
  }


  Widget buildListMessage() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .orderBy('timestamp', descending: true)
          .limit(100)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)));
        } else {
          listMessage = snapshot.data.documents;
          return ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemBuilder: (context, index) => buildItem(index, snapshot.data.documents[index]),
            itemCount: snapshot.data.documents.length,
            reverse: true,
            controller: listScrollController,
          );
        }
      },
    );
  }

  void _onSendMessage(String content, int type) {
  // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      _textController.clear();

      var documentReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'idFrom': widget.currentUserUid,
            'idTo': widget.peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type
          },
        );
      });
      listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      // Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (document.data()['idFrom'] == widget.currentUserUid) {
      return Row(
        children: [
          Container(
            child: Text(
              document.data()['content'],
              style: TextStyle(color: primaryColor),
            ),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            width: 200.0,
            decoration: BoxDecoration(
                color: Color(0xffE8E8E8),
                borderRadius: BorderRadius.circular(8.0)),
            margin: EdgeInsets.only(
                bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                right: 10.0),
          )
        ],
      );
    } else {
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                isLastMessageLeft(index)
                  ? Material(
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          child: CircularProgressIndicator(
                            strokeWidth: 1.0,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Color(0xfff5a623)),
                          ),
                          width: 35.0,
                          height: 35.0,
                          padding: EdgeInsets.all(10.0),
                        ),
                        imageUrl: widget.peerAvatar,
                        width: 35.0,
                        height: 35.0,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(18.0),
                      ),
                      clipBehavior: Clip.hardEdge,
                    )
                  : Container(width: 35.0),
                Container(
                  child: Text(
                    document.data()['content'],
                    style: TextStyle(color: Colors.white),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(left: 10.0),
                )
              ]
            )
          ]
        )
      );
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1].data()['idFrom'] != widget.currentUserUid) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1].data()['idFrom'] == widget.currentUserUid) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  readLocal() async {
    if (widget.currentUserUid.hashCode <= widget.peerId.hashCode) {
      groupChatId = '${widget.currentUserUid}-${widget.peerId}';
    } else {
      groupChatId = '${widget.peerId}-${widget.currentUserUid}';
    }

    FirebaseFirestore.instance
      .collection('users')
      .doc(widget.currentUserUid)
      .update({'chattingWith': widget.peerId});

    setState(() {});
  }
}
