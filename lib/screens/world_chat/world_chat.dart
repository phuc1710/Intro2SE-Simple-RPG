import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:simple_rpg/models/chat.dart';

class WorldChat extends StatefulWidget {
  const WorldChat({Key? key, this.args}) : super(key: key);
  final args;
  @override
  _WorldChatState createState() => _WorldChatState();
}

class _WorldChatState extends State<WorldChat> {
  TextEditingController messageEditingController = new TextEditingController();
  bool isInit = true;
  var listWorldChat, allChatRef;
  var _scrollController = ScrollController();
  final otherMessageColor = Color(0xFF858585);
  final myMessageColor = Colors.blueAccent;
  final maxMessage = 30;
  @override
  void initState() {
    super.initState();
    listWorldChat = Chat.getListWorldChat();
    allChatRef = Chat.getAllChatRef();
    allChatRef?.onChildAdded.listen(_onAllChatAdded);
  }

  _onAllChatAdded(event) {
    if (this.mounted) {
      setState(() {
        Chat addedChat = Chat();
        addedChat.fromData(event.snapshot.value);
        listWorldChat.add(addedChat);
      });
    }
  }

  Widget asyncChatMessages() {
    return FutureBuilder<List>(
        future: listWorldChat,
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            isInit = false;
            var listAllChat = snapshot.data;
            var listChat = [];
            for (var a in listAllChat!) {
              listChat.add(a);
            }
            // if (listChat.length == 0)
            //   return Center(
            //     child: Text(
            //       'NO MESSAGE',
            //       style: TextStyle(
            //         fontSize: 20,
            //       ),
            //     ),
            //   );
            listChat.sort((a, b) {
              var dateA = DateTime.parse(a.sendDate);
              var dateB = DateTime.parse(b.sendDate);
              return dateA.compareTo(dateB);
            });
            var start = listChat.length - maxMessage;
            if (start < 0) start = 0;
            listChat = listChat.sublist(start);
            listWorldChat = listChat;
            return ListView.builder(
                controller: _scrollController,
                itemCount: listChat.length,
                itemBuilder: (BuildContext context, int pos) {
                  return Container(
                    padding: EdgeInsets.only(
                        top: 4,
                        bottom: 4,
                        left: sentByMe(listChat[pos].userName) ? 0 : 24,
                        right: sentByMe(listChat[pos].userName) ? 24 : 0),
                    alignment: sentByMe(listChat[pos].userName)
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: sentByMe(listChat[pos].userName)
                          ? EdgeInsets.only(left: 30)
                          : EdgeInsets.only(right: 30),
                      padding: EdgeInsets.only(
                          top: 17, bottom: 17, left: 20, right: 20),
                      decoration: BoxDecoration(
                        borderRadius: sentByMe(listChat[pos].userName)
                            ? BorderRadius.only(
                                topLeft: Radius.circular(23),
                                topRight: Radius.circular(23),
                                bottomLeft: Radius.circular(23))
                            : BorderRadius.only(
                                topLeft: Radius.circular(23),
                                topRight: Radius.circular(23),
                                bottomRight: Radius.circular(23)),
                        color: sentByMe(listChat[pos].userName)
                            ? myMessageColor
                            : otherMessageColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(listChat[pos].userName,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  letterSpacing: -0.5)),
                          SizedBox(height: 7.0),
                          Text(listChat[pos].chat,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.white)),
                        ],
                      ),
                    ),
                  );
                });
          }
          return SpinKitRing(
            color: Colors.blue,
          );
        });
  }

  Widget syncChatMessages() {
    var listChat = listWorldChat;
    var start = listChat.length - maxMessage;
    if (start < 0) start = 0;
    listChat = listChat.sublist(start);
    listWorldChat = listChat;
    return ListView.builder(
        controller: _scrollController,
        itemCount: listChat.length,
        itemBuilder: (BuildContext context, int pos) {
          return Container(
            padding: EdgeInsets.only(
                top: 4,
                bottom: 4,
                left: sentByMe(listChat[pos].userName) ? 0 : 24,
                right: sentByMe(listChat[pos].userName) ? 24 : 0),
            alignment: sentByMe(listChat[pos].userName)
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container(
              margin: sentByMe(listChat[pos].userName)
                  ? EdgeInsets.only(left: 30)
                  : EdgeInsets.only(right: 30),
              padding:
                  EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
              decoration: BoxDecoration(
                borderRadius: sentByMe(listChat[pos].userName)
                    ? BorderRadius.only(
                        topLeft: Radius.circular(23),
                        topRight: Radius.circular(23),
                        bottomLeft: Radius.circular(23))
                    : BorderRadius.only(
                        topLeft: Radius.circular(23),
                        topRight: Radius.circular(23),
                        bottomRight: Radius.circular(23)),
                color: sentByMe(listChat[pos].userName)
                    ? myMessageColor
                    : otherMessageColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(listChat[pos].userName,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: -0.5)),
                  SizedBox(height: 7.0),
                  Text(listChat[pos].chat,
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 15.0, color: Colors.white)),
                ],
              ),
            ),
          );
        });
  }

  sendMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Chat chat = Chat();
      chat.setChat(widget.args['user'].username, messageEditingController.text,
          DateTime.now().toString());
      chat.addChat();
      messageEditingController.clear();
      FocusScope.of(context).unfocus();
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  sentByMe(String userName) {
    if (userName == widget.args['user'].username) {
      return true;
    } else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(child: isInit ? asyncChatMessages() : syncChatMessages()),
        Container(
          alignment: Alignment.bottomCenter,
          width: MediaQuery.of(context).size.width,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            color: otherMessageColor,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: messageEditingController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        hintText: "Send a message ...",
                        hintStyle: TextStyle(
                          color: Colors.white38,
                          fontSize: 16,
                        ),
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(width: 12.0),
                GestureDetector(
                  onTap: () {
                    sendMessage();
                  },
                  child: Container(
                    height: 50.0,
                    width: 50.0,
                    decoration: BoxDecoration(
                        color: myMessageColor,
                        borderRadius: BorderRadius.circular(50)),
                    child: Center(child: Icon(Icons.send, color: Colors.white)),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
