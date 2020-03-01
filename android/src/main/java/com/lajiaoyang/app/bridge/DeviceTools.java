package com.lajiaoyang.app.bridge;
import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.bluetooth.BluetoothAdapter;
import android.content.Context;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Build;
import android.telephony.TelephonyManager;

import java.net.NetworkInterface;
import java.util.Collections;
import java.util.List;

public class DeviceTools {

    public static String getDeviceId(Context context) {
        StringBuilder stringBuilder = new StringBuilder();
        // 渠道标志
        stringBuilder.append("a");//android
        try {
            // IMEI（imei）
            String imei = getIMEI(context);
            if (!isEmpty(imei)) {
                stringBuilder.append("IMEI:");
                stringBuilder.append(imei);
                return stringBuilder.toString();
            }

            // 序列号（sn）
            String sn = getDeviceSN(context);
            if (!isEmpty(sn)) {
                stringBuilder.append("sn");
                stringBuilder.append(sn);
                return stringBuilder.toString();
            }
            // wifi mac地址
            String wifiMac = getLocalMacAddressOld(context);
            if (wifiMac.equals("02:00:00:00:00:00") || isEmpty(wifiMac)) {
                wifiMac = getLocalMacAddress(context);
            }
            if (!isEmpty(wifiMac)) {
                stringBuilder.append("mac");
                stringBuilder.append(wifiMac);
                return stringBuilder.toString();
            }

            String bluethId = getBluethId(context);
            if (!isEmpty(bluethId)) {
                stringBuilder.append("bluethId");
                stringBuilder.append(bluethId);
                return stringBuilder.toString();
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
            return manager.getDeviceId();
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
            return manager.getSimSerialNumber();
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
            return macString;
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
        String mBluethId= mBlueth.getAddress();
        return mBluethId;
    }
    private static boolean isEmpty(String str) {
        return str == null || "".equals(str.trim());
    }
}

