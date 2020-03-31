import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
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

  static Future<bool> get isSimulator async {
    final result = await _channel.invokeMethod('isSimulator');
    return result;
  }
  static initUMeng(String iOSAppKey,String androidAppKey) async {
    await _channel.invokeMethod('UMConfigure.init',
        {
          'iOSAppKey':iOSAppKey,
          'androidAppKey':androidAppKey
        });
  }
  static enabledUmengLog() async {
    await _channel.invokeMethod('UMConfigure.log');
  }
  static Future<String> get versionName async {
    final String version = await _channel.invokeMethod('getVersionName');
    return version;
  }
  static Future<String> get versionCode async {
    final String version = await _channel.invokeMethod('getVersionCode');
    return version;
  }
  /*
  * App检查更新
  * */
  static Future<bool> checkUpdate({String url,Map<String,dynamic> parameter}) async {
    bool result = await _channel.invokeMethod('checkUpdate',
        {
          'url':url,
          'parameter':parameter
        });
    return result;
  }
  /*
  * 开屏广告准备
  * */
  static Future<bool> preloadSplash({@required String appId,@required String placementId}) async {
    bool result = await _channel.invokeMethod('advertisement.preloadSplash',
        {
          'appId':appId,
          'placementId':placementId,
        });
    return result;
  }
  /*
  * 展示开屏广告
  * */
  static Future<bool> showSplashAd({@required String appId,@required String placementId,@required String backgroundImage}) async {
    print('start');
    bool result = await _channel.invokeMethod('advertisement.aplashAd',
        {
          'appId':appId,
          'placementId':placementId,
          'backgroundImage':backgroundImage
        });
    return result;
  }
  /*
  * 播放激励视频
  * */
  static Future<bool> showRewardVideoAd({@required String appId,@required String placementId}) async {
    bool result = await _channel.invokeMethod('advertisement.rewardVideoAd',
        {
          'appId':appId,
          'placementId':placementId,
        });
    return result;
  }
}
