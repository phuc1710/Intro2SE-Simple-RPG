import 'package:flutter/material.dart';
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
        label: 'TÚI ĐỒ',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'TRANG BỊ',
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
    List pages = [
      Inventory(args: args),
      Equipped(args: args),
    ];
    return pages[index];
  }
}
