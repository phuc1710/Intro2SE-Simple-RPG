import 'package:firebase_database/firebase_database.dart';
import 'dart:math';

var dbRef = FirebaseDatabase.instance.reference();

class User {
  String username = '';
  String password = '';
  bool isAdmin = false;
  bool isMod = false;
  bool isVIP = false;
  String creationDate = DateTime.now().toString();
  String id = '';
  List listItem = [0, 1, 2, 3, 4, 5];
  int level = 0;
  String name = 'NOOB';
  int exp = 0;
  int vip_exp = 0;  //min = 0, max = 100 when vip_exp == 100, isVIP = true
  int attack = 100;
  int health = 100;
  int gold = 0;
  fromData(data) {
    this.username = data['username'];
    this.password = data['password'];
    this.isAdmin = data['isAdmin'];
    this.isMod = data['isMod'];
    this.isVIP = data['isVIP'];
    this.creationDate = data['creationDate'];
    this.id = data['id'];
    this.listItem = data['listItem'];
    this.level = data['level'];
    this.exp = data['exp'];
    this.vip_exp = data['vip_exp'];
    this.attack = data['attack'];
    this.health = data['health'];
    this.gold = data['gold'];
  }

  toData() {
    return {
      'username': this.username,
      'password': this.password,
      'isAdmin': this.isAdmin,
      'isMod': this.isMod,
      'isVIP': this.isVIP,
      'creationDate': this.creationDate,
      'id': this.id,
      'listItem': this.listItem,
      'level': this.level,
      'exp': this.exp,
      'vip_exp': this.vip_exp,
      'attack': this.attack,
      'health': this.health,
      'gold': this.gold
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

  static bulkRegister() {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    // Random _rnd = Random();
    // for (int i = 0; i < 50; ++i) {
    //   User user = User();
    //   user.username = String.fromCharCodes(Iterable.generate(
    //       _rnd.nextInt(5) + 5,
    //       (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    //   user.password = i.toString();
    //   user.register();
    // }
    var lastNames = ['nguyenvan', 'levan', 'tranthi', 'vothi'];
    for (int i = 0; i < lastNames.length; ++i) {
      for (int j = 0; j < _chars.length; ++j) {
        User user = User();
        user.username = lastNames[i] + _chars[j];
        user.password = _chars[j];
        user.register();
      }
    }
  }

  static clearUsers() {
    dbRef.child('users').remove();
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
