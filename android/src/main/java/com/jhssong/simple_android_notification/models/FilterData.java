package com.jhssong.simple_android_notification.models;

import android.util.Log;

import com.jhssong.simple_android_notification.Constants;

import org.json.JSONException;
import org.json.JSONObject;

public class FilterData {
    int option; // 0: and, 1: or
    String packageName;
    String title;
    String text;
    String bigText;
    String infoText;
    String subText;
    String summaryText;

    public FilterData(
            int option, String packageName, String title, String text, String bigText,
            String infoText, String subText, String summaryText) {
        this.option = option;
        this.packageName = packageName;
        this.title = title;
        this.text = text;
        this.bigText = bigText;
        this.infoText = infoText;
        this.subText = subText;
        this.summaryText = summaryText;
    }

    public JSONObject getAsJSON() {
        JSONObject data = new JSONObject();
        try {
            data.put("option", option);
            data.put("packageName", packageName);
            data.put("title", title);
            data.put("text", text);
            data.put("bigText", bigText);
            data.put("infoText", infoText);
            data.put("subText", subText);
            data.put("summaryText", summaryText);
        } catch (JSONException e) {
            Log.e(Constants.LOG_TAG, e.getMessage());
        }
        return data;
    }
}
