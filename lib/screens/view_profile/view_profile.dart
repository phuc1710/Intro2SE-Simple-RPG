import 'dart:math';
import 'package:flutter/material.dart';
import 'package:simple_rpg/models/user.dart';
import 'package:simple_rpg/screens/view_profile/view_list_profile.dart';

class ViewProfile extends StatefulWidget {
  const ViewProfile({Key? key, this.user, this.profileUser, this.searchKey})
      : super(key: key);

  final user, profileUser, searchKey;
  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  var user, profileUser, searchKey, allUserRef;
  @override
  void initState() {
    super.initState();
    allUserRef = User.getAllUserRef();
    allUserRef?.onChildChanged.listen(_onAllUserChange);
    user = widget.user;
    profileUser = widget.profileUser;
    searchKey = widget.searchKey;
  }

  _onAllUserChange(event) {
    if (this.mounted) {
      setState(() {
        User changeUser = User();
        changeUser.fromData(event.snapshot.value);
        if (user.username == changeUser.username) user = changeUser;
        if (profileUser.username == changeUser.username)
          profileUser = changeUser;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> topWidgets = [
      TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue),
          splashFactory: NoSplash.splashFactory,
        ),
        child: Icon(
          Icons.search,
          color: Colors.white,
        ),
        onPressed: () {
          //GO TO SEARCH SCREEN
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ViewListProfile(user: user, searchKey: searchKey)));
        },
      ),
    ];
    if (user.username != profileUser.username) {
      topWidgets.insert(
          0,
          TextButton(
            onPressed: () {
              //BACK TO SEARCH SCREEN TO SEE PREVIOUS RESULT
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ViewListProfile(user: user, searchKey: searchKey)));
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
              splashFactory: NoSplash.splashFactory,
            ),
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ));
    }
    return user.username != profileUser.username
        ? SafeArea(
            child: Scaffold(
              body: getProWidget(topWidgets),
            ),
          )
        : getProWidget(topWidgets);
  }

  Padding getProWidget(List<Widget> topWidgets) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: user.username != profileUser.username
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.end,
            children: topWidgets,
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.badge, color: Colors.indigo),
              title: Text('Tên người dùng: ${profileUser.username}',
                  style: TextStyle(color: Colors.indigo)),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.signal_cellular_alt, color: Colors.purple),
              title: Text('Cấp độ: ${profileUser.level.toString()}',
                  style: TextStyle(color: Colors.purple)),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.api, color: Colors.blue),
              title: Text(
                  'Kinh nghiệm: ${profileUser.exp}/${((pow(profileUser.level, logBase(profileUser.level, 3))) * (100 - profileUser.level)).round()} (${(profileUser.exp / (pow(profileUser.level, logBase(profileUser.level, 3)) * (100 - profileUser.level) * 100)).round()}%)',
                  style: TextStyle(color: Colors.blue)),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.local_fire_department,
                color: Colors.green,
              ),
              title: Text('Tấn công: ${profileUser.atk.toString()}',
                  style: TextStyle(color: Colors.green)),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.favorite, color: Colors.red),
              title: Text('Máu: ${profileUser.hp.toString()}',
                  style: TextStyle(color: Colors.red)),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.polymer, color: Colors.yellow[800]),
              title: Text('Tiền: ${profileUser.gold.toString()}',
                  style: TextStyle(color: Colors.yellow[800])),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.verified, color: Colors.cyan),
              title: Text('Kinh nghiệm VIP: ${profileUser.vipExp.toString()}',
                  style: TextStyle(color: Colors.cyan)),
            ),
          ),
        ],
      ),
    );
  }

  double logBase(num x, num base) => log(x) / log(base);
}
