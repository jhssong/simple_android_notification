package com.jhssong.simple_android_notification;

import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.os.Build;
import android.provider.Settings;
import android.service.notification.NotificationListenerService;

import androidx.annotation.RequiresApi;
import androidx.core.app.NotificationManagerCompat;

import com.jhssong.simple_android_notification.models.PackageData;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.List;
import java.util.Set;

import io.flutter.Log;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.Result;

@RequiresApi(api = Build.VERSION_CODES.O)
public class SimpleNotificationListener extends NotificationListenerService {
    private final Context context;
    private final SharedPref sPref;
    private final NotificationsDB notificationsDB;

    SimpleNotificationListener(Context context) {
        this.context = context;
        this.sPref = new SharedPref(context);
        this.notificationsDB = new NotificationsDB(context);
    }

    public void hasListenerPermission(Result result) {
        Set<String> notiListenerSet = NotificationManagerCompat.getEnabledListenerPackages(context);
        String myPackageName = context.getPackageName();

        for (String packageName : notiListenerSet) {
            if (packageName != null && packageName.equals(myPackageName)) {
                result.success(true);
                return;
            }
        }
        result.success(false);
    }

    public void openListenerPermissionSetting(Result result) {
        Intent intent = new Intent();
        intent.setAction(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        context.startActivity(intent);
        result.success(null);
    }

    public void getListenedNotifications(Result result) {
        result.success(notificationsDB.queryData(result).toString());
    }

    public void removeListenedNotifications(MethodCall call, Result result) {
        final String id = call.argument("id");
        int stringID = Integer.parseInt(id);
        notificationsDB.deleteData(stringID);
        result.success(null);
    }

    public void resetListenedNotifications(Result result) {
        notificationsDB.resetData();
        result.success(null);
    }

    public String addListenerFilter(String packageName) {
        JSONObject new_item = new JSONObject();
        try {
            new_item.put("packageName", packageName);
        } catch (JSONException e) {
            Log.e(Constants.LOG_TAG, e.getMessage());
            return "Failed";
        }
        final String res = sPref.addPref(Constants.LISTENER_FILTER_KEY, new_item);
        return res.equals("Success") ? "Added" : res;
    }

    public String getListenerFilter() {
        JSONArray listenerFilterList = sPref.getPref(Constants.LISTENER_FILTER_KEY);
        return listenerFilterList.toString();
    }

    public String removeListenerFilter(String packageName) {
        JSONArray old_array = sPref.getPref(Constants.LISTENER_FILTER_KEY);
        JSONArray new_array = new JSONArray();

        for (int i = 0; i < old_array.length(); i++) {
            try {
                JSONObject element = old_array.getJSONObject(i);
                if (packageName.equals(element.getString("packageName"))) continue;
                new_array.put(element);
            } catch (JSONException e) {
                Log.e(Constants.LOG_TAG, e.getMessage());
                return "Failed";
            }
        }
        final String res = sPref.setPref(Constants.LISTENER_FILTER_KEY, new_array);
        return res.equals("Success") ? "Removed" : res;
    }

    public String resetListenerFilter() {
        final String res = sPref.setPref(Constants.LISTENER_FILTER_KEY, new JSONArray());
        return res.equals("Success") ? "Reset" : res;
    }

    public void getPackageList(Result result) {
        PackageManager packageManager = context.getPackageManager();
        List<ApplicationInfo> installedApplications = packageManager.getInstalledApplications(PackageManager.GET_META_DATA);
        JSONArray list = new JSONArray();

        for (ApplicationInfo appInfo : installedApplications) {
            PackageData data = new PackageData(appInfo, packageManager);
            list.put(data.getAsJSON(result));
        }
        result.success(list.toString());
    }
}
