package com.jhssong.simple_android_notification;

import android.content.Context;
import android.os.Build;
import android.os.Bundle;
import android.service.notification.NotificationListenerService;
import android.service.notification.StatusBarNotification;

import androidx.annotation.RequiresApi;

import com.jhssong.simple_android_notification.models.NotificationData;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.time.Instant;

import io.flutter.Log;

@RequiresApi(api = Build.VERSION_CODES.O)
public class SimpleNotificationListenerService extends NotificationListenerService {
    @Override
    public void onNotificationPosted(StatusBarNotification sbn) {
        // TODO Show notification when proper notification was received
        //      (make this feature controllable)
        Context context = getApplicationContext();
        NotificationsDB notificationsDB = new NotificationsDB(context);
        SimpleNotificationListener simpleNotificationListener = new SimpleNotificationListener(context);

        String id = Long.toString(Instant.now().toEpochMilli());
        String packageName = sbn != null ? sbn.getPackageName() : "Null";

        String filterString = simpleNotificationListener.getListenerFilter();
        boolean isFiltered = false;
        try {
            JSONArray filterArray = new JSONArray(filterString);
            for (int i = 0; i < filterArray.length(); i++) {
                try {
                    JSONObject element = filterArray.getJSONObject(i);
                    if (packageName.equals(element.getString("packageName")))
                        isFiltered = true;
                } catch (JSONException e) {
                    Log.e(Constants.LOG_TAG, e.getMessage());
                }
            }
        } catch (JSONException e) {
            Log.e(Constants.LOG_TAG, e.getMessage());
        }

        // If filtered, save the notification info in sharedPreferences
//        if (!isFiltered) return;

        Bundle extras = sbn != null ? sbn.getNotification().extras : null;
        if (extras == null) return;

        NotificationData sbnData = new NotificationData(id, packageName, extras);
        notificationsDB.insertData(sbnData.getAsContentValues());
    }

    @Override
    public void onNotificationRemoved(StatusBarNotification sbn) {
    }
}
