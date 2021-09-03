import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_rpg/models/user.dart';
import 'package:simple_rpg/screens/view_profile/view_list_profile.dart';

class ViewProfile extends StatefulWidget {
  const ViewProfile(
      {Key? key, this.user, this.profileUser, this.searchKey, this.isFromChat})
      : super(key: key);

  final user, profileUser, searchKey, isFromChat;
  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  var user, profileUser, searchKey, allUserRef, isFromChat, avatar;
  @override
  void initState() {
    super.initState();
    allUserRef = User.getAllUserRef();
    allUserRef?.onChildChanged.listen(_onAllUserChange);
    user = widget.user;
    profileUser = widget.profileUser;
    searchKey = widget.searchKey;
    isFromChat = widget.isFromChat;
  }

  _onAllUserChange(event) {
    if (this.mounted) {
      setState(() {
        User changeUser = User();
        changeUser.fromData(event.snapshot.value);
        if (user.username == changeUser.username) user = changeUser;
        if (profileUser.username == changeUser.username)
          profileUser = changeUser;
      });
    }
  }

  Future changeAvatar() async {
    var maxAvatarSize = MediaQuery.of(context).size.height;
    var picker = ImagePicker();
    var newAvatar = await picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: maxAvatarSize,
        maxWidth: maxAvatarSize);
    setState(() {
      var avatarPath = newAvatar?.path ?? '';
      if (avatarPath != '') {
        var avatarBytes = File(avatarPath).readAsBytesSync();
        var avatarStr = base64Encode(avatarBytes);
        profileUser.uploadAvatar(avatarStr);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (profileUser.avatar == '')
      avatar = User.getDefaultAvatarBuilder();
    else
      avatar = MemoryImage(Base64Decoder().convert(profileUser.avatar));
    List<Widget> topWidgets = [
      FocusedMenuHolder(
        menuWidth: MediaQuery.of(context).size.width * 0.50,
        blurSize: 2.0,
        menuItemExtent: 45,
        menuBoxDecoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        duration: Duration(milliseconds: 0),
        animateMenuItems: true,
        blurBackgroundColor: Colors.black54,
        openWithTap: true,
        menuOffset: 10.0,
        bottomOffsetHeight: 80.0,
        menuItems: [
          FocusedMenuItem(
            title: Text("Xem ảnh"),
            trailingIcon: Icon(
              Icons.image,
              color: Colors.blueAccent,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SafeArea(
                      child: Scaffold(
                    appBar: AppBar(),
                    body: Center(
                      child: Image(
                        image: avatar,
                      ),
                    ),
                  )),
                ),
              );
            },
          ),
          if (user.username == profileUser.username)
            FocusedMenuItem(
              title: Text(
                "Đổi ảnh",
                // style: TextStyle(color: Colors.redAccent),
              ),
              trailingIcon: Icon(
                Icons.add_photo_alternate,
                color: Colors.green[700],
              ),
              onPressed: () {
                changeAvatar();
              },
            ),
        ],
        onPressed: () {},
        child: CircleAvatar(
          backgroundImage: avatar,
          backgroundColor: Colors.transparent,
        ),
      )
    ];
    if (!isFromChat) {
      topWidgets.add(TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue),
          splashFactory: NoSplash.splashFactory,
        ),
        child: Icon(
          Icons.search,
          color: Colors.white,
        ),
        onPressed: () {
          //GO TO SEARCH SCREEN
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ViewListProfile(user: user, searchKey: searchKey)));
        },
      ));
    }
    if (user.username != profileUser.username) {
      topWidgets.insert(
          0,
          TextButton(
            onPressed: () {
              //BACK TO SEARCH SCREEN TO SEE PREVIOUS RESULT
              Navigator.pop(context);
              if (!isFromChat) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ViewListProfile(user: user, searchKey: searchKey)));
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
              splashFactory: NoSplash.splashFactory,
            ),
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ));
    }
    return user.username != profileUser.username
        ? SafeArea(
            child: Scaffold(
              body: getProWidget(topWidgets),
            ),
          )
        : getProWidget(topWidgets);
  }

  Padding getProWidget(List<Widget> topWidgets) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: topWidgets,
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.badge, color: Colors.indigo),
              title: Text('Tên: ${profileUser.username}',
                  style: TextStyle(color: Colors.indigo)),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.signal_cellular_alt, color: Colors.purple),
              title: Text('Cấp độ: ${profileUser.level.toString()}',
                  style: TextStyle(color: Colors.purple)),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.api, color: Colors.blue),
              title: Text(
                  'Kinh nghiệm: ${profileUser.exp}/${((pow(profileUser.level, logBase(profileUser.level, 3))) * (100 - profileUser.level)).round()} (${(profileUser.exp / (pow(profileUser.level, logBase(profileUser.level, 3)) * (100 - profileUser.level) * 100)).round()}%)',
                  style: TextStyle(color: Colors.blue)),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.local_fire_department,
                color: Colors.green,
              ),
              title: Text('Tấn công: ${profileUser.atk.toString()}',
                  style: TextStyle(color: Colors.green)),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.favorite, color: Colors.red),
              title: Text('Máu: ${profileUser.hp.toString()}',
                  style: TextStyle(color: Colors.red)),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.polymer, color: Colors.yellow[800]),
              title: Text('Tiền: ${profileUser.gold.toString()}',
                  style: TextStyle(color: Colors.yellow[800])),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.verified, color: Colors.cyan),
              title: Text('Kinh nghiệm VIP: ${profileUser.vipExp.toString()}',
                  style: TextStyle(color: Colors.cyan)),
            ),
          ),
        ],
      ),
    );
  }

  double logBase(num x, num base) => log(x) / log(base);
}
