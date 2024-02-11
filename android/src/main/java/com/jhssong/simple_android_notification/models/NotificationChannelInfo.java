package com.jhssong.simple_android_notification.models;

import org.json.JSONException;
import org.json.JSONObject;

public class NotificationChannelInfo {
    public String id;
    public CharSequence name;
    public String desc;
    public int imp;

    public NotificationChannelInfo(
            String id, CharSequence name, String description, int importance) {
        this.id = id;
        this.name = name;
        this.desc = description;
        this.imp = importance;
    }

    public JSONObject getAsJSON() {
        JSONObject data = new JSONObject();
        try {
            data.put("id", id);
            data.put("name", name);
            data.put("desc", desc);
            data.put("imp", imp);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return data;
    }
}
