package com.jhssong.simple_android_notification.models;

import android.app.Notification;
import android.os.Bundle;
import android.util.Log;

import com.jhssong.simple_android_notification.Constants;

import org.json.JSONException;
import org.json.JSONObject;

public class NotificationData {
    String id;
    String packageName;
    String extraTitle;
    String extraText;
    String extraBigText;
    String extraInfoText;
    String extraSubText;
    String extraSummaryText;

    public NotificationData(String id, String packageName, Bundle extras) {
        this.id = id;
        this.packageName = packageName;
        this.extraTitle = extras.getString(Notification.EXTRA_TITLE, "");
        this.extraText = extras.getString(Notification.EXTRA_TEXT, "");
        this.extraBigText = extras.getString(Notification.EXTRA_BIG_TEXT, "");
        this.extraInfoText = extras.getString(Notification.EXTRA_INFO_TEXT, "");
        this.extraSubText = extras.getString(Notification.EXTRA_SUB_TEXT, "");
        this.extraSummaryText = extras.getString(Notification.EXTRA_SUMMARY_TEXT, "");
    }

    public JSONObject getAsJSON() {
        JSONObject data = new JSONObject();
        try {
            data.put("id", id);
            data.put("packageName", packageName);
            data.put("title", extraTitle);
            data.put("text", extraText);
            data.put("bigText", extraBigText);
            data.put("infoText", extraInfoText);
            data.put("subText", extraSubText);
            data.put("summaryText", extraSummaryText);
        } catch (JSONException e) {
            Log.e(Constants.LOG_TAG, e.getMessage());
        }
        return data;
    }
}
