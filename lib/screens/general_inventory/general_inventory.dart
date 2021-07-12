import 'package:flutter/material.dart';
import 'package:simple_rpg/screens/inventory/crafting/crafting.dart';
import 'package:simple_rpg/screens/inventory/equipped/equipped.dart';
import 'package:simple_rpg/screens/inventory/inventory/inventory.dart';

class GeneralInventory extends StatefulWidget {
  const GeneralInventory({Key? key, this.args}) : super(key: key);
  final args;
  @override
  _GeneralInventoryState createState() => _GeneralInventoryState();
}

class _GeneralInventoryState extends State<GeneralInventory> {
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
        icon: Icon(Icons.inventory_2_outlined),
        label: 'INVENTORY',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'EQUIPPED',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.precision_manufacturing),
        label: 'CRAFTING',
      ),
    ];
    return BottomNavigationBar(
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      unselectedLabelStyle: TextStyle(color: Colors.black),
      currentIndex: index,
      items: barItems,
      onTap: (int index) => setState(() => this.index = index),
    );
  }

  Widget buildPages(args) {
    List pages = [Inventory(), Equipped(), Crafting()];
    return pages[index];
  }
}
