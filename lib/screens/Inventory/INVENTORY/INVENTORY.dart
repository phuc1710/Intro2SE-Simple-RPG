import 'package:flutter/material.dart';

class INVENTORY extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Generated App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF2196f3),
        accentColor: const Color(0xFF0067ba),
        canvasColor: const Color(0xFFb6b6b6),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SIMPLE RPG'),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                      key: null,
                      onPressed: buttonPressed,
                      child: Text(
                        "EQUIPPED",
                        style: TextStyle(
                            fontSize: 12.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w500,
                            fontFamily: "Roboto"),
                      )),
                  TextButton(
                      key: null,
                      onPressed: buttonPressed,
                      child: Text(
                        "INVENTORY",
                        style: TextStyle(
                            fontSize: 12.0,
                            color: const Color(0xFFffffff),
                            fontWeight: FontWeight.w500,
                            fontFamily: "Roboto"),
                      )),
                  TextButton(
                      key: null,
                      onPressed: buttonPressed,
                      child: Text(
                        "CRAFTING",
                        style: TextStyle(
                            fontSize: 12.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w500,
                            fontFamily: "Roboto"),
                      ))
                ]),
            SizedBox(
              height: 507,
              width: 411,
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: <Widget>[
                  TextButton(
                      key: null,
                      onPressed: buttonPressed,
                      child: Text(
                        "ĐỒ A",
                        style: TextStyle(
                            fontSize: 12.0,
                            //color: const Color(0xFF000003),
                            fontWeight: FontWeight.w500,
                            fontFamily: "Roboto"),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.greenAccent),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                      )),
                  TextButton(
                      key: null,
                      onPressed: buttonPressed,
                      child: Text(
                        "ĐỒ B",
                        style: TextStyle(
                            fontSize: 12.0,
                            //color: const Color(0xFF000002),
                            fontWeight: FontWeight.w500,
                            fontFamily: "Roboto"),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.greenAccent),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                      )),
                  TextButton(
                      key: null,
                      onPressed: buttonPressed,
                      child: Text(
                        "ĐỒ C",
                        style: TextStyle(
                            fontSize: 12.0,
                            //color: const Color(0xFF000001),
                            fontWeight: FontWeight.w500,
                            fontFamily: "Roboto"),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.greenAccent),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                      )),
                ],
              ),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                      key: null,
                      onPressed: buttonPressed,
                      child: Text(
                        "MAP",
                        style: TextStyle(
                            fontSize: 12.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w500,
                            fontFamily: "Roboto"),
                      )),
                  TextButton(
                      key: null,
                      onPressed: buttonPressed,
                      child: Text(
                        "INVENTORY",
                        style: TextStyle(
                            fontSize: 12.0,
                            color: const Color(0xFFffffff),
                            fontWeight: FontWeight.w500,
                            fontFamily: "Roboto"),
                      )),
                  TextButton(
                      key: null,
                      onPressed: buttonPressed,
                      child: Text(
                        "CHAT",
                        style: TextStyle(
                            fontSize: 12.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w500,
                            fontFamily: "Roboto"),
                      )),
                  TextButton(
                      key: null,
                      onPressed: buttonPressed,
                      child: Text(
                        "FROFILE",
                        style: TextStyle(
                            fontSize: 12.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w500,
                            fontFamily: "Roboto"),
                      ))
                ])
          ]),
      // floatingActionButton: FloatingActionButton(
      //     backgroundColor: const Color(0xFF043a8a),
      //     child: Icon(Icons.tablet_android),
      //     onPressed: fabPressed),
    );
  }

  void buttonPressed() {}
  //void fabPressed() {}
}
