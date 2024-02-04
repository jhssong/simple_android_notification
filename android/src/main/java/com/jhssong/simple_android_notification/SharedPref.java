package com.jhssong.simple_android_notification;


import android.content.Context;
import android.content.SharedPreferences;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;


public class SharedPref {
    private final Context context;


    SharedPref(Context context) {
        this.context = context;
    }

    public JSONArray getPref(String key) {
        SharedPreferences pref = context.getSharedPreferences(key, Context.MODE_PRIVATE);
        String data = pref.getString(key, null);

        if (data != null) {
            try {
                return new JSONArray(data);
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
        return new JSONArray();
    }

    public void setPref(String key, JSONArray array) {
        SharedPreferences pref = context.getSharedPreferences(key, Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = pref.edit();
        editor.putString(key, array.toString());
        editor.apply();
    }

    public void addPref(String key, JSONObject item) {
        JSONArray old = getPref(key);
        old.put(item);
        setPref(key, old);
    }

}
