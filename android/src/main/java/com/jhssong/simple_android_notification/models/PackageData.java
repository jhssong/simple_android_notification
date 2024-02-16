package com.jhssong.simple_android_notification.models;

import static com.jhssong.simple_android_notification.ErrorHandler.handleError;

import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;

import com.jhssong.simple_android_notification.ErrorHandler;

import org.json.JSONException;
import org.json.JSONObject;

import io.flutter.plugin.common.MethodChannel.Result;

public class PackageData {
    String packageName;
    String appName;
    boolean isSystemApp;

    public PackageData(ApplicationInfo appInfo, PackageManager packageManager) {
        this.packageName = appInfo.packageName;
        this.appName = appInfo.loadLabel(packageManager).toString();
        this.isSystemApp = (appInfo.flags & ApplicationInfo.FLAG_SYSTEM) != 0;
    }


    public JSONObject getAsJSON(Result result) {
        JSONObject data = new JSONObject();
        try {
            data.put("packageName", packageName);
            data.put("appName", appName);
            data.put("isSystemApp", isSystemApp);
        } catch (JSONException e) {
            handleError(ErrorHandler.JSON_EXCEPTION, result, e);
        }
        return data;
    }
}
