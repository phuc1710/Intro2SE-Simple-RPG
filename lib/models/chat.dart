import 'package:firebase_database/firebase_database.dart';
import 'package:ntp/ntp.dart';

var dbRef = FirebaseDatabase.instance.reference();

class Chat {
  String userName = "";
  String chat = "";
  String sendDate = DateTime.now().toString();
  String userAvatar = '';

  toData() {
    return {
      'username': this.userName,
      'chat': this.chat,
      'send_date': this.sendDate,
      'user_avatar': this.userAvatar
    };
  }

  addChat() {
    var record = dbRef.child('world_chats').push();
    record.set(toData());
  }

  setChat(userName, chat, userAvatar) {
    this.userName = userName;
    this.chat = chat;
    this.userAvatar = userAvatar;
    var curDate = NTP.now();
    curDate.then((value) {
      this.sendDate = value.toUtc().toString();
      this.addChat();
    });
  }

  fromData(data) {
    this.userName = data['username'];
    this.chat = data['chat'];
    this.sendDate = data['send_date'];
    this.userAvatar = data['user_avatar'];
  }

  static getAllChatRef() {
    return dbRef.child('world_chats');
  }

  static Future<List> getListWorldChat() async {
    var wcRef = await dbRef.child('world_chats').get();
    if (wcRef?.value == null) return [];
    return wcRef?.value.entries.map((entry) {
      Chat wchat = Chat();
      wchat.fromData(entry.value);
      return wchat;
    }).toList();
  }
}
