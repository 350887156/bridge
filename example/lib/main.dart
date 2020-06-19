import 'package:flutter/material.dart';
import 'package:bridge/bridge.dart';
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isSimulator = false;

  @override
  void initState() {
    super.initState();
  }


    // Platform messages are asynchronous, so we initialize in an async method.


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('isSimulator '),
        ),
        body: Center(
          child: Text(isSimulator == true ? '模拟器' :'真真是机'),
        ),
      ),
    );
  }
}
