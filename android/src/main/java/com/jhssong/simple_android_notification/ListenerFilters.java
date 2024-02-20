package com.jhssong.simple_android_notification;

import static com.jhssong.simple_android_notification.ErrorHandler.handleError;

import android.content.Context;
import android.content.SharedPreferences;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import io.flutter.plugin.common.MethodChannel.Result;

public class ListenerFilters {
    private final SharedPreferences pref;
    private final String key = Constants.LISTENER_FILTER_KEY;

    ListenerFilters(Context context) {
        this.pref = context.getSharedPreferences(key, Context.MODE_PRIVATE);
    }

    public void insertData(JSONObject item, Result result) {
        SharedPreferences.Editor editor = pref.edit();
        JSONObject metaData = queryData(result);
        JSONArray packageArray = new JSONArray();
        String packageName = null;
        try {
            packageName = item.getString("packageName");
            packageArray = metaData.getJSONArray(packageName);
        } catch (JSONException e) {
            handleError(ErrorHandler.JSON_EXCEPTION, result, e);
        }
        packageArray.put(item);

        try {
            metaData.put(packageName, packageArray);
        } catch (JSONException e) {
            handleError(ErrorHandler.JSON_EXCEPTION, result, e);
        }
        editor.putString(key, metaData.toString());
        editor.apply();
    }

    public JSONObject queryData(Result result) {
        String data = pref.getString(key, null);
        if (data != null) {
            try {
                return new JSONObject(data);
            } catch (JSONException e) {
                handleError(ErrorHandler.JSON_EXCEPTION, result, e);
                return new JSONObject();
            }
        } else return new JSONObject();
    }

    public JSONArray queryPackageData(String packageName) {
        String data = pref.getString(key, null);
        if (data != null) {
            try {
                JSONObject metaData = new JSONObject(data);
                return metaData.getJSONArray(packageName);
            } catch (JSONException e) {
                handleError(ErrorHandler.JSON_EXCEPTION, null, e);
                return new JSONArray();
            }
        } else return new JSONArray();
    }

    public void deleteData(JSONObject item, Result result) {
        SharedPreferences.Editor editor = pref.edit();
        JSONObject metaData = queryData(result);
        JSONArray packageArray = new JSONArray();
        JSONArray newArray = new JSONArray();
        String packageName = null;
        try {
            packageName = item.getString("packageName");
            packageArray = metaData.getJSONArray(packageName);
        } catch (JSONException e) {
            handleError(ErrorHandler.JSON_EXCEPTION, result, e);
        }

        for (int i = 0; i < packageArray.length(); i++) {
            try {
                JSONObject filter = packageArray.getJSONObject(i);
                String filterId = filter.getString("id");
                String itemId = item.getString("id");
                if (!filterId.equals(itemId)) newArray.put(filter);
            } catch (JSONException e) {
                handleError(ErrorHandler.JSON_EXCEPTION, result, e);
            }
        }

        try {
            metaData.put(packageName, newArray);
        } catch (JSONException e) {
            handleError(ErrorHandler.JSON_EXCEPTION, result, e);
        }
        editor.putString(key, metaData.toString());
        editor.apply();
    }

    public void resetData() {
        SharedPreferences.Editor editor = pref.edit();
        JSONObject resetData = new JSONObject();
        editor.putString(key, resetData.toString());
        editor.apply();
    }
}
