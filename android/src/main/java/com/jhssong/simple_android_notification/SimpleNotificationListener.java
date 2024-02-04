package com.jhssong.simple_android_notification;

import android.app.Notification;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import android.service.notification.NotificationListenerService;
import android.service.notification.StatusBarNotification;

import androidx.core.app.NotificationManagerCompat;

import com.jhssong.simple_android_notification.models.NotificationInfo;

import java.util.Set;

import io.flutter.Log;

public class SimpleNotificationListener extends NotificationListenerService {
    public static boolean checkNotificationListenerPermission(Context context) {
        Set<String> notiListenerSet = NotificationManagerCompat.getEnabledListenerPackages(context);

        String myPackageName = context.getPackageName();

        for (String packageName : notiListenerSet) {
            if (packageName == null) continue;
            if (packageName.equals(myPackageName)) return true;
        }
        return false;
    }

    public static void openNotificationListenerPermissionSettingScreen(Context context) {
        Intent intent = new Intent();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP_MR1) {
            intent.setAction(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS);
        }
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        context.startActivity(intent);
    }

    public static String getListenedNotificationsList(Context context) {
        SharedPref pref = new SharedPref(context);
        return pref.getPref(Constants.LISTENED_NOTIFICATIONS_KEY).toString();
    }

    // TODO Delete ListenedNotification List

    // TODO Update ListenedNotification List

    @Override
    public void onNotificationPosted(StatusBarNotification sbn) {
        // TODO Find the way to show notification before onAttachedToEngine method loaded

        String packageName = sbn != null ? sbn.getPackageName() : "Null";
        Bundle extras = sbn != null ? sbn.getNotification().extras : null;
        if (extras == null) return;
        String extraTitle = extras.getString(Notification.EXTRA_TITLE, "");
        String extraText = extras.getString(Notification.EXTRA_TEXT, "");
        String extraBigText = extras.getString(Notification.EXTRA_BIG_TEXT, "");
        String extraInfoText = extras.getString(Notification.EXTRA_INFO_TEXT, "");
        String extraSubText = extras.getString(Notification.EXTRA_SUB_TEXT, "");
        String extraSummaryText = extras.getString(Notification.EXTRA_SUMMARY_TEXT, "");

        Log.d(Constants.LOG_TAG, "onNotificationPosted:\n" +
                "PackageName: " + packageName + "\n" +
                "Title: " + extraTitle + "\n" +
                "Text: " + extraText + "\n" +
                "BigText: " + extraBigText + "\n" +
                "InfoText: " + extraInfoText + "\n" +
                "SubText: " + extraSubText + "\n" +
                "SummaryText: " + extraSummaryText + "\n"
        );

        NotificationInfo sbnData = new NotificationInfo(packageName, extraTitle, extraText, extraBigText,
                extraInfoText, extraSubText, extraSummaryText);

        Context context = getApplicationContext();
        SharedPref pref = new SharedPref(context);
        pref.addPref(Constants.LISTENED_NOTIFICATIONS_KEY, sbnData.getAsJSON());
    }

    @Override
    public void onNotificationRemoved(StatusBarNotification sbn) {
        Log.d(Constants.LOG_TAG, "onNotificationRemoved function");
    }
}
