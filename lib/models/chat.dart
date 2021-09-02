import 'package:firebase_database/firebase_database.dart';
import 'package:ntp/ntp.dart';

var dbRef = FirebaseDatabase.instance.reference();

class Chat {
  String userName = "";
  String chat = "";
  String sendDate = DateTime.now().toString();
  String userAvatar = '';
  String userID = '';
  String id = '';
  bool isVisAva = false;

  toData() {
    return {
      'username': this.userName,
      'chat': this.chat,
      'send_date': this.sendDate,
      'user_avatar': this.userAvatar,
      'user_id': this.userID,
      'id': this.id,
      'is_vis_ava': this.isVisAva
    };
  }

  addChat() {
    var record = dbRef.child('world_chats').push();
    this.id = record.key;
    record.set(toData());
  }

  setChat(user, chat) {
    this.userName = user.username;
    this.chat = chat;
    this.userAvatar = user.avatar;
    this.userID = user.id;
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
    this.userID = data['user_id'];
    this.id = data['id'];
    this.isVisAva = data['is_vis_ava'];
  }

  static updateUserAvatar(chatID, avatar) {
    dbRef.child('world_chats').child(chatID).update({'user_avatar': avatar});
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
