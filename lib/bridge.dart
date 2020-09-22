import 'dart:async';
import 'package:flutter/services.dart';

class Bridge {
  static const MethodChannel _channel = const MethodChannel('bridge');

  static Future<String> get getUDID async {
    final String version = await _channel.invokeMethod('getUDID');
    return version;
  }

  static Future<String> encrypt(String target, String key) async {
    final String result =
        await _channel.invokeMethod('encrypt', {'target': target, 'key': key});
    return result;
  }

  static Future<String> decrypt(String target, String key) async {
    final String result =
        await _channel.invokeMethod('decrypt', {'target': target, 'key': key});
    return result;
  }

  static Future<bool> get isSimulator async {
    final result = await _channel.invokeMethod('isSimulator');
    return result;
  }

  static initUMeng(String iOSAppKey, String androidAppKey) async {
    await _channel.invokeMethod('UMConfigure.init',
        {'iOSAppKey': iOSAppKey, 'androidAppKey': androidAppKey});
  }

  static enabledUmengLog() async {
    await _channel.invokeMethod('UMConfigure.log');
  }

  static onPageStart(String pageName) async {
    await _channel.invokeMethod('UMConfigure.onPageStart', {
      'pageName': pageName,
    });
  }

  static onPageEnd(String pageName) async {
    await _channel.invokeMethod('UMConfigure.onPageEnd', {
      'pageName': pageName,
    });
  }

  static setPageCollectionModeManual() async {
    await _channel.invokeMethod('UMConfigure.pageManual');
  }
}
