package com.jhssong.simple_android_notification.models;

import org.json.JSONException;
import org.json.JSONObject;

public class NotificationChannelInfo {
    public String id;
    public CharSequence name;
    public String description;
    public int importance;

    public NotificationChannelInfo(
            String id, CharSequence name, String description, int importance) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.importance = importance;
    }

    public JSONObject getAsJSON() {
        JSONObject data = new JSONObject();
        try {
            data.put("id", id);
            data.put("name", name);
            data.put("description", description);
            data.put("importance", importance);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return data;
    }
}
