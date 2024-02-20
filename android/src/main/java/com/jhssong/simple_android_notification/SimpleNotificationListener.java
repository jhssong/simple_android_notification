package com.jhssong.simple_android_notification;

import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.os.Build;
import android.provider.Settings;
import android.util.Log;

import androidx.core.app.NotificationManagerCompat;

import com.jhssong.simple_android_notification.models.FilterData;
import com.jhssong.simple_android_notification.models.PackageData;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.List;
import java.util.Map;
import java.util.Set;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.Result;

public class SimpleNotificationListener {
    private final Context context;
    private final ListenerFilters listenerFilters;
    private final NotificationsDB notificationsDB;

    SimpleNotificationListener(Context context) {
        this.context = context;
        this.listenerFilters = new ListenerFilters(context);
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
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP_MR1) {
            Intent intent = new Intent();
            intent.setAction(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS);
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            context.startActivity(intent);
        }
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

    // TODO Add reset package filter function

    public void resetListenedNotifications(Result result) {
        notificationsDB.resetData();
        result.success(null);
    }

    public void addListenerFilter(MethodCall call, Result result) {
        Map<String, Object> arguments = call.arguments();
        FilterData item = FilterData.from(arguments);
        listenerFilters.insertData(item.getAsJSON(result), result);
        result.success(null);
    }

    public void getListenerFilterList(Result result) {
        JSONObject listenerFilterList = listenerFilters.queryData(result);
        result.success(listenerFilterList.toString());
    }

    public JSONArray getListenerFilter(String packageName) {
        return listenerFilters.queryPackageData(packageName);
    }

    public void removeListenerFilter(MethodCall call, Result result) {
        Map<String, Object> arguments = call.arguments();
        FilterData item = FilterData.from(arguments);
        listenerFilters.deleteData(item.getAsJSON(result), result);
        result.success(null);
    }

    public void resetListenerFilter(Result result) {
        listenerFilters.resetData();
        result.success(null);
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
