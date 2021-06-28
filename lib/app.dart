import 'package:flutter/material.dart';
import 'screens/login/login.dart';
import 'screens/register/register.dart';

const LoginRoute = '/';
const RegisterRoute = '/register';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //   initialRoute: LoginRoute,
      //   routes: {
      //     LoginRoute: (context) => Login(),
      //     RegisterRoute: (context) => Register(),
      //   },
      // );
      debugShowCheckedModeBanner: false,
      onGenerateRoute: _routes(),
    );
  }

  RouteFactory _routes() {
    return (settings) {
      Widget screen;
      switch (settings.name) {
        case LoginRoute:
          screen = Login();
          break;
        case RegisterRoute:
          screen = Register();
          break;
        default:
          return null;
      }
      return MaterialPageRoute(builder: (BuildContext context) => screen);
    };
  }
}
