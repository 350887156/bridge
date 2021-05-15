package com.lajiaoyang.app.bridge;

import android.content.Context;
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import com.nirvana.tools.core.AppUtils;
import com.lajiaoyang.app.bridge.CustomUIUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import com.umeng.analytics.MobclickAgent;
import com.umeng.commonsdk.UMConfigure;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.mobile.auth.gatewayauth.AuthRegisterViewConfig;
import com.mobile.auth.gatewayauth.AuthRegisterXmlConfig;
import com.mobile.auth.gatewayauth.AuthUIConfig;
import com.mobile.auth.gatewayauth.AuthUIControlClickListener;
import com.mobile.auth.gatewayauth.CustomInterface;
import com.mobile.auth.gatewayauth.PhoneNumberAuthHelper;
import com.mobile.auth.gatewayauth.PreLoginResultListener;
import com.mobile.auth.gatewayauth.TokenResultListener;
import com.mobile.auth.gatewayauth.model.TokenRet;
import com.mobile.auth.gatewayauth.ui.AbstractPnsViewDelegate;

/** BridgePlugin */
public class BridgePlugin implements FlutterPlugin, MethodCallHandler {
  private  PhoneNumberAuthHelper authHelper;
  private BasicMessageChannel basicMessageChannel;
  private TokenResultListener mTokenListener;
  private static Activity mActivity;
  private static Context mContext;
  private int mScreenWidthDp;
  private int mScreenHeightDp;
  private FlutterAssets flutterAssets;
  
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    final MethodChannel channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "bridge");
    channel.setMethodCallHandler(new BridgePlugin());
    mContext = flutterPluginBinding.getApplicationContext();
    flutterAssets = flutterPluginBinding.getFlutterAssets();
    basicMessageChannel =  new BasicMessageChannel(flutterPluginBinding.getBinaryMessenger(),"com.lajiaoyang.ali_auth.BasicMessageChannel", StandardMessageCodec.INSTANCE);
  }
  public static void registerWith(Registrar registrar) {

    final MethodChannel channel = new MethodChannel(registrar.messenger(), "bridge");
    channel.setMethodCallHandler(new BridgePlugin());
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    

    if (call.method.startsWith("UMConfigure")) {
      handleUMConfigure(call,result);
    } else {
      switch (call.method) {
      case "init_ali_auth":
      {
        mTokenListener = new TokenResultListener() {
          @Override
          public void onTokenSuccess(final String s) {
            mActivity.runOnUiThread(new Runnable() {

              @Override
              public void run() {
                TokenRet tokenRet = null;
                try {
                  tokenRet = JSON.parseObject(s, TokenRet.class);
                } catch (Exception e) {
                  e.printStackTrace();
                }
                resultData(tokenRet);
              }
            });
          }

          @Override
          public void onTokenFailed(final String s) {
            mActivity.runOnUiThread(new Runnable() {

              @Override
              public void run() {
                TokenRet tokenRet = null;
                try {
                  tokenRet = JSON.parseObject(s, TokenRet.class);
                } catch (Exception e) {
                  e.printStackTrace();
                }
                resultData(tokenRet);
              }
            });
          }
        };
        authHelper = PhoneNumberAuthHelper.getInstance(mContext,mTokenListener);
        String appKey = call.argument("appKey");
        authHelper.setAuthSDKInfo(appKey);
      }
        break;
      case "pre":
        authHelper.accelerateLoginPage(5000, new PreLoginResultListener() {
          @Override
          public void onTokenSuccess(final String vendor) {
            mActivity.runOnUiThread(new Runnable() {
              @Override
              public void run() {
                JSONObject jsonObject = new JSONObject();
                jsonObject.put("code", vendor);
                jsonObject.put("msg", "预取号成功！");
                basicMessageChannel.send(jsonObject);
              }
            });
          }

          @Override
          public void onTokenFailed(final String vendor, final String ret) {
            mActivity.runOnUiThread(new Runnable() {
              @Override
              public void run() {
                JSONObject jsonObject = new JSONObject();
                jsonObject.put("code", ret);
                jsonObject.put("msg", "预取号失败");
                basicMessageChannel.send(jsonObject);
              }
            });
          }
        });
        break;
      case "login":
        login(call);
        break;

      case "debugLogin":
        login(call);
        break;

      case "checkEnvAvailable":
        authHelper.checkEnvAvailable(2);
        break;
      case "accelerateVerify":
        authHelper.accelerateVerify(5000, new PreLoginResultListener() {
          @Override
          public void onTokenSuccess(final String vendor) {
            mActivity.runOnUiThread(new Runnable() {
              @Override
              public void run() {
                JSONObject jsonObject = new JSONObject();
                jsonObject.put("code", vendor);
                jsonObject.put("msg", "加速获取本机号码成功！");
                basicMessageChannel.send(jsonObject);
              }
            });
          }

          @Override
          public void onTokenFailed(final String vendor, String errorMsg) {
            mActivity.runOnUiThread(new Runnable() {
              @Override
              public void run() {
                JSONObject jsonObject = new JSONObject();
                jsonObject.put("code", vendor);
                jsonObject.put("msg", "加速获取本机号码失败！");
                basicMessageChannel.send(jsonObject);
              }
            });
          }
        });
        break;

      case "checkDeviceCellularDataEnable":
        result.notImplemented();
        break;
      case "cancelLogin":
        authHelper.quitLoginPage();
        result.success(true);
        break;
      case "getCurrentCarrierName":
        result.success(authHelper.getCurrentCarrierName());
        break;
      case "encrypt":
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
        break;
      case "decrypt":
      {
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
      }
        break;
      case "getUDID":
      {
        String udid = DeviceTools.getDeviceId(context);;
        if (udid == null) {
          result.error("500","getUDID is Null","getUDID is Null");
        } else {
          result.success(udid);
        }
      }
        break;
      case "isSimulator":
      {
        boolean isSimulator = SimulatorUtil.isSimulator(context);
        result.success(isSimulator);
      }
        break;
      default:
        result.notImplemented();
        break;
    }
    }
  }
  /// 友盟 SDK处理
  private void handleUMConfigure(@NonNull MethodCall call, @NonNull Result result) {
    if ("UMConfigure.init".equals(call.method)) {
      String appKey = call.argument("androidAppKey");
      UMConfigure.init(context,appKey,"umeng",UMConfigure.DEVICE_TYPE_PHONE,"");
      android.util.Log.i("bridge_UMLog", "init");
    } else if("UMConfigure.log".equals(call.method)) {
      UMConfigure.setLogEnabled(true);
      android.util.Log.i("bridge_UMLog", "log");
    }
     else if ("UMConfigure.onPageStart".equals(call.method)) {
       String pageName = call.argument("pageName");
       MobclickAgent.onPageStart(pageName);
      android.util.Log.i("bridge_UMLog", "onPageStart");
    } else if ("UMConfigure.onPageEnd".equals(call.method)) {
      String pageName = call.argument("pageName");
      MobclickAgent.onPageEnd(pageName);
      android.util.Log.i("bridge_UMLog", "onPageEnd");
    } else if ("UMConfigure.pageManual".equals(call.method)) {
      MobclickAgent.setPageCollectionMode(MobclickAgent.PageMode.LEGACY_MANUAL);
      android.util.Log.i("bridge_UMLog", "pageManual");
    }
    else {
      result.notImplemented();
    }

  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
  }
}
