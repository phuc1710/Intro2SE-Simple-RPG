import 'package:flutter/material.dart';

class AccountManagement extends StatefulWidget {
  const AccountManagement({Key? key, this.args}) : super(key: key);
  final args;
  @override
  _AccountManagementState createState() => _AccountManagementState();
}

class _AccountManagementState extends State<AccountManagement> {
  @override
  Widget build(BuildContext context) {
    // TODO: Implement ACCOUNT MANAGEMENT
    return Container(
      child: Text("ACCOUNT MANAGEMENT"),
      alignment: Alignment.center,
    );
  }
}
