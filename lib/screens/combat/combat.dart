import 'package:flutter/material.dart';

class Combat extends StatefulWidget {
  const Combat({Key? key, this.user, this.enemy}) : super(key: key);
  final user;
  final enemy;
  @override
  _CombatState createState() => _CombatState();
}

class _CombatState extends State<Combat> {
  var user, enemy, currentEnemyHP, currentUserHP;
  @override
  void initState() {
    super.initState();
    user = widget.user;
    enemy = widget.enemy;
    currentEnemyHP = enemy.hp;
    currentUserHP = user.hp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Combat'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  enemy.name,
                  style: TextStyle(fontSize: 24),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    Text(
                      ' HP: $currentEnemyHP',
                      style: TextStyle(fontSize: 20, color: Colors.red),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              width: 10,
              child: LinearProgressIndicator(
                value: currentEnemyHP / enemy.hp,
                color: Colors.red,
                backgroundColor: Colors.red[100],
                minHeight: 20.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 100),
              child: Container(
                alignment: Alignment.center,
                child: Image(
                  image: AssetImage('assets/images/chien_dau.png'),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  user.username,
                  style: TextStyle(fontSize: 24),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    Text(
                      ' HP: $currentUserHP',
                      style: TextStyle(fontSize: 20, color: Colors.red),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              width: 10,
              child: LinearProgressIndicator(
                value: currentUserHP / user.hp,
                color: Colors.red,
                backgroundColor: Colors.red[100],
                minHeight: 20.0,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 80.0),
              child: ElevatedButton(
                  child: Text(
                    'Tấn công',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      currentUserHP = (currentUserHP - enemy.atk) > 0
                          ? currentUserHP - enemy.atk
                          : 0;
                      currentEnemyHP = (currentEnemyHP - user.atk) > 0
                          ? currentEnemyHP - user.atk
                          : 0;
                    });
                  }),
            )
          ],
        ),
      ),
    );
  }
}