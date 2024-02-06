package com.jhssong.simple_android_notification;

import android.app.Notification;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import android.service.notification.NotificationListenerService;
import android.service.notification.StatusBarNotification;

import androidx.annotation.RequiresApi;
import androidx.core.app.NotificationManagerCompat;

import com.jhssong.simple_android_notification.models.NotificationInfo;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.time.Instant;
import java.util.Set;

import io.flutter.Log;

@RequiresApi(api = Build.VERSION_CODES.O)
public class SimpleNotificationListener extends NotificationListenerService {
    private final Context context;
    private final SharedPref sPref;

    SimpleNotificationListener(Context context) {
        this.context = context;
        this.sPref = new SharedPref(context);
    }

    public boolean hasNotificationListenerPermission() {
        Set<String> notiListenerSet = NotificationManagerCompat.getEnabledListenerPackages(context);
        String myPackageName = context.getPackageName();

        for (String packageName : notiListenerSet) {
            if (packageName == null) continue;
            if (packageName.equals(myPackageName)) return true;
        }
        return false;
    }

    public void openNotificationListenerPermissionSetting() {
        Intent intent = new Intent();
        intent.setAction(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        context.startActivity(intent);
    }

    public String getListenedNotificationsList() {
        JSONArray listenedNotificationsList = sPref.getPref(Constants.LISTENED_NOTIFICATIONS_KEY);
        return listenedNotificationsList.toString();
    }

    // TODO Handle when exception
    public void updateListenedNotificationsList(String id) {
        JSONArray old_array = sPref.getPref(Constants.LISTENED_NOTIFICATIONS_KEY);
        JSONArray new_array = new JSONArray();

        for (int i = 0; i < old_array.length(); i++) {
            try {
                JSONObject element = old_array.getJSONObject(i);
                if (id.equals(element.getString("id"))) continue;
                new_array.put(element);
            } catch (JSONException e) {
                Log.e(Constants.LOG_TAG, e.getMessage());
            }
        }
        sPref.setPref(Constants.LISTENED_NOTIFICATIONS_KEY, new_array);
    }

    public void resetListenedNotificationsList() {
        sPref.setPref(Constants.LISTENED_NOTIFICATIONS_KEY, new JSONArray());
    }

    // TODO Handle when exception
    public void setListenerFilter(String packageName) {
        JSONObject new_item = new JSONObject();
        try {
            new_item.put("packageName", packageName);
        } catch (JSONException e) {
            Log.e(Constants.LOG_TAG, e.getMessage());
        }
        sPref.addPref(Constants.LISTENER_FILTER_KEY, new_item);
    }

    public String getListenerFilter() {
        JSONArray listenerFilterList = sPref.getPref(Constants.LISTENER_FILTER_KEY);
        return listenerFilterList.toString();
    }

    // TODO Handle when exception
    public void updateListenerFilter(String packageName) {
        JSONArray old_array = sPref.getPref(Constants.LISTENER_FILTER_KEY);
        JSONArray new_array = new JSONArray();

        for (int i = 0; i < old_array.length(); i++) {
            try {
                JSONObject element = old_array.getJSONObject(i);
                if (packageName.equals(element.getString("packageName"))) continue;
                new_array.put(element);
            } catch (JSONException e) {
                Log.e(Constants.LOG_TAG, e.getMessage());
            }
        }
        sPref.setPref(Constants.LISTENER_FILTER_KEY, new_array);
    }

    public void resetListenerFilter() {
        sPref.setPref(Constants.LISTENER_FILTER_KEY, new JSONArray());
    }
}
