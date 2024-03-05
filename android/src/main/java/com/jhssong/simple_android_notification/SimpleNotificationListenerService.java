package com.jhssong.simple_android_notification;

import android.content.Context;
import android.os.Bundle;
import android.service.notification.NotificationListenerService;
import android.service.notification.StatusBarNotification;

import com.jhssong.simple_android_notification.models.ListenedData;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import io.flutter.Log;


public class SimpleNotificationListenerService extends NotificationListenerService {
    private boolean checkAndFilter(String filter, String data) {
        if (filter.isEmpty()) return true;
        else return data.contains(filter);
    }

    private boolean checkOrFilter(String filter, String data) {
        if (filter.isEmpty()) return false;
        else return data.contains(filter);
    }

    @Override
    public void onNotificationPosted(StatusBarNotification sbn) {
        // TODO Add setting value to save all the notifications
        // TODO Show notification when proper notification was received
        //      (make this feature controllable)
        Context context = getApplicationContext();
        NotificationsDB notificationsDB = new NotificationsDB(context);
        SimpleNotificationListener simpleNotificationListener = new SimpleNotificationListener(context);

        String packageName = sbn != null ? sbn.getPackageName() : "Null";

        Bundle extras = sbn != null ? sbn.getNotification().extras : null;
        if (extras == null) return;

        ListenedData sbnData = new ListenedData(packageName, extras);
        // if notification was empty then skip
        if (sbnData.extraTitle.isEmpty() && sbnData.extraText.isEmpty()) return;

        JSONArray filterArray = simpleNotificationListener.getListenerFilter(packageName);
        boolean isFiltered = false;

        for (int i = 0; i < filterArray.length(); i++) {
            try {
                JSONObject element = filterArray.getJSONObject(i);
                int option = element.getInt("option");
                String title = element.getString("title");
                String text = element.getString("text");
                String bigText = element.getString("bigText");
                String infoText = element.getString("infoText");
                String subText = element.getString("subText");
                String summaryText = element.getString("summaryText");

                if (option == 0) {  // save all notifications
                    isFiltered = true;
                    break;
                }
                if (option == 1) {  // set "and" rule
                    isFiltered = checkAndFilter(title, sbnData.extraTitle) &&
                            checkAndFilter(text, sbnData.extraText) &&
                            checkAndFilter(bigText, sbnData.extraBigText) &&
                            checkAndFilter(infoText, sbnData.extraInfoText) &&
                            checkAndFilter(subText, sbnData.extraSubText) &&
                            checkAndFilter(summaryText, sbnData.extraSummaryText);
                }
                else { // set "or" rule
                    isFiltered = checkOrFilter(title, sbnData.extraTitle) ||
                            checkOrFilter(text, sbnData.extraText) ||
                            checkOrFilter(bigText, sbnData.extraBigText) ||
                            checkOrFilter(infoText, sbnData.extraInfoText) ||
                            checkOrFilter(subText, sbnData.extraSubText) ||
                            checkOrFilter(summaryText, sbnData.extraSummaryText);
                }
            } catch (JSONException e) {
                Log.e(Constants.LOG_TAG, e.getMessage());
            }
        }

        if (!isFiltered) return;
        notificationsDB.insertData(sbnData.getAsContentValues());
    }

    @Override
    public void onNotificationRemoved(StatusBarNotification sbn) {
    }
}
