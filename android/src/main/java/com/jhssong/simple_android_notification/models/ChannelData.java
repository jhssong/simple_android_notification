package com.jhssong.simple_android_notification.models;

import static com.jhssong.simple_android_notification.ErrorHandler.handleError;

import android.app.NotificationChannel;
import android.os.Build;

import androidx.annotation.RequiresApi;

import com.jhssong.simple_android_notification.ErrorHandler;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Map;

import io.flutter.plugin.common.MethodChannel.Result;

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

    public static ChannelData from(Map<String, Object> arguments) {
        String id = (String) arguments.get("id");
        CharSequence name = (String) arguments.get("name");
        String desc = (String) arguments.get("desc");
        int imp = (int) arguments.get("imp");
        return new ChannelData(id, name, desc, imp);
    }

    public JSONObject getAsJSON(Result result) {
        JSONObject array = new JSONObject();
        try {
            array.put("id", id);
            array.put("name", name);
            array.put("desc", desc);
            array.put("imp", imp);
        } catch (JSONException e) {
            handleError(ErrorHandler.JSON_EXCEPTION, result, e);
        }
        return array;
    }
}
