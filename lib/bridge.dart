import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

class Bridge {
  static const MethodChannel _channel = const MethodChannel('bridge');
  static const BasicMessageChannel _basicMessageChannel = BasicMessageChannel(
      'com.lajiaoyang.ali_auth.BasicMessageChannel', StandardMessageCodec());
  static bool _init = false;
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

  static Future initAliAuth({String iOSKey, String androidKey}) async {
    if (_init == true) {
      return;
    }
    _init = true;
    Map<String, dynamic> parameter = {};
    if (Platform.isAndroid) {
      parameter['appKey'] = androidKey;
    } else {
      parameter['appKey'] = iOSKey;
    }
    return await _channel.invokeMethod('init_ali_auth', parameter);
  }

  static void setMessageHandler(Future Function(dynamic message) handler) {
    _basicMessageChannel.setMessageHandler(handler);
  }

  static Future prepareLogin() async {
    return await _channel.invokeMethod('pre');
  }

  static Future login(AliAuthUIConfig uiConfig) async {
    Map<String, dynamic> parameter = {};
    parameter['UIConfig'] = uiConfig.toMap();
    return await _channel.invokeMethod('login', parameter);
  }

  static Future debugLogin(AliAuthUIConfig uiConfig) async {
    Map<String, dynamic> parameter = {};
    parameter['UIConfig'] = uiConfig.toMap();
    return await _channel.invokeMethod('debugLogin', parameter);
  }

  static Future checkEnvAvailable() async {
    return await _channel.invokeMethod('checkEnvAvailable');
  }

  static Future accelerateVerify() async {
    return await _channel.invokeMethod('accelerateVerify');
  }

  static Future cancelLogin() async {
    return await _channel.invokeMethod('cancelLogin');
  }
}

class AliAuthUIConfig {
  String logoImage;
  List<String> loginBtnColors;
  AliAuthUIConfigPrivacy privacy;
  AliAuthUIConfig({this.logoImage, this.loginBtnColors, this.privacy});
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['logoImage'] = logoImage;
    if (loginBtnColors?.length == 3) {
      map['loginBtnColors'] =
          '${loginBtnColors[0]},${loginBtnColors[1]},${loginBtnColors[2]}';
    }
    if (privacy?.title != null && privacy?.url != null) {
      map['privacy'] = [privacy.title, privacy.url];
    }
    return map;
  }
}

class AliAuthUIConfigPrivacy {
  String title;
  String url;
  AliAuthUIConfigPrivacy({this.title, this.url});
}
