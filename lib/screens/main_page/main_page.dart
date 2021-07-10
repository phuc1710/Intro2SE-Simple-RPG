import 'package:flutter/material.dart';
import 'package:simple_rpg/screens/account_management/account_management.dart';
import 'package:simple_rpg/screens/inventory/inventory.dart';
import 'package:simple_rpg/screens/map_enemy/map_enemy.dart';
import 'package:simple_rpg/screens/view_profile/view_profile.dart';
import 'package:simple_rpg/screens/world_chat/world_chat.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 0;
  bool isAdmin = false;
  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          bottomNavigationBar: buildBottomBar(),
          body: buildPages(),
        ),
      );

  Widget buildBottomBar() {
    List<BottomNavigationBarItem> barItems = [
      BottomNavigationBarItem(
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
    if (isAdmin) {
      barItems.add(BottomNavigationBarItem(
        icon: Icon(Icons.manage_accounts),
        label: 'Account',
      ));
    }
    return BottomNavigationBar(
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      unselectedLabelStyle: TextStyle(color: Colors.black),
      currentIndex: index,
      items: barItems,
      onTap: (int index) => setState(() => this.index = index),
    );
  }

  Widget buildPages() {
    List pages = [MapEnemy(), Inventory(), WorldChat(), ViewProfile()];
    if (isAdmin) {
      pages.add(AccountManagement());
    }
    return pages[index];
  }
}
