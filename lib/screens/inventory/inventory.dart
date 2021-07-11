import 'package:flutter/material.dart';
import 'INVENTORY/INVENTORY.dart';
import 'EQUIPPED/EQUIPPED.dart';
import 'CRAFTING/CRAFTING.dart';

class Inventory extends StatefulWidget {
  const Inventory({Key? key, this.args}) : super(key: key);
  final args;
  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final args = widget.args;
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: buildBottomBar(args),
        body: buildPages(args),
      ),
    );
  }

  Widget buildBottomBar(args) {
    List<BottomNavigationBarItem> barItems = [
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'EQUIPPED',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.inventory_2_outlined),
        label: 'INVENTORY',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.precision_manufacturing),
        label: 'CRAFTING',
      ),
    ];
    return BottomNavigationBar(
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.blueGrey,
      unselectedLabelStyle: TextStyle(color: Colors.black),
      currentIndex: index,
      items: barItems,
      onTap: (int index) => setState(() => this.index = index),
    );
  }

  Widget buildPages(args) {
    List pages = [Equipped(), INVENTORY(), Crafting()];
    return pages[index];
  }
}
