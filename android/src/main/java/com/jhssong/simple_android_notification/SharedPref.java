package com.jhssong.simple_android_notification;

import android.content.Context;
import android.content.SharedPreferences;
import android.util.Log;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class SharedPref {
    private final Context context;

    SharedPref(Context context) {
        this.context = context;
    }

    // TODO Handle Exception
    public JSONArray getPref(String key) {
        SharedPreferences pref = context.getSharedPreferences(key, Context.MODE_PRIVATE);
        String data = pref.getString(key, null);

        if (data != null) {
            try {
                return new JSONArray(data);
            } catch (JSONException e) {
                Log.e(Constants.LOG_TAG, e.getMessage());
            }
        }
        return new JSONArray();
    }

    // TODO Handle duplication and exception
    public void setPref(String key, JSONArray array) {
        SharedPreferences pref = context.getSharedPreferences(key, Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = pref.edit();
        editor.putString(key, array.toString());
        editor.apply();
    }

    public void addPref(String key, JSONObject item) {
        JSONArray old_array = getPref(key);
        old_array.put(item);
        setPref(key, old_array);
    }
}
