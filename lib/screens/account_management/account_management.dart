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
  bool isSearch = false;
  bool isInit = true;
  var accManGeneral;
  var totalUsers;
  var page = 0;
  var lastPage;
  var showUsers;
  final searchController = TextEditingController();
  static const userPerPage = 10;
  static const topElePadding = 10.0;
  @override
  void initState() {
    super.initState();
    accManGeneral = getAccManGeneral(User.getUsers());
  }

  @override
  Widget build(BuildContext context) {
    return accManGeneral;
  }

  Column getAccManGeneral(dynamic list) {
    return Column(
      children: [
        Expanded(
          child: searchBar(),
        ),
        Expanded(
          flex: 7,
          child: isInit ? getAsync(list) : getSync(list),
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
                        accManGeneral = getAccManGeneral(getPageUsers());
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
                        accManGeneral = getAccManGeneral(getPageUsers());
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
            ),
          ),
          flex: 7),
      Expanded(
        child: TextButton(
          child: Icon(
            isSearch ? Icons.close : Icons.search,
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
                if (searchController.text != '') {
                  isSearch = !isSearch;
                  final searchKey = searchController.text.toLowerCase();
                  var matchUsers = [];
                  for (var user in totalUsers) {
                    if (user.username.toLowerCase().contains(searchKey)) {
                      matchUsers.add(user);
                    }
                  }
                  showUsers = matchUsers;
                  page = 0;
                  accManGeneral = getAccManGeneral(getPageUsers());
                }
              } else {
                searchController.clear();
                isSearch = !isSearch;
                page = 0;
                showUsers = totalUsers;
                accManGeneral = getAccManGeneral(getPageUsers());
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

  FutureBuilder<List<dynamic>> getAsync(Future<List<dynamic>> list) {
    return FutureBuilder<List>(
      future: list,
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          totalUsers = snapshot.data;
          showUsers = totalUsers;
          isInit = false;
          return getSync(getPageUsers());
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
                  trailing: AccManCardButton(
                    user: listUser,
                  ),
                  onTap: () {
                    setState(() {
                      // isGeneral = false;
                      // detailUser = listUser;
                      accManGeneral = getAccManDetail(listUser);
                    });
                  },
                ),
              );
            },
          );
  }

  Column getAccManDetail(detailUser) {
    return Column(
      children: [
        searchBar(
          backButton: Expanded(
            child: TextButton(
              onPressed: () {
                setState(() {
                  accManGeneral = getAccManGeneral(getPageUsers());
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
          ),
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

  List getPageUsers() {
    if (showUsers.length == 0) return showUsers;
    if (page == getLastPage()) return showUsers.sublist(page * userPerPage);
    return showUsers.sublist(page * userPerPage, (page + 1) * userPerPage);
  }

  int getLastPage() {
    return (showUsers.length / userPerPage).ceil() - 1;
  }
}
