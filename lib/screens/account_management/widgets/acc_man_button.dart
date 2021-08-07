import 'package:flutter/material.dart';
import 'package:simple_rpg/models/user.dart';

class AccManCardButton extends StatefulWidget {
  const AccManCardButton({Key? key, this.user}) : super(key: key);
  final user;
  @override
  _AccManCardButtonState createState() => _AccManCardButtonState();
}

class _AccManCardButtonState extends State<AccManCardButton> {
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
      child: Text(isMod ? 'Gỡ quyền kiểm duyệt' : 'Cấp quyền kiểm duyệt'),
    );
  }
}
