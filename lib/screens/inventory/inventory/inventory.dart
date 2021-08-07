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
  DatabaseReference? invItemsRef;
  List itemIDListInventory = [];
  @override
  void initState() {
    super.initState();
    widget.args['user'].listInventory = [];
    invItemsRef = Item.getInvItemsDBRef(widget.args['user'].id);
    invItemsRef?.onChildAdded.listen(_onInvItemAdded);
  }

  _onInvItemAdded(event) {
    setState(() {
      widget.args['user'].addItem2ListInv(event.snapshot.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    var listAllItem = Item.getlistAllItem();
    itemIDListInventory = widget.args['user'].listInventory;
    List itemIdListEquipped = widget.args['user'].listEquipped;
    return FutureBuilder<List>(
      future: listAllItem,
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          var listAllActualItem = snapshot.data;
          var userItemListInventory = [];
          var userItemListEquipped = [];
          for (var a in itemIDListInventory) {
            for (var b in listAllActualItem!) {
              if (a == b.id && a != 'i00') userItemListInventory.add(b);
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
                var itemEquipped = userItemListEquipped[itemInventory.type];
                var user = widget.args['user'];
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
                    color: cardColor[itemInventory.type],
                    child: ListTile(
                        leading: Image(
                          image: AssetImage(icons[itemInventory.type]),
                          width: 40.0,
                          height: 40.0,
                        ),
                        title: Text(
                          '${itemInventory.name}',
                          style: TextStyle(color: Colors.black),
                        ),
                        subtitle: Row(
                          children: [
                            itemInventory.hp != 0
                                ? Icon(
                                    Icons.favorite,
                                    size: 15,
                                  )
                                : Text(''),
                            Text(
                              (itemInventory.hp == 0
                                  ? ''
                                  : ' HP +${itemInventory.hp} '),
                            ),
                            itemInventory.atk != 0
                                ? Icon(
                                    Icons.local_fire_department,
                                    size: 15,
                                  )
                                : Text(''),
                            Text(
                              (itemInventory.atk == 0
                                  ? ''
                                  : ' ATK +${itemInventory.atk}'),
                            ),
                          ],
                        ),
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
                                  user.hp += itemInventory.hp;
                                  user.hp -= itemEquipped.hp;
                                  user.atk += itemInventory.atk;
                                  user.atk -= itemEquipped.atk;

                                  user.save();
                                  break;
                                case 'drop':
                                  user.removeItemFromListInv(itemInventory.id);
                                  user.save();
                                  break;
                              }
                            });
                          },
                        ),
                        onTap: () {
                          Navigator.of(context).push(
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

  Widget getIn4Item(item) {
    var listIn4 = ['Vũ khí', 'Nón', 'Áo', 'Quần', 'Giày'];
    return Container(
      color: Colors.grey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            child: ListTile(
              leading: Image(
                image: AssetImage('assets/images/ten.png'),
                width: 30.0,
                height: 30.0,
              ),
              title: Text('Tên: ' + item.name.toString()),
            ),
          ),
          Card(
            child: ListTile(
              leading: Image(
                image: AssetImage('assets/images/thong_tin.png'),
                width: 30.0,
                height: 30.0,
              ),
              title: Text('Thông tin: ' + item.about.toString()),
            ),
          ),
          Card(
            child: ListTile(
              leading: Image(
                image: AssetImage('assets/images/tan_cong.png'),
                width: 30.0,
                height: 30.0,
              ),
              title: Text('Tấn công: +' + item.atk.toString()),
            ),
          ),
          Card(
            child: ListTile(
              leading: Image(
                image: AssetImage('assets/images/mau.png'),
                width: 30.0,
                height: 30.0,
              ),
              title: Text('Máu: +' + item.hp.toString()),
            ),
          ),
          Card(
            child: ListTile(
              leading: Image(
                image: AssetImage('assets/images/loai_trang_bi.png'),
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
      ),
    );
  }
}
