import 'package:firebase_database/firebase_database.dart';

var dbRef = FirebaseDatabase.instance.reference();

class Enemy {
  String name;
  int atk;
  int hp;
  Map dropList;
  Enemy(this.name, this.atk, this.hp, this.dropList);
}
