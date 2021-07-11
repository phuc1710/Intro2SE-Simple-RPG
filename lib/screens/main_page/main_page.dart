import 'package:flutter/material.dart';
import 'package:simple_rpg/screens/account_management/account_management.dart';
import 'package:simple_rpg/screens/inventory/inventory.dart';
import 'package:simple_rpg/screens/map_enemy/map_enemy.dart';
import 'package:simple_rpg/screens/view_profile/view_profile.dart';
import 'package:simple_rpg/screens/world_chat/world_chat.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, this.args}) : super(key: key);
  final args;
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
        // TODO: Explore more attribute of BottomNavigationBarItem
        icon: Icon(Icons.map),
        label: 'Map',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.inventory_2),
        label: 'Inventory',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.forum),
        label: 'Chat',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_box),
        label: 'Profile',
      ),
    ];
    if (args['user'].isAdmin) {
      barItems.add(BottomNavigationBarItem(
        icon: Icon(Icons.manage_accounts),
        label: 'Account',
      ));
    }
    return BottomNavigationBar(
      // TODO: Change backgroudColor,... but not working
      // TODO: Try it again, if it still, find the way to fix
      // TODO: Explore more attribute of BottomNavigationBar
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      unselectedLabelStyle: TextStyle(color: Colors.black),
      currentIndex: index,
      items: barItems,
      onTap: (int index) => setState(() => this.index = index),
    );
  }

  Widget buildPages(args) {
    //TODO: pass args for other like AccountManagement if neccessary
    List pages = [MapEnemy(), Inventory(), WorldChat(), ViewProfile()];
    if (args['user'].isAdmin) {
      pages.add(AccountManagement(args: args));
    }
    return pages[index];
  }
}
