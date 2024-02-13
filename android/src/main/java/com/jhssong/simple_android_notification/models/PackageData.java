package com.jhssong.simple_android_notification.models;

import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.util.Log;

import com.jhssong.simple_android_notification.Constants;

import org.json.JSONException;
import org.json.JSONObject;

public class PackageData {
    String packageName;
    String appName;
    boolean isSystemApp;

    public PackageData(ApplicationInfo appInfo, PackageManager packageManager) {
        this.packageName = appInfo.packageName;
        this.appName = appInfo.loadLabel(packageManager).toString();
        this.isSystemApp = (appInfo.flags & ApplicationInfo.FLAG_SYSTEM) != 0;
    }

    public JSONObject getAsJSON() {
        JSONObject data = new JSONObject();
        try {
            data.put("packageName", packageName);
            data.put("appName", appName);
            data.put("isSystemApp", isSystemApp);
        } catch (JSONException e) {
            Log.e(Constants.LOG_TAG, e.getMessage());
        }
        return data;
    }
}
