import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  var listWorldChat, allChatRef, userRef, allUserRef;
  var _scrollController = ScrollController();
  final otherMessageColor = Color(0xFF858585);
  final myMessageColor = Colors.blueAccent;
  var chatInputHint = 'Gửi tin nhắn...';
  var isRequest = false;
  var avatarMap = Map();
  @override
  void initState() {
    super.initState();
    userRef = widget.args['user'].getUserRef();
    userRef?.onChildChanged.listen(_onAttrChange);
    allChatRef = Chat.getAllChatRef();
    allChatRef?.onChildAdded.listen(_onAllChatAdded);
    allUserRef = User.getAllUserRef();
    allUserRef?.onChildChanged.listen(_onAllUserChange);
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
        } else if (snapshot.key == 'is_request') {
          widget.args['user'].isRequest = snapshot.value;
        }
      });
    }
  }

  _onAllUserChange(event) {
    if (this.mounted) {
      setState(() {
        avatarMap[event.snapshot.value['username']] =
            event.snapshot.value['avatar'];
      });
    }
  }

  Widget asyncChatMessages() {
    Iterable<Future> chatAndUser = [
      Chat.getListWorldChat(),
      User.getAvatarMap()
    ];
    return FutureBuilder(
        future: Future.wait(chatAndUser),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            isInit = false;
            listWorldChat = snapshot.data[0];
            avatarMap = snapshot.data[1];
            listWorldChat.sort((a, b) {
              var dateA = DateTime.parse(a.sendDate);
              var dateB = DateTime.parse(b.sendDate);
              return dateA.compareTo(dateB);
            });
            return syncChatMessages();
          }
          return SpinKitRing(
            color: Colors.blue,
          );
        });
  }

  Widget syncChatMessages() {
    var avatarSep = 3;
    var cnt = 0;
    for (var i = 0; i < listWorldChat.length; ++i) {
      if (cnt % avatarSep == (avatarSep - 1) ||
          i == listWorldChat.length - 1 ||
          listWorldChat[i].userName != listWorldChat[i + 1].userName) {
        listWorldChat[i].isVisAva = true;
        if ((i == listWorldChat.length - 1 ||
                listWorldChat[i].userName != listWorldChat[i + 1].userName) &&
            cnt % avatarSep != (avatarSep - 1)) {
          cnt = -1;
        }
      } else {
        listWorldChat[i].isVisAva = false;
      }
      cnt++;
    }
    return ListView.builder(
        controller: _scrollController,
        itemCount: listWorldChat.length,
        itemBuilder: (BuildContext context, int pos) {
          var isSentByMe = sentByMe(listWorldChat[pos].userName);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
            child: Container(
              child: chatBox(context, listWorldChat, pos, isSentByMe),
              alignment:
                  isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
            ),
          );
        });
  }

  Row chatBox(context, listChat, pos, isSentByMe) {
    return Row(
      mainAxisAlignment:
          isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isSentByMe) avatarBox(listChat, pos),
        if (!isSentByMe)
          SizedBox(
            width: 5.0,
          ),
        Flexible(
          child: FocusedMenuHolder(
            menuWidth: MediaQuery.of(context).size.width * 0.50,
            blurSize: 2.0,
            menuItemExtent: 45,
            menuBoxDecoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            duration: Duration(milliseconds: 0),
            animateMenuItems: true,
            blurBackgroundColor: Colors.black54,
            openWithTap: true,
            menuOffset: 10.0,
            bottomOffsetHeight: 80.0,
            menuItems: [
              FocusedMenuItem(
                title: Text("Sao chép"),
                trailingIcon: Icon(Icons.content_copy),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: listChat[pos].chat));
                  final coppiedSnackBar = SnackBar(
                    content: Text('Đã sao chép tin nhắn'),
                    duration: Duration(seconds: 1),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(coppiedSnackBar);
                },
              ),
              if (!isSentByMe)
                FocusedMenuItem(
                  title: Text(
                    isModorAdmin() ? "Cấm" : "Báo cáo",
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  trailingIcon: Icon(
                    Icons.report_problem,
                    color: Colors.redAccent,
                  ),
                  onPressed: () {
                    if (isModorAdmin()) {
                      User.banByUsername(listChat[pos].userName);
                      final bannedSnackBar = SnackBar(
                        content: Text('Đã cấm'),
                        duration: Duration(seconds: 1),
                      );
                      ScaffoldMessenger.of(context)
                          .showSnackBar(bannedSnackBar);
                    } else {
                      var rp = Report(widget.args['user'].username,
                          listChat[pos].userName, listChat[pos].chat);
                      rp.addReport();
                      final reportSnackBar =
                          SnackBar(content: Text('Đã báo cáo'));
                      ScaffoldMessenger.of(context)
                          .showSnackBar(reportSnackBar);
                    }
                  },
                ),
            ],
            onPressed: () {},
            child: messageBox(isSentByMe, listChat, pos),
          ),
        ),
        if (isSentByMe)
          SizedBox(
            width: 5.0,
          ),
        if (isSentByMe) avatarBox(listChat, pos),
      ],
    );
  }

  GestureDetector avatarBox(listChat, pos) {
    return GestureDetector(
      onTap: () {
        if (listChat[pos].isVisAva) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => viewOtherProfile(listChat[pos].userName),
            ),
          );
        }
      },
      child: syncAvatar(listChat, pos),
    );
  }

  CircleAvatar invisibleAvatar() {
    return CircleAvatar(
      backgroundColor: Colors.transparent,
    );
  }

  CircleAvatar syncAvatar(listChat, pos) {
    return listChat[pos].isVisAva
        ? CircleAvatar(
            backgroundImage: avatarMap[listChat[pos].userName] != ''
                ? MemoryImage(
                    Base64Decoder().convert(avatarMap[listChat[pos].userName]))
                : User.getDefaultAvatarBuilder(),
            backgroundColor: Colors.transparent,
          )
        : invisibleAvatar();
  }

  Container messageBox(isSentByMe, listChat, pos) {
    var boxPos;
    bool onlyMessage = false;
    if (pos == 0 || (!listChat[pos].isVisAva && listChat[pos - 1].isVisAva)) {
      boxPos = -1;
    } else if (pos != 0 &&
        pos != listChat.length - 1 &&
        listChat[pos - 1].userName == listChat[pos].userName &&
        listChat[pos + 1].userName == listChat[pos].userName &&
        !listChat[pos].isVisAva) {
      boxPos = 0;
    } else {
      boxPos = 1;
    }
    if (listChat.length == 1)
      onlyMessage = true;
    else if (pos == 0) {
      if (listChat[0].userName != listChat[1].userName) onlyMessage = true;
    } else if (pos == listChat.length - 1) {
      if (listChat[pos - 1].isVisAva) onlyMessage = true;
    } else if ((listChat[pos - 1].isVisAva
        //|| listChat[pos - 1].userName != listChat[pos].userName
        ) &&
        listChat[pos + 1].userName != listChat[pos].userName)
      onlyMessage = true;
    return Container(
      margin:
          isSentByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
      padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
      decoration: BoxDecoration(
        borderRadius: isSentByMe
            ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: boxPos == -1 || onlyMessage
                    ? Radius.circular(23)
                    : Radius.circular(5),
                bottomLeft: Radius.circular(23),
                bottomRight: boxPos == 1 || onlyMessage
                    ? Radius.circular(23)
                    : Radius.circular(5),
              )
            : BorderRadius.only(
                topLeft: boxPos == -1 || onlyMessage
                    ? Radius.circular(23)
                    : Radius.circular(5),
                topRight: Radius.circular(23),
                bottomLeft: boxPos == 1 || onlyMessage
                    ? Radius.circular(23)
                    : Radius.circular(5),
                bottomRight: Radius.circular(23)),
        color: isSentByMe ? myMessageColor : otherMessageColor,
      ),
      child: Text(listChat[pos].chat,
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 15.0, color: Colors.white)),
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
      chat.setChat(widget.args['user'], messageEditingController.text);
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

  scrollToBottomChat() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) => scrollToBottomChat());
    return isBan()
        ? banScreen()
        : Column(
            children: <Widget>[
              Expanded(
                  child: GestureDetector(
                child: isInit ? asyncChatMessages() : syncChatMessages(),
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
              )),
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
                    'ĐÃ BỊ CHẶN',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  Text(
                    "Hiệu lực đến: $localExpiredDateStr",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text(
                        widget.args['user'].isRequest
                            ? 'ĐÃ YÊU CẦU'
                            : 'YÊU CẦU GỠ CẤM',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    onTap: () {
                      if (!widget.args['user'].isRequest) {
                        const EMPTY = 'empty';
                        Future<String?> rs = showDialog<String>(
                          context: context,
                          builder: (BuildContext context) {
                            var requestInputController =
                                TextEditingController();
                            return AlertDialog(
                              title: Text('LỜI NHẮN'),
                              content: TextField(
                                controller: requestInputController,
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    var value = requestInputController.text;
                                    if (value == '') {
                                      Navigator.pop(context, EMPTY);
                                    } else
                                      Navigator.pop(context, value);
                                  },
                                  child: Text(
                                    'GỬI',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                        rs.then((value) {
                          switch (value) {
                            case EMPTY:
                              showInvalidAlert('KHÔNG ĐƯỢC BỎ TRỐNG LỜI NHẮN');
                              break;
                            case null:
                              break;
                            default:
                              widget.args['user'].request();
                              var rq = Report(widget.args['user'].username, '',
                                  value, true);
                              rq.addReport();
                          }
                        });
                      }
                    },
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

  showInvalidAlert(message) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.only(top: 20),
          content: Column(
            children: [
              Icon(
                Icons.warning_amber,
                color: Colors.red,
                size: 50,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'LỜI NHẮN NHẬP KHÔNG HỢP LỆ',
                style: TextStyle(fontWeight: FontWeight.w700),
              )
            ],
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
