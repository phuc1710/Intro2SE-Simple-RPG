import 'package:flutter/material.dart';
import 'package:simple_rpg/models/enemy.dart';
import 'package:simple_rpg/screens/combat/combat.dart';

class GameEnemy extends StatelessWidget {
  const GameEnemy({Key? key, this.enemyList, this.user}) : super(key: key);
  final enemyList, user;
  @override
  Widget build(BuildContext context) {
    var enemyRList = new List.from(enemyList.reversed);
    return ListView.builder(
      itemCount: enemyList.length,
      itemBuilder: (context, index) {
        var enemyData = enemyRList[index];
        var enemy = Enemy(enemyData['name'], enemyData['atk'], enemyData['hp'],
            enemyData['drop_list']);
        return Card(
          child: ListTile(
            leading: Icon(Icons.pest_control_rounded, size: 40.0),
            title: Text(enemy.name),
            subtitle: Row(
              children: [
                Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 15.0,
                ),
                Text(
                  ' HP: ${enemy.hp}     ',
                  style: TextStyle(color: Colors.red),
                ),
                Icon(
                  Icons.local_fire_department,
                  color: Colors.green,
                  size: 15.0,
                ),
                Text(
                  ' ATK: ${enemy.atk}',
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Combat(user: user, enemy: enemy)));
            },
          ),
        );
      },
    );
  }
}