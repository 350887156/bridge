package com.lajiaoyang.app.bridge;

import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import com.umeng.commonsdk.UMConfigure;
import org.lzh.framework.updatepluginlib.model.Update;

import java.util.Map;

/** BridgePlugin */
public class BridgePlugin implements FlutterPlugin, MethodCallHandler {
  private  static  Context context;
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    context = flutterPluginBinding.getApplicationContext();
    final MethodChannel channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "bridge");
    channel.setMethodCallHandler(new BridgePlugin());
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  public static void registerWith(Registrar registrar) {

    final MethodChannel channel = new MethodChannel(registrar.messenger(), "bridge");
    channel.setMethodCallHandler(new BridgePlugin());
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getVersionCode")) {
      int versionCode = 0;
      try {
        PackageManager packageManager = context.getPackageManager();
        PackageInfo packageInfo = packageManager.getPackageInfo(
                context.getPackageName(), 0);
        versionCode = packageInfo.versionCode;
        result.success(versionCode);
      } catch (Exception e) {
        e.printStackTrace();
      }

    } else if (call.method.equals("getVersionName")) {
      String versionName = "";
      try {
        PackageManager packageManager = context.getPackageManager();
        PackageInfo packageInfo = packageManager.getPackageInfo(
                context.getPackageName(), 0);
        versionName = packageInfo.versionName;
      } catch (Exception e) {
        e.printStackTrace();
      }
      result.success(versionName);
    } else if ("encrypt".equals(call.method)) {
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
    } else if ("checkUpdate".equals(call.method)) {
      String url = call.argument("url");
      Map parameter = call.argument("parameter");
      if (url.startsWith("http")) {
        try {
          UpdateManager updateManager = UpdateManager.getInstance();
          updateManager.setup(url,parameter).startCheck();
        } catch (Exception e) {
          e.printStackTrace();
        }
      } else {
        result.error("-1","url error","url error");
      }
    } else {
      result.notImplemented();
    }
  }
  /// 友盟 SDK处理
  private void handleUMConfigure(@NonNull MethodCall call, @NonNull Result result) {
    if ("UMConfigure.init".equals(call.method)) {
      String appKey = call.argument("androidAppKey");
      UMConfigure.init(context,appKey,"umeng",UMConfigure.DEVICE_TYPE_PHONE,"");
    } else if("UMConfigure.log".equals(call.method)) {
      UMConfigure.setLogEnabled(true);
    } else {
      result.notImplemented();
    }

  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
  }
}
