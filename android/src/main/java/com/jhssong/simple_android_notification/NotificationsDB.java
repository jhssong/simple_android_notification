package com.jhssong.simple_android_notification;

import static com.jhssong.simple_android_notification.ErrorHandler.handleError;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import io.flutter.plugin.common.MethodChannel.Result;

public class NotificationsDB {
    private final SQLiteDatabase db;
    Context context;

    public NotificationsDB(Context context) {
        this.context = context;
        db = context.openOrCreateDatabase(Constants.NOTIFICATION_DB_NAME, Context.MODE_PRIVATE, null);
        createTable();
    }

    private void createTable() {
        db.execSQL(Constants.NOTIFICATION_DB_CREATE);
    }

    public void insertData(ContentValues values) {
        db.insert(Constants.NOTIFICATION_DB_TABLE_NAME, null, values);
    }

    public JSONArray queryData(Result result) {
        JSONArray jsonArray = new JSONArray();

        try (Cursor cursor = db.rawQuery(Constants.NOTIFICATION_DB_QUERY, null)) {
            if (cursor == null || !cursor.moveToFirst()) return jsonArray;

            int idIndex = cursor.getColumnIndex("id");
            int packageNameIndex = cursor.getColumnIndex("packageName");
            int titleIndex = cursor.getColumnIndex("title");
            int textIndex = cursor.getColumnIndex("text");
            int bigTextIndex = cursor.getColumnIndex("bigText");
            int infoTextIndex = cursor.getColumnIndex("infoText");
            int subTextIndex = cursor.getColumnIndex("subText");
            int summaryTextIndex = cursor.getColumnIndex("summaryText");

            do {
                JSONObject jsonObject = new JSONObject();
                if (idIndex != -1) jsonObject.put("id", Integer.toString(cursor.getInt(idIndex)));
                if (packageNameIndex != -1)
                    jsonObject.put("packageName", cursor.getString(packageNameIndex));
                if (titleIndex != -1) jsonObject.put("title", cursor.getString(titleIndex));
                if (textIndex != -1) jsonObject.put("text", cursor.getString(textIndex));
                if (bigTextIndex != -1) jsonObject.put("bigText", cursor.getString(bigTextIndex));
                if (infoTextIndex != -1)
                    jsonObject.put("infoText", cursor.getString(infoTextIndex));
                if (subTextIndex != -1) jsonObject.put("subText", cursor.getString(subTextIndex));
                if (summaryTextIndex != -1)
                    jsonObject.put("summaryText", cursor.getString(summaryTextIndex));
                jsonArray.put(jsonObject);
            } while (cursor.moveToNext());

        } catch (JSONException e) {
            handleError(ErrorHandler.JSON_EXCEPTION, result, e);
        }
        return jsonArray;
    }

    public void deleteData(int id) {
        db.delete(Constants.NOTIFICATION_DB_TABLE_NAME, "id=?", new String[]{String.valueOf(id)});
    }

    public void resetData() {
        db.execSQL(Constants.NOTIFICATION_DB_RESET);
    }
}
