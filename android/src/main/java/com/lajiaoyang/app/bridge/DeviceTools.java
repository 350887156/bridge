package com.lajiaoyang.app.bridge;
import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.bluetooth.BluetoothAdapter;
import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Build;
import android.telephony.TelephonyManager;
import android.util.DisplayMetrics;
import android.view.WindowManager;

import java.net.NetworkInterface;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DeviceTools {

    public  static  Map<String,String> getDeviceInfo(Context context) {
        Map<String, String> deviceInfo = new HashMap<String,String>();
        deviceInfo.put("plat","ANDROID");
        try {
            //手机品牌
            String brand = android.os.Build.BRAND;
            //手机型号
            String model = android.os.Build.MODEL;
            deviceInfo.put("dev_model",brand + " " + model);
            //获取屏幕
            WindowManager windowManager = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
            if (windowManager != null) {
                DisplayMetrics outMetrics = new DisplayMetrics();
                windowManager.getDefaultDisplay().getMetrics(outMetrics);
                int widthPixels = outMetrics.widthPixels;
                int heightPixels = outMetrics.heightPixels;
                deviceInfo.put("resolution",String.valueOf(widthPixels) + '*' + heightPixels);
            }

            //系统版本
            String systemVersion = android.os.Build.VERSION.RELEASE;
            deviceInfo.put("os_version","Android:" + systemVersion);

            String deviceId = getDeviceId(context);
            if (!isEmpty(deviceId)) {
                deviceInfo.put("device_id",deviceId);
            }
            //MAC地址
            String mac = getLocalMacAddressOld(context);
            if (!isEmpty(mac)) {
                deviceInfo.put("mac",mac);
            }

            PackageManager packageManager = context.getPackageManager();
            PackageInfo packageInfo = packageManager.getPackageInfo(
                    context.getPackageName(), 0);
            int versionCode = packageInfo.versionCode;
            deviceInfo.put("versionCode",String.valueOf(versionCode));
            deviceInfo.put("versionName",packageInfo.versionName);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return deviceInfo;
    }
    public  static String getMacAddress(Context context) {
        return  getLocalMacAddressOld(context);
    }
    public static String getDeviceId(Context context) {
        try {
            // IMEI（imei）
            String imei = getIMEI(context);
            if (!isEmpty(imei)) {
                return imei;
            }
            // 序列号（sn）
            String sn = getDeviceSN(context);
            if (!isEmpty(sn)) {
                return sn;
            }
            // wifi mac地址
            String wifiMac = getLocalMacAddressOld(context);
            if (!isEmpty(wifiMac)) {
                return wifiMac;
            }
            String bluethId = getBluethId(context);
            if (!isEmpty(bluethId)) {
                return  bluethId;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;

    }

    /**
     * 权限要求:android.permission.READ_PHONE_STATE
     * @param context
     * @return
     */
    @SuppressLint("MissingPermission")
    private static String getIMEI(Context context) {
        try {
            TelephonyManager manager = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
            if (manager == null) {
                return null;
            }
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.append("aIMEI:");
            String id = manager.getDeviceId();
            if (!isEmpty(id)) {
                stringBuilder.append(id);
            }
            return stringBuilder.toString();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }

    /**
     * 权限要求:android.permission.READ_PHONE_STATE
     * @param context
     * @return
     */
    @SuppressLint("MissingPermission")
    private static String getDeviceSN(Context context) {
        try {
            TelephonyManager manager = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
            if (manager == null) {
                return null;
            }
            StringBuilder stringBuilder = new StringBuilder();
            // 渠道标志
            stringBuilder.append("asn");//android
            String sn = manager.getSimSerialNumber();
            if (!isEmpty(sn)) {
                stringBuilder.append(sn);
            }
            return stringBuilder.toString();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }

    /**
     * 权限要求：android.permission.ACCESS_WIFI_STATE
     * @param context
     * @return
     */
    @TargetApi(Build.VERSION_CODES.GINGERBREAD)
    private static String getLocalMacAddress(Context context) {
        try {
            List<NetworkInterface> all = Collections.list(NetworkInterface.getNetworkInterfaces());
            for (NetworkInterface nif : all) {
                if (!nif.getName().equalsIgnoreCase("wlan0")) continue;

                byte[] macBytes = nif.getHardwareAddress();
                if (macBytes == null) {
                    return "";
                }

                StringBuilder res1 = new StringBuilder();
                for (byte b : macBytes) {
                    res1.append(String.format("%02X:",b));
                }

                if (res1.length() > 0) {
                    res1.deleteCharAt(res1.length() - 1);
                }
                return res1.toString();
            }
        } catch (Exception ex) {
        }
        return "";
    }
    /**
     * 权限要求：android.permission.ACCESS_WIFI_STATE
     * @param context
     * @return
     */
    @SuppressLint("MissingPermission")
    private static String getLocalMacAddressOld(Context context) {
        try {
            WifiManager wifi = (WifiManager) context.getSystemService(Context.WIFI_SERVICE);
            WifiInfo info = null;
            if (wifi != null) {
                info = wifi.getConnectionInfo();
            }
            String macString = "";
            if (info != null) {
                macString = info.getMacAddress();
            }
            if (macString.equals("02:00:00:00:00:00") || isEmpty(macString)) {
                macString = getLocalMacAddress(context);
            }
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.append("amac");
            if (!isEmpty(macString)) {
                stringBuilder.append(macString);
            }
            return stringBuilder.toString();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }




    /**
     * 权限要求：android.permission.BLUETOOTH
     * @param context
     * @return
     */
    @TargetApi(Build.VERSION_CODES.ECLAIR)
    @SuppressLint("MissingPermission")
    public static String getBluethId(Context context) {
        BluetoothAdapter mBlueth= BluetoothAdapter.getDefaultAdapter();
        String id = mBlueth.getAddress();
        StringBuilder stringBuilder = new StringBuilder();
        stringBuilder.append("abluethId");
        if (!isEmpty(id)) {
            stringBuilder.append(id);
        }
        return stringBuilder.toString();
    }
    private static boolean isEmpty(String str) {
        return str == null || "".equals(str.trim());
    }
}

