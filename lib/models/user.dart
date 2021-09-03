import 'package:firebase_database/firebase_database.dart';
import 'dart:math';
import 'package:ntp/ntp.dart';

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
  bool isRequest = false;
  int banCount = 0;
  String banExpired = '';
  String creationDate = DateTime.now().toString();
  String id = '';
  String avatar = '';
  List listInventory = ["i00", "i06", "i07", "i08", "i09", "i10"];
  List listEquipped = ["i01", "i02", "i03", "i04", "i05"];
  int level = 1;
  String name = 'NOOB';
  int exp = 0;

  int vipExp = 0;
  //a number to put in the random func to make sure the user get vipEXP after a certain number of time
  // max is 100 (times) return to 0 when reach 100
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
    this.banCount = data['ban_count'];
    this.banExpired = data['ban_expired'];
    this.isRequest = data['is_request'];
    this.avatar = data['avatar'];
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
      'gold': this.gold,
      'ban_count': this.banCount,
      'ban_expired': this.banExpired,
      'is_request': this.isRequest,
      'avatar': this.avatar
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
    if ((exp >=
            (((pow(this.level, logBase(this.level, 3))) * (100 - this.level))
                .round())) &
        (this.level < 100)) {
      exp -= (((pow(this.level, logBase(this.level, 3))) * (100 - this.level))
          .round());
      this.level += 1;
    }
    gold += incGold;
    vipExp += isGetVipExp ? 1 : 0;
    if (this.vipExp == 100) {
      this.isVIP = true;
    }
    save();
  }

  double logBase(num x, num base) => log(x) / log(base);

  promoteVIP() {
    // this.isVIP = !this.isVIP;
    this.isVIP = true;
    dbRef.child('users').child(this.id).update({'is_VIP': this.isVIP});
  }

  save() {
    dbRef.child('users').child(this.id).update(toData());
  }

  getUserRef() {
    return dbRef.child('users').child(this.id);
  }

  getNormalBanTime() {
    // The unit is Day
    var banLevelTimes = [1, 7, 30, 365];
    var len = banLevelTimes.length;
    var banDay;
    if (this.banCount >= len)
      banDay = 365 * pow(2, this.banCount + 1 - len);
    else
      banDay = banLevelTimes[this.banCount];
    return banDay;
  }

  unBan() {
    dbRef
        .child('users')
        .child(this.id)
        .update({'is_ban': false, 'ban_expired': "", 'is_request': false});
  }

  request() {
    dbRef.child('users').child(this.id).update({'is_request': true});
  }

  uploadAvatar(avatarStr) {
    dbRef.child('users').child(this.id).update({'avatar': avatarStr});
  }

  static getAvatarByID(userID) {
    return dbRef.child('users').child(userID).child('avatar').get();
  }

  static banByUsername(username, [time]) {
    dbRef
        .child('users')
        .orderByChild('username')
        .equalTo(username)
        .once()
        .then((DataSnapshot snapshot) {
      var banUser = User();
      banUser.fromData(snapshot.value[snapshot.value.keys.elementAt(0)]);
      if (time == null) {
        time = banUser.getNormalBanTime();
      }
      var curDate = NTP.now();
      curDate.then((value) {
        //CHANGE TO minutes TO TEST
        value = value.add(Duration(days: time));
        var strValue = value.toUtc().toString();
        dbRef.child('users').child(banUser.id).update({
          'is_ban': true,
          'ban_expired': strValue,
          'ban_count': ++banUser.banCount
        });
      });
    });
  }

  static unbanByUsername(username) {
    dbRef
        .child('users')
        .orderByChild('username')
        .equalTo(username)
        .once()
        .then((DataSnapshot snapshot) {
      var banUser = User();
      banUser.fromData(snapshot.value[snapshot.value.keys.elementAt(0)]);
      banUser.unBan();
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
