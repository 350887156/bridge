import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
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
    initPlatformState();
  }


    // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    setState(() {
      isSimulator = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('isSimulator Test'),
        ),
        body: Center(
          child: Text(isSimulator == true ? '模拟器' :'真机'),
        ),
      ),
    );
  }
}
