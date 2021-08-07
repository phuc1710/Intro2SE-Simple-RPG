import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:simple_rpg/models/map.dart';
import 'package:simple_rpg/screens/map_enemy/enemy.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({Key? key, this.args}) : super(key: key);
  final args;

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  bool isInit = true;
  var allMaps;
  var page = 0;
  var lastPage;
  DatabaseReference? userRef;
  @override
  void initState() {
    super.initState();
    userRef = widget.args['user'].getUserRef();
    userRef?.onChildChanged.listen(_onLevelChange);
  }

  _onLevelChange(event) {
    if (this.mounted) {
      setState(() {
        DataSnapshot snapshot = event.snapshot;
        if (snapshot.key == 'level') {
          widget.args['user'].level = snapshot.value;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: GameMap.getMaps(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          allMaps = snapshot.data;
          isInit = false;
          var nonReverseList = [];
          for (var map in allMaps) {
            if (map.level <= widget.args['user'].level) {
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
                  leading:
                      Icon(Icons.map_rounded, size: 40.0, color: Colors.blue),
                  title: Text(
                    map.name,
                    style: TextStyle(fontSize: 20, color: Colors.cyan[500]),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        map.description,
                        overflow: TextOverflow.fade,
                      ),
                      Text(
                        'Cấp độ: ${map.level}',
                        style: TextStyle(color: Colors.purple),
                      )
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GameEnemy(
                                enemyList: map.enemyList.values.toList(),
                                args: widget.args)));
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
    ;
  }
}
