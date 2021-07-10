import 'package:flutter/material.dart';
import 'screens/login/login.dart';
import 'screens/main_page/main_page.dart';
import 'screens/register/register.dart';

const LoginRoute = '/';
const RegisterRoute = '/register';
const MainPageRoute = '/mainpage';

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
        case MainPageRoute:
          screen = MainPage();
          break;
        default:
          return null;
      }
      return MaterialPageRoute(builder: (BuildContext context) => screen);
    };
  }
}
