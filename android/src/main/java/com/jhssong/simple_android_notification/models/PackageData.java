package com.jhssong.simple_android_notification.models;

import static com.jhssong.simple_android_notification.ErrorHandler.handleError;

import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;

import com.jhssong.simple_android_notification.ErrorHandler;

import org.json.JSONException;
import org.json.JSONObject;

import io.flutter.plugin.common.MethodChannel.Result;

public class PackageData {
    private final String packageName;
    private final String appName;
    private final boolean isSystemApp;

    public PackageData(ApplicationInfo appInfo, PackageManager packageManager) {
        this.packageName = appInfo.packageName;
        this.appName = appInfo.loadLabel(packageManager).toString();
        // TODO Figure out real system apps
        //this.isSystemApp = (appInfo.flags & ApplicationInfo.FLAG_SYSTEM) != 0;
        this.isSystemApp = packageManager.getLaunchIntentForPackage(appInfo.packageName) == null;
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
