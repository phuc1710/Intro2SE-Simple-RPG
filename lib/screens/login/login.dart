import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import '../Inventory/INVENTORY/INVENTORY.dart';
import '../../app.dart';
import '../../style.dart';
import '../../models/user.dart';

class Login extends StatefulWidget {
  Login({this.app});
  final FirebaseApp? app;
  @override
  _LoginState createState() => _LoginState();
}

_onRegisterPress(BuildContext context) {
  Navigator.pushNamed(context, RegisterRoute);
}

class _LoginState extends State<Login> {
  bool _showPassword = false;
  final _formKey = GlobalKey<FormState>();
  final _user = User();
  final ref = FirebaseDatabase.instance.reference();
  var passwordValidator;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Builder(
        builder: (context) => Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Đăng nhập',
                  textAlign: TextAlign.center,
                  style: TitleTextStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 50.0, vertical: 20.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Tên người chơi',
                  ),
                  maxLines: 1,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return ('Vui lòng nhập tên người chơi!');
                    } else {
                      return passwordValidator;
                    }
                  },
                  onSaved: (val) => setState(() => _user.username = val!),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 50.0, vertical: 20.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Mật khẩu',
                    suffixIcon: IconButton(
                        icon: Icon(_showPassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        }),
                  ),
                  maxLines: 1,
                  obscureText: !_showPassword,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ('Vui lòng nhập mật khẩu!');
                    }
                  },
                  onSaved: (val) => setState(() => _user.password = val!),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 140.0, vertical: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    setState(() {
                      passwordValidator = null;
                    });
                    final form = _formKey.currentState;
                    if (form!.validate()) {
                      form.save();
                      ref
                          .child('users')
                          .orderByChild('username')
                          .equalTo(_user.username)
                          .once()
                          .then((DataSnapshot snapshot) {
                        if ((snapshot.value != null)) {
                          if (snapshot.value[snapshot.value.keys.elementAt(0)]
                                  ['password'] ==
                              _user.password) {
                            _showLoggedinDialog(context);
                            // Widget screen;
                            // screen = INVENTORY();
                            // return MaterialPageRoute(
                            //     builder: (BuildContext context) => screen);
                          } else {
                            setState(() => passwordValidator =
                                'Tài khoản hoặc mật khẩu không chính xác!');
                            form.validate();
                          }
                        } else {
                          setState(() => passwordValidator =
                              'Tài khoản hoặc mật khẩu không chính xác!');
                          form.validate();
                        }
                      });
                    }
                  },
                  child: Text(
                    'Đăng nhập',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 140.0, vertical: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    _onRegisterPress(context);
                  },
                  child: Text(
                    'Đăng kí ngay',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _showLoggedinDialog(BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Đăng nhập thành công')));
  }
}
