package com.jhssong.simple_android_notification;

import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;

public final class Constants {
    public static final String METHOD_CHANNEL = "jhssong/simple_android_notification";
    public static final String LOG_TAG = "simple_notification";

    public static final String DEFAULT_CHANNEL_ID = "Default Channel";
    public static final String DEFAULT_CHANNEL_NAME = "Default Channel";
    public static final String DEFAULT_CHANNEL_DESC = "Default Notification Channel";
    public static final int DEFAULT_CHANNEL_IMPORTANCE = getImportance("IMPORTANCE_LOW");

    public static final int NOTIFICATION_PERMISSIONS_REQUEST_CODE = 1001;
    public static final int NOTIFICATION_PENDING_INTENT_REQUEST_CODE = 1002;

    public static final String CHANNEL_LIST_KEY = "channel_list_key";
    public static final String NOTIFICATION_LIST_KEY = "notification_list_key";
    public static final String LISTENED_NOTIFICATIONS_KEY = "listened_notification_key";
    public static final String NOTIFICATION_PAYLOAD_KEY = "payload_key";

    public static int getImportance(String importance) {
        if (importance == null) return 2;
        switch (importance) {
            case "IMPORTANCE_NONE":     // no sound, doesn't appear in the status bar or shade.
                return 0;
            case "IMPORTANCE_MIN":      // no sound, doesn't appear in the status bar
                return 1;
            case "IMPORTANCE_LOW":      // no sound
                return 2;
            case "IMPORTANCE_MEDIUM":   // make sound
                return 3;
            case "IMPORTANCE_HIGH":     // make sound, appears as a heads-up notification
                return 4;
            default:                    // (IMPORTANCE_MEDIUM) make sound
                return 2;
        }
    }

    public static Intent getLaunchIntent(Context context) {
        String packageName = context.getPackageName();
        PackageManager packageManager = context.getPackageManager();
        return packageManager.getLaunchIntentForPackage(packageName);
    }
}
