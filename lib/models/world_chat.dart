import 'package:firebase_database/firebase_database.dart';

var dbRef = FirebaseDatabase.instance.reference();

class Chat {
  String userName = "";
  String chat = "";
  String sendDate = DateTime.now().toString();

  toData() {
    return {
      'userName': this.userName,
      'chat': this.chat,
      'sendDate': this.sendDate
    };
  }

  addChat() {
    var record = dbRef.child('listWorldChat').push();
    record.set(toData());
  }

  setChat(userName1, chat1, sendDate1) {
    this.userName = userName1;
    this.chat = chat1;
    this.sendDate = sendDate1;
  }

  fromData(data) {
    this.userName = data['userName'];
    this.chat = data['chat'];
    this.sendDate = data['sendDate'];
  }

  static getAllChatRef() {
    return dbRef.child('listWorldChat');
  }

  static Future<List> getListWorldChat() async {
    var wcRef = await dbRef.child('listWorldChat').get();
    return wcRef?.value.entries.map((entry) {
      Chat wchat = Chat();
      wchat.fromData(entry.value);
      return wchat;
    }).toList();
  }
}
