import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:simple_rpg/models/user.dart';
import 'package:simple_rpg/screens/view_profile/view_profile.dart';

class ViewListProfile extends StatefulWidget {
  const ViewListProfile({Key? key, this.user, this.searchKey})
      : super(key: key);
  final user, searchKey;
  @override
  _ViewListProfileState createState() => _ViewListProfileState();
}

class _ViewListProfileState extends State<ViewListProfile> {
  var totalUsers,
      page = 0,
      showUsers,
      searchKey,
      user,
      searchController = TextEditingController(),
      allUserRef;

  @override
  void initState() {
    super.initState();
    allUserRef = User.getAllUserRef();
    allUserRef?.onChildChanged.listen(_onAllUserChange);
    user = widget.user;
    searchKey = widget.searchKey;
  }

  _onAllUserChange(event) {
    if (this.mounted) {
      setState(() {
        User changeUser = User();
        changeUser.fromData(event.snapshot.value);
        for (var i = 0; i < totalUsers.length; ++i) {
          if (totalUsers[i].username == changeUser.username) {
            totalUsers.removeAt(i);
            totalUsers.insert(i, changeUser);
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: getViewProList(),
      ),
    );
  }

  Column getViewProList() {
    return Column(
      children: [
        Expanded(
          child: searchBar(),
        ),
        Expanded(
          flex: 7,
          child: getAsync(User.getUsers()),
        ),
      ],
    );
  }

  Padding searchBar() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                // BACK TO VIEW PROFILE
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                splashFactory: NoSplash.splashFactory,
              ),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Card(
                  child: TextField(
                    controller: searchController,
                  ),
                ),
              ),
              flex: 7),
          Expanded(
            child: TextButton(
              child: Icon(
                Icons.search,
                color: Colors.white,
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                splashFactory: NoSplash.splashFactory,
              ),
              onPressed: () {
                setState(() {
                  //TAP SEARCH BUTTON
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewListProfile(
                                user: user,
                                searchKey: searchController.text,
                              )));
                });
              },
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }

  FutureBuilder<List<dynamic>> getAsync(Future<List<dynamic>> list) {
    return FutureBuilder<List>(
      future: list,
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          totalUsers = snapshot.data;
          showUsers = totalUsers;
          var otherUsers = [];
          for (var u in totalUsers) {
            if (u.username != user.username &&
                u.username.toLowerCase().contains(searchKey.toLowerCase())) {
              otherUsers.add(u);
            }
          }
          totalUsers = otherUsers;
          return getSync(otherUsers);
        }
        return SpinKitRing(
          color: Colors.blue,
        );
      },
    );
  }

  Widget getSync(List<dynamic> list) {
    return list.length == 0
        ? Center(
            child: Text('Không tồn tại người dùng này'),
          )
        : ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              User listUser = list[index];
              return Card(
                child: ListTile(
                  leading: Icon(
                    Icons.account_circle,
                    color: Colors.blue,
                  ),
                  title: Text(listUser.username,
                      style: TextStyle(color: Colors.indigo)),
                  trailing: Text(
                    'Cấp độ: ' + listUser.level.toString(),
                    style: TextStyle(color: Colors.purple),
                  ),
                  onTap: () {
                    setState(() {
                      //GO TO TAPPED USER PROFILE
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewProfile(
                            user: user,
                            profileUser: listUser,
                            searchKey: searchKey,
                            isFromChat: false,
                          ),
                        ),
                      );
                    });
                  },
                ),
              );
            },
          );
  }
}
