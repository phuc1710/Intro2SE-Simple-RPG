import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:simple_rpg/models/item.dart';

var itemRef = FirebaseDatabase.instance.reference();

class Equipped extends StatefulWidget {
  const Equipped({Key? key, this.args}) : super(key: key);
  final args;
  @override
  _EquippedState createState() => _EquippedState();
}

class _EquippedState extends State<Equipped> {
  var equippedPage;
  void initState() {
    super.initState();
    equippedPage = equippedState();
  }

  @override
  Widget build(BuildContext context) {
    return equippedPage;
  }

  Widget equippedState() {
    final args = widget.args;
    List itemIdListEquipped = args['user'].listEquipped;
    var listAllItem = Item.getlistAllItem();
    return FutureBuilder<List>(
      future: listAllItem,
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          var listAllActualItem = snapshot.data;
          var userItemListEquipped = [];
          for (var a in itemIdListEquipped) {
            for (var b in listAllActualItem!) {
              if (a == b.id) userItemListEquipped.add(b);
            }
          }
          return ListView.builder(
              shrinkWrap: true,
              itemCount: userItemListEquipped.length,
              itemBuilder: (BuildContext context, int position) {
                var itemEquipped = userItemListEquipped[position];
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
                    color: cardColor[itemEquipped.type],
                    child: ListTile(
                        leading: Image(
                          image: AssetImage(icons[itemEquipped.type]),
                          width: 40.0,
                          height: 40.0,
                        ),
                        title: Text(
                          '${itemEquipped.name}',
                          style: TextStyle(color: Colors.black),
                        ),
                        subtitle: Row(
                          children: [
                            itemEquipped.hp != 0
                                ? Icon(
                                    Icons.favorite,
                                    size: 15,
                                  )
                                : Text(''),
                            Text(
                              (itemEquipped.hp == 0
                                  ? ''
                                  : ' HP +${itemEquipped.hp} '),
                            ),
                            itemEquipped.atk != 0
                                ? Icon(
                                    Icons.local_fire_department,
                                    size: 15,
                                  )
                                : Text(''),
                            Text(
                              (itemEquipped.atk == 0
                                  ? ''
                                  : ' ATK +${itemEquipped.atk}'),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => getIn4Item(itemEquipped)),
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
        ));
  }
}
