import 'package:flutter/material.dart';
import '../account_management/account_management.dart';

class AssignModerator extends StatefulWidget {
  const AssignModerator({ Key? key }) : super(key: key);

  @override
  _AssignModeratorState createState() => _AssignModeratorState();
}

class _AssignModeratorState extends State<AssignModerator> {
  @override
  Widget build(BuildContext context) {
    //Assign a player as moderator
    return Container(
      child: Text("ACCOUNT MANAGEMENT"),
      alignment: Alignment.center,
    );
  }
}