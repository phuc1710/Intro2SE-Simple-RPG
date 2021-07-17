import 'package:flutter/material.dart';
import 'package:simple_rpg/models/user.dart';

class Inventory extends StatefulWidget {
  const Inventory({Key? key, this.args}) : super(key: key);
  final args;
  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  @override
  Widget build(BuildContext context) {
    final args = widget.args;
    List listitem = args['user'].listItem;
    return ListView.builder(
        shrinkWrap: true,
        itemCount: listitem.length,
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
                  'ID ${listitem[position]}',
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
