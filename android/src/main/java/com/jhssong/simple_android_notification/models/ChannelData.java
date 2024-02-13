package com.jhssong.simple_android_notification.models;

import android.app.NotificationChannel;
import android.os.Build;

import androidx.annotation.RequiresApi;

import org.json.JSONException;
import org.json.JSONObject;

@RequiresApi(api = Build.VERSION_CODES.O)
public class ChannelData {
    public String id;
    public CharSequence name;
    public String desc;
    public int imp;

    public ChannelData(String id, CharSequence name, String description, int importance) {
        this.id = id;
        this.name = name;
        this.desc = description;
        this.imp = importance;
    }

    public ChannelData(NotificationChannel channel) {
        this.id = channel.getId();
        this.name = channel.getName();
        this.desc = channel.getDescription();
        this.imp = channel.getImportance();
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
