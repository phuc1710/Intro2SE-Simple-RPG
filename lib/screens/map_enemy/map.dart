import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:simple_rpg/models/map.dart';
import 'package:simple_rpg/models/user.dart';
import 'package:simple_rpg/screens/map_enemy/enemy.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({Key? key, this.user}) : super(key: key);
  final user;

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  bool isInit = true;
  var mapGeneral;
  var allMaps;
  var page = 0;
  var lastPage;
  @override
  void initState() {
    super.initState();
    mapGeneral = getMapGeneral(GameMap.getMaps());
  }

  @override
  Widget build(BuildContext context) {
    return mapGeneral;
  }

  Column getMapGeneral(dynamic list) {
    return Column(
      children: [
        Expanded(
          child: isInit ? getAsync(list) : getSync(list),
        ),
      ],
    );
  }

  FutureBuilder<List<dynamic>> getAsync(Future<List<dynamic>> list) {
    return FutureBuilder<List>(
      future: list,
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          allMaps = snapshot.data;
          isInit = false;
          return getSync(allMaps);
        }
        return SpinKitRing(
          color: Colors.blue,
        );
      },
    );
  }

  Widget getSync(List<dynamic> allMaps) {
    return FutureBuilder<List>(
      future: User.getUsers(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          List users = snapshot.data!;
          User updateUser = widget.user;
          for (var user in users) {
            if (widget.user.username == user.username) {
              updateUser = user;
              break;
            }
          }
          var nonReverseList = [];
          for (var map in allMaps) {
            if (map.level <= updateUser.level) {
              nonReverseList.add(map);
            }
          }
          List list = new List.from(nonReverseList.reversed);
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              GameMap map = list[index];
              return Card(
                child: ListTile(
                  leading: Icon(Icons.map_rounded, size: 40.0),
                  title: Text(map.name),
                  subtitle: Text(map.description),
                  onTap: () {
                    setState(() {
                      mapGeneral = GameEnemy(
                          enemyList: map.enemyList.values.toList(),
                          user: updateUser);
                    });
                  },
                ),
              );
            },
          );
        }
        return SpinKitRing(
          color: Colors.blue,
        );
      },
    );
  }
}
