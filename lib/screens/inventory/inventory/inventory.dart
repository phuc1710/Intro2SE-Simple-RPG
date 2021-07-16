import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:simple_rpg/models/user.dart';
import '../../../models/user.dart';

class Inventory extends StatefulWidget {
  const Inventory({Key? key}) : super(key: key);
  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  final ref = FirebaseDatabase.instance.reference();
  User _user = User();

  @override
  Widget build(BuildContext context) {
    //return ListItem(); TODO: lấy ListItem trong database
    return ListView.builder(
        shrinkWrap: true,
        itemCount: _user.listItem.length,
        itemBuilder: (BuildContext context, int position) {
          return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              elevation: 5,
              color: (position % 2) == 0 ? Colors.blue : Colors.greenAccent,
              child: ListTile(
                leading: Icon(Icons.arrow_right),
                title: Text(
                  'ID ${_user.listItem[position]}',
                  style: TextStyle(color: Colors.purple),
                ),
                subtitle: Text('Hp + ...: Atk + ...'),
                onTap: () {
                  //TODO: hiện thông tin trang bị
                },
                onLongPress: () {
                  //TODO: chọn trang bị
                },
              ));
        });
  }
}
