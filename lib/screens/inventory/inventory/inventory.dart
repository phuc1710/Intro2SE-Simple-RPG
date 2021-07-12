import 'package:flutter/material.dart';

class Inventory extends StatefulWidget {
  const Inventory({Key? key}) : super(key: key);
  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, position) {
        //return ListItem(); TODO: lấy ListItem trong database
        return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            elevation: 1,
            color: (position % 2) == 0 ? Colors.blueAccent : Colors.greenAccent,
            child: ListTile(
              leading: Icon(Icons.arrow_right),
              title: Text(
                'Đồ ${position}',
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
      },
      itemCount: 50,
    );
  }
}
