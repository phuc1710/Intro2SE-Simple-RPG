import 'package:flutter/material.dart';
import 'package:simple_rpg/models/item.dart';

class WorldChat extends StatefulWidget {
  const WorldChat({Key? key}) : super(key: key);

  @override
  _WorldChatState createState() => _WorldChatState();
}

class _WorldChatState extends State<WorldChat> {
  @override
  Widget build(BuildContext context) {
    // TODO: Implement WORLD CHAT
    // Item item = Item();
    // item.addItem2Db('i07', 'Dao phây', 0, 0, 100, 'Dao nấu ăn');
    // item.addItem2Db('i07', 'Nón cối', 1, 100, 0, 'Nón bảo vệ đầu');
    // item.addItem2Db('i08', 'Áo da', 2, 200, 0, 'Làm từ da cá sấu');
    // item.addItem2Db('i09', 'Quần jean', 3, 300, 0, 'Cực kì bền');
    // item.addItem2Db('i10', 'Giày sandal', 4, 100, 100, 'Có quay hậu');
    return Container(
      child: Text('WORLD CHAT'),
      alignment: Alignment.center,
    );
  }
}
