import 'package:firebase_database/firebase_database.dart';

var dbRef = FirebaseDatabase.instance.reference();

class GameMap {
  String name;
  String description;
  Map enemyList;
  int level;
  GameMap(this.name, this.description, this.enemyList, this.level);

  static Future<List> getMaps() async {
    var mapsRef = await dbRef.child('maps').get();
    return mapsRef?.value.entries.map((entry) {
      var values = entry.value;
      GameMap gameMap = GameMap(values['name'], values['description'],
          values['enemy_list'], values['level']);
      return gameMap;
    }).toList();
  }
}
