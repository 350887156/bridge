import 'package:flutter/material.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:bridge/bridge.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    requestPermission();
    initPlatformState();
  }
  Future requestPermission() async {
    // 申请权限

    Map<PermissionGroup, PermissionStatus> permissions =

    await PermissionHandler().requestPermissions([PermissionGroup.phone,PermissionGroup.storage]);

    // 申请结果

    PermissionStatus permission =

    await PermissionHandler().checkPermissionStatus(PermissionGroup.phone);

    if (permission == PermissionStatus.granted) {
      print('权限申请通过');
    } else {
      print('权限申请被拒绝');
    }
  }

    // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await Bridge.getUDID;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
