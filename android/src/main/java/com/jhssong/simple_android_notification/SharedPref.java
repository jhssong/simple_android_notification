package com.jhssong.simple_android_notification;

import android.content.Context;
import android.content.SharedPreferences;
import android.util.Log;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

// TODO Handle exception using logging tool
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
                Log.e(Constants.LOG_TAG, e.getMessage());
                return new JSONArray();
            }
        }
        return new JSONArray();
    }

    public String setPref(String key, JSONArray array) {
        try {
            SharedPreferences pref = context.getSharedPreferences(key, Context.MODE_PRIVATE);
            SharedPreferences.Editor editor = pref.edit();
            editor.putString(key, array.toString());
            editor.apply();
            return "Success";
        } catch (Exception e) {
            return "Error with SharedPref(set)";
        }
    }

    public String addPref(String key, JSONObject item) {
        try {
            JSONArray old_array = getPref(key);
            old_array.put(item);
            setPref(key, old_array);
            return "Success";
        } catch (Exception e) {
            return "Error with SharedPref(add)";
        }
    }
}
