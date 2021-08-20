import 'package:flutter/material.dart';
import 'package:simple_rpg/screens/account_management/account_management.dart';
import 'package:simple_rpg/screens/general_inventory/general_inventory.dart';
import 'package:simple_rpg/screens/map_enemy/map.dart';
import 'package:simple_rpg/screens/view_profile/view_profile.dart';
import 'package:simple_rpg/screens/world_chat/world_chat.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, this.args}) : super(key: key);
  // args pass from login, include user,...
  final args;
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    // get args passed
    final args = widget.args;
    return SafeArea(
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        bottomNavigationBar: buildBottomBar(args),
        body: buildPages(args),
      ),
    );
  }

  Widget buildBottomBar(args) {
    List<BottomNavigationBarItem> barItems = [
      BottomNavigationBarItem(
        icon: Icon(Icons.map),
        label: 'BẢN ĐỒ',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.inventory_2),
        label: 'HÀNH TRANG',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.forum),
        label: 'CHAT',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_box),
        label: 'THÔNG TIN',
      ),
    ];
    // check admin to add more for admin
    if (args['user'].isAdmin) {
      barItems.add(BottomNavigationBarItem(
        icon: Icon(Icons.admin_panel_settings),
        label: 'QUẢN LÝ TK',
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

  Widget buildPages(args) {
    List pages = [
      MapWidget(args: args),
      GeneralInventory(args: args),
      WorldChat(args: args),
      ViewProfile(
        user: args['user'],
        profileUser: args['user'],
        searchKey: '',
        isFromChat: false,
      )
    ];
    // like above, check admin to add more for admin
    if (args['user'].isAdmin) {
      pages.add(AccountManagement());
    }
    return pages[index];
  }
}
