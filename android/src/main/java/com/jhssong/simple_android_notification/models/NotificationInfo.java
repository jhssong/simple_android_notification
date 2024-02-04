package com.jhssong.simple_android_notification.models;

import org.json.JSONException;
import org.json.JSONObject;

public class NotificationInfo {
    String packageName;
    String extraTitle;
    String extraText;
    String extraBigText;
    String extraInfoText;
    String extraSubText;
    String extraSummaryText;

    public NotificationInfo(
            String packageName, String extraTitle, String extraText, String extraBigText,
            String extraInfoText, String extraSubText, String extraSummaryText) {
        this.packageName = packageName;
        this.extraTitle = extraTitle;
        this.extraText = extraText;
        this.extraBigText = extraBigText;
        this.extraInfoText = extraInfoText;
        this.extraSubText = extraSubText;
        this.extraSummaryText = extraSummaryText;
    }

    public JSONObject getAsJSON() {
        JSONObject data = new JSONObject();
        try {
            data.put("packageName", packageName);
            data.put("title", extraTitle);
            data.put("text", extraText);
            data.put("bigText", extraBigText);
            data.put("infoText", extraInfoText);
            data.put("subText", extraSubText);
            data.put("summaryText", extraSummaryText);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return data;
    }
}
