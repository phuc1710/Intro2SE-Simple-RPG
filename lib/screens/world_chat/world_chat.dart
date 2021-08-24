import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ntp/ntp.dart';
import 'package:simple_rpg/models/chat.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:simple_rpg/models/report.dart';
import 'package:simple_rpg/models/user.dart';
import 'package:simple_rpg/screens/view_profile/view_profile.dart';

class WorldChat extends StatefulWidget {
  const WorldChat({Key? key, this.args}) : super(key: key);
  final args;
  @override
  _WorldChatState createState() => _WorldChatState();
}

class _WorldChatState extends State<WorldChat> {
  TextEditingController messageEditingController = new TextEditingController();
  bool isInit = true;
  var listWorldChat, allChatRef, userRef;
  var _scrollController = ScrollController();
  final otherMessageColor = Color(0xFF858585);
  final myMessageColor = Colors.blueAccent;
  final maxMessage = 30;
  var chatInputHint = 'Gửi tin nhắn...';
  @override
  void initState() {
    super.initState();
    listWorldChat = Chat.getListWorldChat();
    userRef = widget.args['user'].getUserRef();
    userRef?.onChildChanged.listen(_onAttrChange);
    allChatRef = Chat.getAllChatRef();
    allChatRef?.onChildAdded.listen(_onAllChatAdded);
  }

  _onAllChatAdded(event) {
    if (this.mounted) {
      setState(() {
        var newChat = Chat();
        newChat.fromData(event.snapshot.value);
        try {
          listWorldChat.add(newChat);
        } catch (e) {}
      });
    }
  }

  _onAttrChange(event) {
    if (this.mounted) {
      setState(() {
        var snapshot = event.snapshot;
        if (snapshot.key == 'is_mod') {
          widget.args['user'].isMod = snapshot.value;
        } else if (snapshot.key == 'is_admin') {
          widget.args['user'].isAdmin = snapshot.value;
        } else if (snapshot.key == 'is_ban') {
          widget.args['user'].isBan = snapshot.value;
        } else if (snapshot.key == 'ban_expired') {
          widget.args['user'].banExpired = snapshot.value;
        }
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
            listChat.sort((a, b) {
              var dateA = DateTime.parse(a.sendDate);
              var dateB = DateTime.parse(b.sendDate);
              return dateA.compareTo(dateB);
            });
            return syncChatMessages(listChat);
          }
          return SpinKitRing(
            color: Colors.blue,
          );
        });
  }

  Widget syncChatMessages(list) {
    var listChat = list;
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
            child: sentByMe(listChat[pos].userName)
                ? chatBox(listChat, pos)
                : FocusedMenuHolder(
                    menuWidth: MediaQuery.of(context).size.width * 0.50,
                    blurSize: 2.0,
                    menuItemExtent: 45,
                    menuBoxDecoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    duration: Duration(milliseconds: 0),
                    animateMenuItems: true,
                    blurBackgroundColor: Colors.black54,
                    openWithTap:
                        true, // Open Focused-Menu on Tap rather than Long Press
                    menuOffset:
                        10.0, // Offset value to show menuItem from the selected item
                    bottomOffsetHeight:
                        80.0, // Offset height to consider, for showing the menu item ( for example bottom navigation bar), so that the popup menu will be shown on top of selected item.
                    menuItems: [
                      FocusedMenuItem(
                        title: Text("Xem thông tin"),
                        trailingIcon: Icon(Icons.portrait),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  viewOtherProfile(listChat[pos].userName),
                            ),
                          );
                        },
                      ),
                      FocusedMenuItem(
                        title: Text(
                          isModorAdmin() ? "Cấm" : "Báo Cáo",
                          style: TextStyle(color: Colors.redAccent),
                        ),
                        trailingIcon: Icon(
                          Icons.report_problem,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                          if (isModorAdmin()) {
                            User.banByUsername(listChat[pos].userName);
                          } else {
                            var rp = Report(widget.args['user'].username,
                                listChat[pos].userName, listChat[pos].chat);
                            rp.addReport();
                          }
                        },
                      ),
                    ],
                    onPressed: () {},
                    child: chatBox(listChat, pos),
                  ),
          );
        });
  }

  Container chatBox(listChat, int pos) {
    return Container(
      margin: sentByMe(listChat[pos].userName)
          ? EdgeInsets.only(left: 30)
          : EdgeInsets.only(right: 30),
      padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
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
    );
  }

  FutureBuilder viewOtherProfile(otherUsername) {
    var otherUser = User.getByUsername(otherUsername);
    return FutureBuilder(
        future: otherUser,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var oUser = User();
            var data =
                snapshot.data.value[snapshot.data.value.keys.elementAt(0)];
            oUser.fromData(data);
            var cUser = widget.args['user'];
            if (widget.args['user'].username == oUser.username) {
              cUser = User();
            }
            return SafeArea(
              child: Scaffold(
                body: ViewProfile(
                  user: cUser,
                  profileUser: oUser,
                  searchKey: '',
                  isFromChat: true,
                ),
              ),
            );
          }
          return SpinKitRing(
            color: Colors.blue,
          );
        });
  }

  sendMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Chat chat = Chat();
      chat.setChat(widget.args['user'].username, messageEditingController.text);
      messageEditingController.clear();
      FocusScope.of(context).unfocus();
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  sentByMe(String userName) {
    if (userName == widget.args['user'].username) {
      return true;
    }
    return false;
  }

  isModorAdmin() {
    var user = widget.args['user'];
    return user.isMod || user.isAdmin;
  }

  isBan() {
    return widget.args['user'].isBan;
  }

  @override
  Widget build(BuildContext context) {
    return isBan()
        ? banScreen()
        : Column(
            children: <Widget>[
              Expanded(
                  child: isInit
                      ? asyncChatMessages()
                      : syncChatMessages(listWorldChat)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                color: otherMessageColor,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageEditingController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: chatInputHint,
                          hintStyle: TextStyle(
                            color: Colors.white38,
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                        ),
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
                        child: Center(
                            child: Icon(Icons.send, color: Colors.white)),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
  }

  FutureBuilder banScreen() {
    return FutureBuilder(
        future: NTP.now(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var curDate = snapshot.data.toUtc();
            var expiredDate = DateTime.parse(widget.args['user'].banExpired);
            var banRemDur = expiredDate.difference(curDate);
            if (banRemDur.isNegative) {
              widget.args['user'].unBan();
            }
            Future.delayed(banRemDur, () {
              widget.args['user'].unBan();
            });
            var localExpiredDateStr = expiredDate.toLocal().toString();
            localExpiredDateStr = localExpiredDateStr.substring(
                0, localExpiredDateStr.lastIndexOf('.'));
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.report, color: Colors.red[400], size: 100),
                  Text(
                    'BANNED',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  Text(
                    "Expire at: $localExpiredDateStr",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  )
                ],
              ),
            );
          }

          return SpinKitRing(
            color: Colors.blue,
          );
        });
  }
}
