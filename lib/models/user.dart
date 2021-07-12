import 'package:firebase_database/firebase_database.dart';

var dbRef = FirebaseDatabase.instance.reference();

class User {
  String username = '';
  String password = '';
  bool isAdmin = false;
  bool isMod = false;
  String creationDate = DateTime.now().toString();
  String id = '';

  fromData(data) {
    this.username = data['username'];
    this.password = data['password'];
    this.isAdmin = data['isAdmin'];
    this.isMod = data['isMod'];
    this.creationDate = data['creationDate'];
    this.id = data['id'];
  }

  toData() {
    return {
      'username': this.username,
      'password': this.password,
      'isAdmin': this.isAdmin,
      'isMod': this.isMod,
      'creationDate': this.creationDate,
      'id': this.id
    };
  }

  register() {
    var record = dbRef.child('users').push();
    this.id = record.key;
    record.set(toData());
  }

  changeMod() {
    this.isMod = !this.isMod;
    dbRef.child('users').child(this.id).update({'isMod': this.isMod});
  }

  static Future<List> getUsers() async {
    var usersRef = await dbRef.child('users').get();
    return usersRef?.value.entries.map((entry) {
      User user = User();
      user.fromData(entry.value);
      return user;
    }).toList();
  }
}
