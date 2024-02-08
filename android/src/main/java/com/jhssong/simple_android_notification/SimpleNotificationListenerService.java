package com.jhssong.simple_android_notification;

import android.app.Notification;
import android.content.Context;
import android.os.Build;
import android.os.Bundle;
import android.service.notification.NotificationListenerService;
import android.service.notification.StatusBarNotification;

import androidx.annotation.RequiresApi;

import com.jhssong.simple_android_notification.models.NotificationInfo;

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
        SharedPref sPref = new SharedPref(context);
        SimpleNotificationListener simpleNotificationListener = new SimpleNotificationListener(context);

        String packageName = sbn != null ? sbn.getPackageName() : "Null";

        String filterString = simpleNotificationListener.getListenerFilter();
        JSONArray filterArray;
        boolean isFiltered = false;
        try {
            filterArray = new JSONArray(filterString);
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

        if (isFiltered) return;

        Bundle extras = sbn != null ? sbn.getNotification().extras : null;
        if (extras == null) return;
        String extraTitle = extras.getString(Notification.EXTRA_TITLE, "");
        String extraText = extras.getString(Notification.EXTRA_TEXT, "");
        String extraBigText = extras.getString(Notification.EXTRA_BIG_TEXT, "");
        String extraInfoText = extras.getString(Notification.EXTRA_INFO_TEXT, "");
        String extraSubText = extras.getString(Notification.EXTRA_SUB_TEXT, "");
        String extraSummaryText = extras.getString(Notification.EXTRA_SUMMARY_TEXT, "");

        Log.d(Constants.LOG_TAG, "onNotificationPosted:\n" +
                "PackageName: " + packageName + "\n" +
                "Title: " + extraTitle + "\n" +
                "Text: " + extraText + "\n" +
                "BigText: " + extraBigText + "\n" +
                "InfoText: " + extraInfoText + "\n" +
                "SubText: " + extraSubText + "\n" +
                "SummaryText: " + extraSummaryText + "\n"
        );

        long uniqueId = Instant.now().toEpochMilli();
        String id = Long.toString(uniqueId);

        NotificationInfo sbnData = new NotificationInfo(
                id, packageName, extraTitle, extraText, extraBigText,
                extraInfoText, extraSubText, extraSummaryText);

        sPref.addPref(Constants.LISTENED_NOTIFICATIONS_KEY, sbnData.getAsJSON());
    }

    @Override
    public void onNotificationRemoved(StatusBarNotification sbn) {}
}
