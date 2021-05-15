/*
 * @Author: your name
 * @Date: 2021-04-29 11:23:28
 * @LastEditTime: 2021-05-14 18:33:18
 * @LastEditors: your name
 * @Description: In User Settings Edit
 * @FilePath: /example/lib/main.dart
 */
import 'package:flutter/material.dart';

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
          child: Text(isSimulator == true ? '模拟器' : '真真是机'),
        ),
      ),
    );
  }
}
