import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:simple_rpg/models/user.dart';

class ViewProfile extends StatefulWidget {
  const ViewProfile({Key? key, this.args}) : super(key: key);

  final args;
  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  bool isSearch = false;
  bool isInit = true;
  var viewProList;
  var totalUsers;
  var page = 0;
  var lastPage;
  var showUsers;
  var searchIcon = Icons.dehaze;
  final searchController = TextEditingController();
  DatabaseReference? allUserRef;
  static const userPerPage = 10;
  static const topElePadding = 10.0;
  @override
  void initState() {
    super.initState();
    allUserRef = User.getAllUserRef();
    allUserRef?.onChildChanged.listen(_onAllUserChange);
    viewProList = getViewPro(widget.args['user'], true);
  }

  _onAllUserChange(event) {
    // if(this.mounted) {
    // setState(() {
    //   User changeUser = User();
    //   changeUser.fromData(event.snapshot.value);
    //   if (changeUser.username == widget.args['user'].username) {
    //     widget.args['user'] = changeUser;
    //   }
    //   isInit = false;
    //   print('change');
    // });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return viewProList;
  }

  Column getViewProList([searchKey]) {
    return Column(
      children: [
        Expanded(
          child: searchBar(),
        ),
        Expanded(
          flex: 7,
          child: isInit
              ? getAsync(User.getUsers(), searchKey)
              : getSync(getPageUsers(searchKey)),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      page--;
                      if (page >= 0)
                        viewProList = getViewProList();
                      else
                        page = 0;
                    });
                  },
                  child: Text('Previous'),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      page++;
                      if (page <= getLastPage())
                        viewProList = getViewProList();
                      else
                        page = getLastPage();
                    });
                  },
                  child: Text('Next'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Padding searchBar({backButton}) {
    List<Widget> searchBarWidgets = [
      Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextField(
              enabled: !isSearch,
              controller: searchController,
              onChanged: (val) {
                setState(() {
                  if (!isSearch) {
                    if (val.length == 0) {
                      searchIcon = Icons.dehaze;
                    } else {
                      searchIcon = Icons.search;
                    }
                    viewProList = getViewPro(widget.args['user'], true);
                  }
                });
              },
            ),
          ),
          flex: 7),
      Expanded(
        child: TextButton(
          child: Icon(
            searchIcon,
            color: Colors.white,
          ),
          style: ButtonStyle(
            backgroundColor: isSearch
                ? MaterialStateProperty.all(Colors.red[400])
                : MaterialStateProperty.all(Colors.blue),
            splashFactory: NoSplash.splashFactory,
          ),
          onPressed: () {
            setState(() {
              if (!isSearch) {
                isSearch = !isSearch;

                searchIcon = Icons.close;
                final searchKey = searchController.text.toLowerCase();
                page = 0;
                viewProList = getViewProList(searchKey);
              } else {
                searchController.clear();
                searchIcon = Icons.dehaze;
                isSearch = !isSearch;
                viewProList = getViewPro(widget.args['user'], true);
              }
            });
          },
        ),
        flex: 1,
      ),
    ];
    if (backButton != null) {
      searchBarWidgets.insert(0, backButton);
    }
    return Padding(
      padding: EdgeInsets.all(topElePadding),
      child: Row(children: searchBarWidgets),
    );
  }

  FutureBuilder<List<dynamic>> getAsync(
      Future<List<dynamic>> list, String searchKey) {
    return FutureBuilder<List>(
      future: list,
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          totalUsers = snapshot.data;
          showUsers = totalUsers;
          isInit = false;
          return getSync(getPageUsers(searchKey));
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
            child: Text('NO USER'),
          )
        : ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              User listUser = list[index];
              return Card(
                child: ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text(listUser.username),
                  trailing: Text('level ' + listUser.level.toString()),
                  onTap: () {
                    setState(() {
                      // isGeneral = false;
                      // detailUser = listUser;
                      viewProList = getViewPro(listUser, false);
                    });
                  },
                ),
              );
            },
          );
  }

  Column getViewPro(detailUser, isMyProfile) {
    var backButton;
    if (!isMyProfile) {
      backButton = Expanded(
        child: TextButton(
          onPressed: () {
            setState(() {
              viewProList = getViewProList();
            });
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
      );
    }
    return Column(
      children: [
        searchBar(
          backButton: backButton,
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.badge),
            title: Text(detailUser.username),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.signal_cellular_alt),
            title: Text(detailUser.level.toString()),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.donut_large),
            title: Text(detailUser.exp.toString()),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.colorize),
            title: Text(detailUser.atk.toString()),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.health_and_safety),
            title: Text(detailUser.hp.toString()),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.polymer),
            title: Text(detailUser.gold.toString()),
          ),
        )
      ],
    );
  }

  List getPageUsers([searchKey]) {
    if (searchKey != null) {
      var matchUsers = [];
      for (var user in totalUsers) {
        if (user.username.toLowerCase().contains(searchKey)) {
          matchUsers.add(user);
        }
      }
      showUsers = matchUsers;
    }
    if (showUsers.length == 0) return showUsers;
    if (page == getLastPage()) return showUsers.sublist(page * userPerPage);
    return showUsers.sublist(page * userPerPage, (page + 1) * userPerPage);
  }

  int getLastPage() {
    return (showUsers.length / userPerPage).ceil() - 1;
  }
}
