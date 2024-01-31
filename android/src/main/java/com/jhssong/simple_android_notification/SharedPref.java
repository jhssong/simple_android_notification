package com.jhssong.simple_android_notification;


import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;

import org.json.JSONArray;
import org.json.JSONException;

import java.util.ArrayList;


public class SharedPref {
    private final Context context;
    private final Activity activity;

    ArrayList<String> channelList = new ArrayList<>();
    ArrayList<String> notificationList = new ArrayList<>();

    private static final String CHANNEL_LIST_KEY = "channel_list_key";
    private static final String NOTIFICATION_LIST_KEY = "notification_list_key";


    SharedPref(Context context, Activity activity) {
        this.context = context;
        this.activity = activity;
    }

//    private static ArrayList<NotificationDetails> getScheduledNotifications(Context context) {
//        ArrayList<NotificationDetails> scheduledNotifications = new ArrayList<>();
//        SharedPreferences sharedPreferences =
//                context.getSharedPreferences(SCHEDULED_NOTIFICATIONS, Context.MODE_PRIVATE);
//        String json = sharedPreferences.getString(SCHEDULED_NOTIFICATIONS, null);
//        if (json != null) {
//            Gson gson = buildGson();
//            Type type = new TypeToken<ArrayList<NotificationDetails>>() {}.getType();
//            scheduledNotifications = gson.fromJson(json, type);
//        }
//        return scheduledNotifications;
//    }
//
//    private static void setScheduledNotifications(
//            Context context, ArrayList<NotificationDetails> scheduledNotifications) {
//        Gson gson = buildGson();
//        String json = gson.toJson(scheduledNotifications);
//        SharedPreferences sharedPreferences =
//                context.getSharedPreferences(SCHEDULED_NOTIFICATIONS, Context.MODE_PRIVATE);
//        SharedPreferences.Editor editor = sharedPreferences.edit();
//        editor.putString(SCHEDULED_NOTIFICATIONS, json).apply();
//    }

    private ArrayList<String> getPref(String key) {
        SharedPreferences pref = context.getSharedPreferences(key, Context.MODE_PRIVATE);
        String json = pref.getString(key, null);
        ArrayList<String> list = new ArrayList<>();

        if (json != null) {
            try {
                JSONArray array = new JSONArray(json);
                for (int i = 0; i < array.length(); i++) {
                    String item = array.optString(i);
                    list.add(item);
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
        return list;
    }

    private void setPref(String key, ArrayList<String> values) {
        SharedPreferences pref = context.getSharedPreferences(key, Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = pref.edit();
        JSONArray array = new JSONArray();

        // make JSONArray from ArrayList<String>
        for (int i = 0; i < values.size(); i++)
            array.put(values.get(i));

        if (values.isEmpty())
            editor.putString(key, null);
        else
            editor.putString(key, array.toString());

        editor.apply();
    }
}
