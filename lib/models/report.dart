import 'package:firebase_database/firebase_database.dart';

var dbRef = FirebaseDatabase.instance.reference();

class Report {
  String fromUsername = "";
  String toUsername = "";
  String chat = "";
  String id = "";

  Report(fromUsername, toUsername, chat) {
    this.fromUsername = fromUsername;
    this.toUsername = toUsername;
    this.chat = chat;
  }

  Report.fromDB(data) {
    this.fromUsername = data['from_username'];
    this.toUsername = data['to_username'];
    this.chat = data['chat'];
    this.id = data['id'];
  }

  toData() {
    return {
      'from_username': this.fromUsername,
      'to_username': this.toUsername,
      'chat': this.chat,
      'id': this.id,
    };
  }

  addReport() {
    var record = dbRef.child('reports').push();
    this.id = record.key;
    record.set(toData());
  }

  remove() {
    dbRef.child('reports').child(this.id).remove();
  }

  compare(other) {
    return this.id == other.id;
  }

  static getAllReportRef() {
    return dbRef.child('reports');
  }

  static Future<List> getListReport() async {
    var wcRef = await dbRef.child('reports').get();
    if (wcRef?.value == null) return [];
    return wcRef?.value.entries.map((entry) {
      Report wchat = Report.fromDB(entry.value);
      return wchat;
    }).toList();
  }
}
