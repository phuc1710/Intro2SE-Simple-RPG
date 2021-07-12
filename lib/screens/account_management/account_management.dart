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
  bool isList = true;
  var show;
  var detailUser;
  @override
  Widget build(BuildContext context) {
    if (isList) {
      show = accManList();
    } else {
      show = accManDetail(detailUser);
    }
    return show;
  }

  FutureBuilder<List<dynamic>> accManList() {
    return FutureBuilder<List>(
      future: User.getUsers(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                User listUser = snapshot.data?[index];
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text(listUser.username),
                    trailing: AccManCardButton(
                      user: listUser,
                    ),
                    onTap: () {
                      setState(() {
                        isList = false;
                        detailUser = listUser;
                      });
                    },
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

  Column accManDetail(detailUser) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              isList = true;
            });
          },
          child: Text('Back'),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.badge),
            title: Text(detailUser.username),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.manage_accounts),
            title: Text(detailUser.isAdmin ? "YES" : "NO"),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.add_moderator),
            title: Text(detailUser.isMod ? "YES" : "NO"),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.cake),
            title: Text(detailUser.creationDate
                .substring(0, detailUser.creationDate.lastIndexOf('.'))),
          ),
        )
      ],
    );
  }
}
