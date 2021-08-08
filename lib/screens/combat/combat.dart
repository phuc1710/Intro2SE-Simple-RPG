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
      buttonColors,
      exp,
      gold,
      isGetVipExp;
  double logBase(num x, num base) => log(x) / log(base);
  @override
  void initState() {
    super.initState();
    user = widget.user;
    enemy = widget.enemy;
    currentEnemyHP = enemy.hp;
    currentUserHP = user.hp;
    combatStatus = 1;
    isGetVipExp = false;
    var mapLevel = widget.mapLevel;
    exp = ((pow(mapLevel, logBase(mapLevel, 6))) * (100 - mapLevel)).round();
    gold = ((pow(mapLevel, logBase(mapLevel, 6))) * (100 - mapLevel)).round();
    anouncements = [
      'Bạn đã bị đánh bại. Ấn Quay lại để về màn hình kẻ thù.',
      '',
      _getWinText(exp, gold)
    ];
    buttonTexts = ['Quay lại', 'Tấn công', 'Nhận thưởng'];
    buttonColors = [Colors.black, Colors.blue, Colors.green[600]];
  }

  _getWinText(exp, gold) {
    var vipExpText = '';
    if (Random().nextDouble() <= 0.01) {
      vipExpText = ', 1 điểm VIP';
      isGetVipExp = true;
    }
    return 'Bạn đã thắng. Bạn nhận được ${exp.toString()} kinh nghiệm, ${gold.toString()} tiền' +
        vipExpText +
        '. Ấn Nhận thưởng để tiến hành nhận các phần thưởng hấp dẫn khác.';
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
            children: [
              Column(
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
                ],
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Image(
                    image: AssetImage('assets/images/chien_dau.png'),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                          backgroundColor: MaterialStateProperty.all(
                              buttonColors[combatStatus]),
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
                              user.incStatAfterCombat(exp, gold, isGetVipExp);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Loot(
                                      dropList: enemy.dropList, user: user),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
