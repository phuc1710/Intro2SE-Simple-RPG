import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:simple_rpg/models/world_chat.dart';

class WorldChat extends StatefulWidget {
  const WorldChat({Key? key, this.args}) : super(key: key);
  final args;
  @override
  _WorldChatState createState() => _WorldChatState();
}

class _WorldChatState extends State<WorldChat> {
  TextEditingController messageEditingController = new TextEditingController();
  Widget chatMessages() {
    var listWorldChat = Chat.getListWorldChat();
    return FutureBuilder<List>(
        future: listWorldChat,
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            var listAllChat = snapshot.data;
            var listChat = [];
            for (var a in listAllChat!) {
              listChat.add(a);
            }
            return ListView.builder(
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
                            ? Colors.blueAccent
                            : Colors.grey[700],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(listChat[pos].userName.toUpperCase(),
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

  sendMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Chat chat = Chat();
      chat.setChat(widget.args['user'].username, messageEditingController.text,
          DateTime.now().toString());
      chat.addChat();
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
    return Scaffold(
      appBar: AppBar(
        title: Text("World Chat", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black87,
        elevation: 0.0,
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            chatMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                color: Colors.grey[700],
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
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                            child: Icon(Icons.send, color: Colors.white)),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
