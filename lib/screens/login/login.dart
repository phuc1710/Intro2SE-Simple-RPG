import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:simple_rpg/screens/main_page/main_page.dart';
import '../../app.dart';
import '../../style.dart';
import '../../models/user.dart';

class Login extends StatefulWidget {
  Login({this.app});
  final FirebaseApp? app;
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _showPassword = false;
  final _formKey = GlobalKey<FormState>();
  User _user = User();
  final ref = FirebaseDatabase.instance.reference();
  var passwordValidator;

  @override
  Widget build(BuildContext context) {
    // GestureDetector to unfocus the keyboard when we tap the SafeArea
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: Scaffold(
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
                              dynamic data = snapshot
                                  .value[snapshot.value.keys.elementAt(0)];
                              if (data['password'] == _user.password) {
                                // get more info of user
                                _user.fromData(data);
                                // pass user to this to pass to MainPage
                                _onLoginSuccess(context, _user);
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
                        // when tap register button
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
        ),
      ),
    );
  }

  _onRegisterPress(BuildContext context) {
    // just pushReplacementNamed to avoid UX error
    Navigator.pushReplacementNamed(context, RegisterRoute);
  }

  _onLoginSuccess(BuildContext context, User user) {
    // push not replace cause if user want to login or register new accout
    // user just press back or tap back button on screen (if it exists)
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => MainPage(args: {'user': user})),
    );
  }
}
