import 'package:firebase_database/firebase_database.dart';

var dbRef = FirebaseDatabase.instance.reference();

class GameMap {
  String name;
  String description;
  Map enemies;
  int level;
  GameMap(this.name, this.description, this.enemies, this.level);

  static Future<List> getMaps() async {
    var mapsRef = await dbRef.child('maps').get();
    return mapsRef?.value.entries.map((entry) {
      var values = entry.value;
      GameMap gameMap = GameMap(values['name'], values['description'],
          values['enemies'], values['level']);
      return gameMap;
    }).toList();
  }
}
