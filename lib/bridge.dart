import 'dart:async';

import 'package:flutter/services.dart';

class Bridge {
  static const MethodChannel _channel =
      const MethodChannel('bridge');

  static Future<String> get getUDID async {
    final String version = await _channel.invokeMethod('getUDID');
    return version;
  }

  static Future<String> encrypt(String target,String key) async {
    final String result = await _channel.invokeMethod('encrypt',
        {
          'target':target,
          'key':key
        });
    return result;
  }
  static Future<String> decrypt(String target,String key) async {
    final String result = await _channel.invokeMethod('decrypt',
        {
          'target':target,
          'key':key
        });
    return result;
  }

  // ignore: missing_return
  static Future<bool> get isSimulator async {
    final result = await _channel.invokeMethod('isSimulator');
    return result;
  }
}
