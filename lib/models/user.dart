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
  bool isBan = false;
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
    this.isAdmin = data['is_admin'];
    this.isMod = data['is_mod'];
    this.isVIP = data['is_VIP'];
    this.isBan = data['is_ban'];
    this.creationDate = data['creation_date'];
    this.id = data['id'];
    this.listInventory = data['inventory_item_ids'];
    this.listEquipped = data['equipped_item_ids'];
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
      'is_admin': this.isAdmin,
      'is_mod': this.isMod,
      'is_VIP': this.isVIP,
      'is_ban': this.isBan,
      'creation_date': this.creationDate,
      'id': this.id,
      'inventory_item_ids': this.listInventory,
      'equipped_item_ids': this.listEquipped,
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
    dbRef.child('users').child(this.id).update({'is_mod': this.isMod});
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

  incStatAfterCombat(int incExp, int incGold, bool isGetVipExp) {
    exp += incExp;
    gold += incGold;
    vipExp += isGetVipExp ? 1 : 0;
    save();
  }

  promoteVIP() {
    // this.isVIP = !this.isVIP;
    this.isVIP = true;
    dbRef.child('users').child(this.id).update({'is_VIP': this.isVIP});
  }

  // input exp of enemy (normal exp)
  updateVIPExp(int newEXP) {
    if (newEXP != 0) {
      if (this.isVIP == false) {
        // random to whether update or not
        Random random = new Random();
        int randomNumber = random.nextInt(MAX_ENSURANCE - this.ensurance);

        // VipExp drop success. 0 can be replaced if like as a condition
        if (randomNumber == 0) {
          this.ensurance = 0;
          int vExp;
          vExp = this.vipExp;
          vExp += 1; //increase 1 exp each successful drop.
          this.vipExp = vExp;

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

  static banByUsername(username) {
    return dbRef
        .child('users')
        .orderByChild('username')
        .equalTo(username)
        .once()
        .then((DataSnapshot snapshot) {
      var banUserId = snapshot.value.keys.elementAt(0);
      dbRef.child('users').child(banUserId).update({'is_ban': true});
    });
  }

  static getByUsername(username) {
    return dbRef
        .child('users')
        .orderByChild('username')
        .equalTo(username)
        .once();
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
