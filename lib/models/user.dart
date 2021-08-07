import 'package:firebase_database/firebase_database.dart';
import 'dart:math';

var dbRef = FirebaseDatabase.instance.reference();
const MAX_ENSURANCE = 10;
const TOBE_VIP = 100; // amount of vipExp to be a VIP

class User {
  String username = '';
  String password = '';
  bool isAdmin = false;
  bool isMod = false;
  bool isVIP = false;
  String creationDate = DateTime.now().toString();
  String id = '';
  List listInventory = ["i00", "i06", "i07", "i08", "i09", "i10"];
  List listEquipped = ["i01", "i02", "i03", "i04", "i05"];
  int level = 1;
  String name = 'NOOB';
  int exp = 0;

  int vipExp = 0;
  //a number to put in the random func to make sure the user get vipEXP after a certain number of time
  // max is 10 (times) return to 0 when reach 10
  int ensurance = 0; 
  
  int atk = 150;
  int hp = 300;
  int gold = 0;

  fromData(data) {
    this.username = data['username'];
    this.password = data['password'];
    this.isAdmin = data['isAdmin'];
    this.isMod = data['isMod'];
    this.isVIP = data['isVIP'];
    this.creationDate = data['creationDate'];
    this.id = data['id'];
    this.listInventory = data['listInventory'];
    this.listEquipped = data['listEquipped'];
    this.level = data['level'];
    this.exp = data['exp'];
    this.vipExp = data['vip_exp'];
    this.ensurance = data['ensurance'];
    this.atk = data['atk'];
    this.hp = data['hp'];
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
      'listInventory': this.listInventory,
      'listEquipped': this.listEquipped,
      'level': this.level,
      'exp': this.exp,
      'vip_exp': this.vipExp,
      'ensurance': this.ensurance,
      'atk': this.atk,
      'hp': this.hp,
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

  addItem2ListInv(itemID) {
    List list = new List.empty();
    list += listInventory;
    list.add(itemID);
    listInventory = list;
  }

  removeItemFromListInv(itemID) {
    List list = new List.empty();
    list += listInventory;
    list.remove(itemID);
    listInventory = list;
  }

  updateEXP(int newEXP) {
    if (newEXP != 0) {
      int exp;
      exp = this.exp;
      exp += newEXP;
      this.exp = exp;
    }
  }

  promoteVIP() {
    // this.isVIP = !this.isVIP;
    this.isVIP = true;
    dbRef.child('users').child(this.id).update({'isVIP': this.isVIP});
  }

  // input exp of enemy (normal exp)
  updateVIP_exp(int newEXP) {
    if (newEXP != 0) {
      if (this.isVIP == false) {
        // random to whether update or not
        Random random = new Random();
        int randomNumber = random.nextInt(MAX_ENSURANCE - this.ensurance);

        // VipExp drop success. 0 can be replaced if like as a condition
        if (randomNumber == 0) {
          this.ensurance = 0;
          int v_exp;
          v_exp = this.vipExp;
          v_exp += 1; //increase 1 exp each successful drop.
          this.vipExp = v_exp;

          if (this.vipExp >= TOBE_VIP) {
            promoteVIP();
          }
        }
        // VipExp drop fail.
        else {
          int ens = this.ensurance;
          ens += 1;
          this.ensurance = ens;
        }
      }
    }
  }

  save() {
    dbRef.child('users').child(this.id).update(toData());
  }

  getUserRef() {
    return dbRef.child('users').child(this.id);
  }

  static getAllUserRef() {
    return dbRef.child('users');
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
