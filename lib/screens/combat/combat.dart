import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_rpg/screens/loot/loot.dart';

class Combat extends StatefulWidget {
  const Combat({Key? key, this.user, this.enemy, this.mapLevel})
      : super(key: key);
  final user;
  final enemy;
  final mapLevel;
  @override
  _CombatState createState() => _CombatState();
}

class _CombatState extends State<Combat> {
  var user,
      enemy,
      currentEnemyHP,
      currentUserHP,
      combatStatus,
      anouncements,
      buttonTexts,
      buttonColors;
  double logBase(num x, num base) => log(x) / log(base);
  @override
  void initState() {
    super.initState();
    user = widget.user;
    enemy = widget.enemy;
    currentEnemyHP = enemy.hp;
    currentUserHP = user.hp;
    combatStatus = 1;
    var mapLevel = widget.mapLevel;
    var exp =
        ((pow(mapLevel, logBase(mapLevel, 6))) * (100 - mapLevel)).round();
    var gold =
        ((pow(mapLevel, logBase(mapLevel, 6))) * (100 - mapLevel)).round();
    var vipExpText = '';
    if (Random().nextDouble() <= 0.01) {
      vipExpText = ', 1 điểm VIP';
      user.expVIP += 1;
    }
    anouncements = [
      'Bạn đã bị đánh bại. Ấn Quay lại để về màn hình kẻ thù.',
      '',
      'Bạn đã thắng. Bạn nhận được ${exp.toString()} kinh nghiệm, ${gold.toString()} tiền${vipExpText.toString()}. Ấn Nhận thưởng để tiến hành nhận các phần thưởng hấp dẫn khác.'
    ];
    buttonTexts = ['Quay lại', 'Tấn công', 'Nhận thưởng'];
    buttonColors = [Colors.black, Colors.blue, Colors.green[600]];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                  Expanded(
                    child: Text(
                      enemy.name,
                      style: TextStyle(fontSize: 24),
                    ),
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
                padding: const EdgeInsets.symmetric(vertical: 120),
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
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 80.0),
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(buttonColors[combatStatus]),
                    ),
                    child: Text(
                      buttonTexts[combatStatus],
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        if (combatStatus == 0) {
                          Navigator.pop(context);
                        }
                        if (combatStatus == 2) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Loot(dropList: enemy.dropList, user: user),
                            ),
                          );
                        }
                        if (currentUserHP == 0 || currentEnemyHP == 0) {
                          return;
                        }
                        currentUserHP = (currentUserHP - enemy.atk) > 0
                            ? currentUserHP - enemy.atk
                            : 0;
                        currentEnemyHP = (currentEnemyHP - user.atk) > 0
                            ? currentEnemyHP - user.atk
                            : 0;
                        if (currentUserHP == 0) {
                          combatStatus = 0;
                        } else if (currentEnemyHP == 0) {
                          combatStatus = 2;
                        }
                      });
                    }),
              ),
              Text(anouncements[combatStatus],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15.0, color: buttonColors[combatStatus])),
            ],
          ),
        ),
      ),
    );
  }
<<<<<<< Updated upstream

  _showUserNoHPDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Bạn đã bị đánh bại. Ấn OK để quay về màn hình kẻ thù.'),
        action: SnackBarAction(
            label: 'OK',
            onPressed: () {
              Navigator.of(context).pop();
            })));
  }

  _showUserDefeatEnemy(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Bạn đã thắng. Ấn OK để tiến hành nhận thưởng.'),
        action: SnackBarAction(
            label: 'OK',
            onPressed: () {
              // Navigator.of(context).pop();
              // TODO: Implement looting
            })));
  }

  // TODO: Upgrade user exp and vipExp
=======
>>>>>>> Stashed changes
}
