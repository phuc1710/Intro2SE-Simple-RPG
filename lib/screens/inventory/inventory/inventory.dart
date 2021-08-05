import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:simple_rpg/models/item.dart';

var itemRef = FirebaseDatabase.instance.reference();

class Inventory extends StatefulWidget {
  const Inventory({Key? key, this.args}) : super(key: key);
  final args;
  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  @override
  Widget build(BuildContext context) {
    final args = widget.args;
    List itemIdList = args['user'].listItem;
    var allListItem = Item.getListItem();
    return FutureBuilder<List>(
      future: allListItem,
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          var actualListItem = snapshot.data;
          var userItemList = [];
          for (var a in itemIdList) {
            for (var b in actualListItem!) {
              if (a == b.id) userItemList.add(b);
            }
          }
          return ListView.builder(
              shrinkWrap: true,
              itemCount: userItemList.length,
              itemBuilder: (BuildContext context, int position) {
                return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    elevation: 5,
                    color:
                        (position % 2) == 0 ? Colors.greenAccent : Colors.blue,
                    child: ListTile(
                      leading: Icon(Icons.arrow_right),
                      title: Text(
                        '${userItemList[position].name}',
                        style: TextStyle(color: Colors.purple),
                      ),
                      subtitle: Text((userItemList[position].hp == 0
                              ? ''
                              : 'Hp + ${userItemList[position].hp}') +
                          (userItemList[position].atk == 0
                              ? ''
                              : 'Atk + ${userItemList[position].atk}')),
                      // trailing: ItemButton(
                      //   user: args['user'],
                      // ),
                      onLongPress: () {
                        //TODO: chọn trang bị
                      },
                    ));
              });
        }
        return SpinKitRing(
          color: Colors.blue,
        );
      },
    );
  }
}
