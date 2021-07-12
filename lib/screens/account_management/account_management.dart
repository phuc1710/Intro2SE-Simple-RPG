import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:simple_rpg/models/user.dart';
import 'package:simple_rpg/screens/account_management/widgets/acc_man_button.dart';

class AccountManagement extends StatefulWidget {
  const AccountManagement({Key? key, this.args}) : super(key: key);
  final args;
  @override
  _AccountManagementState createState() => _AccountManagementState();
}

class _AccountManagementState extends State<AccountManagement> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: User.getUsers(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                User user = snapshot.data?[index];
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text(user.username),
                    trailing: AccManCardButton(
                      user: user,
                    ),
                    onTap: () {},
                  ),
                );
              });
        }
        return SpinKitRing(
          color: Colors.blue,
        );
      },
    );
  }
}
