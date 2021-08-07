import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:math';
import 'package:simple_rpg/models/item.dart';

class Loot extends StatefulWidget {
  const Loot({Key? key, this.dropList, this.user}) : super(key: key);
  final dropList;
  final user;
  @override
  _LootState createState() => _LootState();
}

class _LootState extends State<Loot> {
  var dropItemIDList;

  _getDropItemIdList() {
    var ids = [];
    for (var id in widget.dropList.keys) {
      var rng = Random();
      if (rng.nextDouble() <= widget.dropList[id]) {
        ids.add(id);
      }
    }
    return ids;
  }

  @override
  void initState() {
    super.initState();
    dropItemIDList = _getDropItemIdList();
  }

  @override
  Widget build(BuildContext context) {
    var listAllItem = Item.getlistAllItem();
    return FutureBuilder<List>(
      future: listAllItem,
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          var listAllActualItem = snapshot.data;
          var dropItemList = [];
          for (var a in dropItemIDList) {
            for (var b in listAllActualItem!) {
              if (a == b.id && a != 'i00') dropItemList.add(b);
            }
          }
          var user = widget.user;
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text('Nhận thưởng'),
                automaticallyImplyLeading: false,
                backgroundColor: Colors.cyan[700],
              ),
              body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    dropItemList.length == 0
                        ? Expanded(
                            child: Center(
                              child: Text(
                                'Chúc bạn may mắn lần sau!',
                                style: TextStyle(fontSize: 25.0),
                              ),
                            ),
                            flex: 7,
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: dropItemList.length,
                            itemBuilder: (BuildContext context, int position) {
                              var itemDrop = dropItemList[position];
                              var user = widget.user;
                              var icons = [
                                'assets/images/vu_khi.png',
                                'assets/images/non.png',
                                'assets/images/ao.png',
                                'assets/images/quan.png',
                                'assets/images/giay.png',
                              ];
                              var cardColor = [
                                Colors.red[300],
                                Colors.yellow[300],
                                Colors.green[300],
                                Colors.blue[300],
                                Colors.orange[300],
                              ];
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                elevation: 5,
                                color: cardColor[itemDrop.type],
                                child: ListTile(
                                  leading: Image(
                                    image: AssetImage(icons[itemDrop.type]),
                                    width: 40.0,
                                    height: 40.0,
                                  ),
                                  title: Text(
                                    '${itemDrop.name}',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  subtitle: Row(
                                    children: [
                                      itemDrop.hp != 0
                                          ? Icon(
                                              Icons.favorite,
                                              size: 15,
                                            )
                                          : Text(''),
                                      Text(
                                        (itemDrop.hp == 0
                                            ? ''
                                            : ' HP +${itemDrop.hp} '),
                                      ),
                                      itemDrop.atk != 0
                                          ? Icon(
                                              Icons.local_fire_department,
                                              size: 15,
                                            )
                                          : Text(''),
                                      Text(
                                        (itemDrop.atk == 0
                                            ? ''
                                            : ' ATK +${itemDrop.atk}'),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    setState(
                                      () {
                                        user.addItem2ListInv(itemDrop.id);
                                        user.save();
                                        dropItemIDList.remove(itemDrop.id);
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.grey)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Bỏ qua'),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.cyan[700])),
                          onPressed: () {
                            for (var id in dropItemIDList) {
                              user.addItem2ListInv(id);
                              user.save();
                            }
                            Navigator.pop(context);
                          },
                          child: Text('Lấy tất cả'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        }
        return SpinKitRing(
          color: Colors.blue,
        );
      },
    );
  }
}
