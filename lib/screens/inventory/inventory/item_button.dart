import 'package:flutter/material.dart';
import 'package:simple_rpg/models/user.dart';

class ItemButton extends StatefulWidget {
  const ItemButton({Key? key, this.user}) : super(key: key);
  final user;
  @override
  _ItemButtonState createState() => _ItemButtonState();
}

class _ItemButtonState extends State<ItemButton> {
  User user = User();
  @override
  Widget build(BuildContext context) {
    user = widget.user;
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) =>
          [getModItem(user.isMod) /*more option here*/],
      onSelected: (result) {
        setState(() {
          switch (result) {
            case 'mod':
              user.changeMod();
              break;
          }
        });
      },
    );
  }

  PopupMenuItem<String> getModItem(isMod) {
    return PopupMenuItem<String>(
      value: 'mod',
      child: Text(isMod ? 'Remove Moderator' : 'Assign Moderator'),
    );
  }
}
