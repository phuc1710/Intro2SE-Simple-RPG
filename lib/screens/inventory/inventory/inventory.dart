import 'package:flutter/material.dart';

class Inventory extends StatefulWidget {
  const Inventory({Key? key}) : super(key: key);

  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  @override
  Widget build(BuildContext context) {
    // TODO: Implement Equipped
    return Container(
      child: Text('INVENTORY'),
      alignment: Alignment.center,
    );
  }
}
