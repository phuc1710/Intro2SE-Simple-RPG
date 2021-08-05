import 'package:firebase_database/firebase_database.dart';

var dbRef = FirebaseDatabase.instance.reference();

class Item {
  String id = '';
  String name = '';
  String type = '';
  int hp = 0;
  int atk = 0;
  String about = '';

  addItem2Db(id, name, type, hp, atk, about) {
    this.id = id;
    this.name = name;
    this.type = type;
    this.hp = hp;
    this.atk = atk;
    this.about = about;
    addItem();
  }

  toData() {
    return {
      'id': this.id,
      'name': this.name,
      'type': this.type,
      'hp': this.hp,
      'atk': this.atk,
      'about': this.about
    };
  }

  addItem() {
    var record = dbRef.child('listItem').push();
    record.set(toData());
  }

  fromData(data) {
    this.id = data['id'];
    this.hp = data['hp'];
    this.atk = data['atk'];
    this.type = data['type'];
    this.about = data['about'];
    this.name = data['name'];
  }

  static Future<List> getListItem() async {
    var itemRef = await dbRef.child('listItem').get();
    return itemRef?.value.entries.map((entry) {
      Item item = Item();
      item.fromData(entry.value);
      return item;
    }).toList();
  }
}
