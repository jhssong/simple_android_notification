package com.jhssong.simple_android_notification.models;

import android.app.Notification;
import android.content.ContentValues;
import android.os.Build;
import android.os.Bundle;

import java.util.Date;

public class ListenedData {
    public final String datetime;
    public final String packageName;
    public final String extraTitle;
    public final String extraText;
    public final String extraBigText;
    public final String extraInfoText;
    public final String extraSubText;
    public final String extraSummaryText;

    public ListenedData(String packageName, Bundle extras) {
        this.datetime = Long.toString(new Date().getTime());
        this.packageName = packageName;
        this.extraTitle = extras.getString(Notification.EXTRA_TITLE, "");
        this.extraText = extras.getString(Notification.EXTRA_TEXT, "");
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP)
            this.extraBigText = extras.getString(Notification.EXTRA_BIG_TEXT, "");
        else this.extraBigText = "";
        this.extraInfoText = extras.getString(Notification.EXTRA_INFO_TEXT, "");
        this.extraSubText = extras.getString(Notification.EXTRA_SUB_TEXT, "");
        this.extraSummaryText = extras.getString(Notification.EXTRA_SUMMARY_TEXT, "");
    }

    public ContentValues getAsContentValues() {
        ContentValues values = new ContentValues();
        values.put("datetime", datetime);
        values.put("packageName", packageName);
        values.put("title", extraTitle);
        values.put("text", extraText);
        values.put("bigText", extraBigText);
        values.put("infoText", extraInfoText);
        values.put("subText", extraSubText);
        values.put("summaryText", extraSummaryText);
        return values;
    }

}
