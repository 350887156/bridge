import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:bridge/bridge.dart';
import 'dart:io';
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
//    checkUpdate();
  }

  void checkUpdate() async {
    print('checkUpdate');
    Map <String,dynamic> parameter = {};
    if (Platform.isIOS) {
      parameter['platform'] = 'ios';
    } else if (Platform.isAndroid) {
      parameter['platform'] = 'android';
    }
    await Bridge.checkUpdate(url: 'http://182.92.172.156:8085/hhc/app/getAppInfo',parameter: parameter);
  }

    // Platform messages are asynchronous, so we initialize in an async method.


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
