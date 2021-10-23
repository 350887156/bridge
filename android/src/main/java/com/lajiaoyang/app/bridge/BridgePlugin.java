package com.lajiaoyang.app.bridge;

import android.content.Context;
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** BridgePlugin */
public class BridgePlugin implements FlutterPlugin, MethodCallHandler {
  private  static  Context context;
  private MethodChannel channel;
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    context = flutterPluginBinding.getApplicationContext();
    this.channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "bridge");
    channel.setMethodCallHandler(this);
  }


  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if ("encrypt".equals(call.method)) {
      String key = call.argument("key");
      String target = call.argument("target");
      try {
        String decrypt = AESCryptor.encrypt(target,key);
        if (decrypt != null) {
          result.success(decrypt);
        }
        
      } catch(Exception e) {
        e.printStackTrace();
      }
    } else if ("decrypt".equals(call.method)) {
      String key = call.argument("key");
      String target = call.argument("target");
      try {
        String decrypt = AESCryptor.decrypt(target,key);
        if (decrypt != null) {
          result.success(decrypt);
        }
      } catch(Exception e) {
        e.printStackTrace();
      }
    } else if ("getUDID".equals(call.method)) {
      String udid = DeviceTools.getDeviceId(context);;
      if (udid == null) {
        result.error("500","getUDID is Null","getUDID is Null");
      } else {
        result.success(udid);
      }
    } else if ("isSimulator".equals(call.method)) {
      boolean isSimulator = SimulatorUtil.isSimulator(context);
      result.success(isSimulator);

    } else if (call.method.startsWith("UMConfigure")) {
      handleUMConfigure(call,result);
    } else {
      result.notImplemented();
    }
  }
  /// 友盟 SDK处理
  private void handleUMConfigure(@NonNull MethodCall call, @NonNull Result result) {
    if ("UMConfigure.init".equals(call.method)) {
//      String appKey = call.argument("androidAppKey");
//      UMConfigure.init(context,appKey,"umeng",UMConfigure.DEVICE_TYPE_PHONE,"");
//      android.util.Log.i("bridge_UMLog", "init");
    } else if("UMConfigure.log".equals(call.method)) {
//      UMConfigure.setLogEnabled(true);
      android.util.Log.i("bridge_UMLog", "log");
    }
     else if ("UMConfigure.onPageStart".equals(call.method)) {
//       String pageName = call.argument("pageName");
//       MobclickAgent.onPageStart(pageName);
//      android.util.Log.i("bridge_UMLog", "onPageStart");
    } else if ("UMConfigure.onPageEnd".equals(call.method)) {
//      String pageName = call.argument("pageName");
//      MobclickAgent.onPageEnd(pageName);
//      android.util.Log.i("bridge_UMLog", "onPageEnd");
    } else if ("UMConfigure.pageManual".equals(call.method)) {
//      MobclickAgent.setPageCollectionMode(MobclickAgent.PageMode.LEGACY_MANUAL);
//      android.util.Log.i("bridge_UMLog", "pageManual");
    }
    else {
      result.notImplemented();
    }

  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
