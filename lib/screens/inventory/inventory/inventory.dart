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
  var inventoryPage;
  void initState() {
    super.initState();
    inventoryPage = inventorySate();
  }

  @override
  Widget build(BuildContext context) {
    return inventoryPage;
  }

  Widget inventorySate() {
    final args = widget.args;
    List itemIDListInventory = args['user'].listInventory;
    List itemIdListEquipped = args['user'].listEquipped;
    var listAllItem = Item.getlistAllItem();
    return FutureBuilder<List>(
      future: listAllItem,
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          var listAllActualItem = snapshot.data;
          var userItemListInventory = [];
          var userItemListEquipped = [];
          for (var a in itemIDListInventory) {
            for (var b in listAllActualItem!) {
              if (a == b.id) userItemListInventory.add(b);
            }
          }
          for (var a in itemIdListEquipped) {
            for (var b in listAllActualItem!) {
              if (a == b.id) userItemListEquipped.add(b);
            }
          }
          return ListView.builder(
              shrinkWrap: true,
              itemCount: userItemListInventory.length,
              itemBuilder: (BuildContext context, int position) {
                var itemInventory = userItemListInventory[position];
                var itemEquipped = userItemListEquipped[position];
                var user = args['user'];
                var icons = [
                  'https://image.flaticon.com/icons/png/512/861/861891.png',
                  'https://image.flaticon.com/icons/png/512/812/812023.png',
                  'https://image.flaticon.com/icons/png/512/1065/1065435.png',
                  'https://image.flaticon.com/icons/png/512/2288/2288369.png',
                  'https://image.flaticon.com/icons/png/512/2043/2043907.png',
                ];
                var cardColor = [
                  Colors.red,
                  Colors.yellow,
                  Colors.green,
                  Colors.blue,
                  Colors.orange,
                ];
                return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    elevation: 5,
                    color: cardColor[itemInventory.type],
                    child: ListTile(
                        leading: Image(
                          image: NetworkImage(icons[itemInventory.type]),
                          width: 40.0,
                          height: 40.0,
                        ),
                        title: Text(
                          '${itemInventory.name}',
                          style: TextStyle(color: Colors.black),
                        ),
                        subtitle: Text((itemInventory.hp == 0
                                ? ''
                                : 'Hp + ${itemInventory.hp}    ') +
                            (itemInventory.atk == 0
                                ? ''
                                : 'Atk + ${itemInventory.atk}')),
                        trailing: PopupMenuButton<String>(
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem<String>(
                              value: 'equip',
                              child: Text('Trang bị'),
                            ),
                            PopupMenuItem<String>(
                              value: 'drop',
                              child: Text('Hủy vật phẩm'),
                            )
                          ],
                          onSelected: (result) {
                            setState(() {
                              switch (result) {
                                case 'equip':
                                  var invItemID = itemInventory.id;
                                  var equipItemID =
                                      user.listEquipped[itemInventory.type];
                                  user.listEquipped[itemInventory.type] =
                                      invItemID;
                                  user.listInventory[user.listInventory
                                      .indexOf(invItemID)] = equipItemID;

                                  user.health += itemInventory.hp;
                                  user.health -= itemEquipped.hp;
                                  user.attack += itemInventory.atk;
                                  user.attack -= itemEquipped.atk;

                                  user.save();
                                  inventoryPage = inventorySate();
                                  break;
                                case 'drop':
                                  user.removeItemFromListInv(itemInventory.id);
                                  user.save();
                                  inventoryPage = inventorySate();
                                  break;
                              }
                            });
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    getIn4Item(itemInventory)),
                          );
                        }));
              });
        }
        return SpinKitRing(
          color: Colors.blue,
        );
      },
    );
  }

  Column getIn4Item(item) {
    var listIn4 = ['Vũ khí', 'Nón', 'Áo', 'Quần', 'Giày'];
    return Column(
      children: [
        Card(
          child: ListTile(
            leading: Image(
              image: NetworkImage(
                  'https://image.flaticon.com/icons/png/512/2965/2965519.png'),
              width: 30.0,
              height: 30.0,
            ),
            title: Text('Tên: ' + item.name.toString()),
          ),
        ),
        Card(
          child: ListTile(
            leading: Image(
              image: NetworkImage(
                  'https://image.flaticon.com/icons/png/512/157/157933.png'),
              width: 30.0,
              height: 30.0,
            ),
            title: Text('Thông tin: ' + item.about.toString()),
          ),
        ),
        Card(
          child: ListTile(
            leading: Image(
              image: NetworkImage(
                  'https://image.flaticon.com/icons/png/512/4334/4334049.png'),
              width: 30.0,
              height: 30.0,
            ),
            title: Text('Tấn công: +' + item.atk.toString()),
          ),
        ),
        Card(
          child: ListTile(
            leading: Image(
              image: NetworkImage(
                  'https://image.flaticon.com/icons/png/512/154/154016.png'),
              width: 30.0,
              height: 30.0,
            ),
            title: Text('Máu: +' + item.hp.toString()),
          ),
        ),
        Card(
          child: ListTile(
            leading: Image(
              image: NetworkImage(
                  'https://image.flaticon.com/icons/png/512/3209/3209761.png'),
              width: 30.0,
              height: 30.0,
            ),
            title: Text('Loại trang bị: ' + listIn4[item.type]),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 140.0, vertical: 20.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Trở lại'),
          ),
        )
      ],
    );
  }
}
