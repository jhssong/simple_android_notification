package com.jhssong.simple_android_notification;

import static androidx.core.app.ActivityCompat.requestPermissions;

import android.Manifest;
import android.app.Activity;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;

import androidx.annotation.RequiresApi;
import androidx.core.app.NotificationCompat;
import androidx.core.content.ContextCompat;

import com.jhssong.simple_android_notification.models.ChannelData;

import org.json.JSONArray;

import java.util.List;

import io.flutter.Log;

@RequiresApi(api = Build.VERSION_CODES.O)
public class SimpleNotification {
    private final Context context;
    private final Activity activity;
    private final NotificationManager notificationManager;

    SimpleNotification(Context context, Activity activity, NotificationManager notificationManager) {
        this.context = context;
        this.activity = activity;
        this.notificationManager = notificationManager;
    }

    public boolean checkNotificationChannelEnabled(String id) {
        NotificationChannel channel = notificationManager.getNotificationChannel(id);
        if (channel == null) return false;
        return channel.getImportance() != NotificationManager.IMPORTANCE_NONE;
    }

    public String createNotificationChannel(ChannelData info) {
        if (checkNotificationChannelEnabled(info.id))
            return "Channel already exists";
        NotificationChannel channel = new NotificationChannel(info.id, info.name, info.imp);
        channel.setDescription(info.desc);
        notificationManager.createNotificationChannel(channel);

        boolean res = checkNotificationChannelEnabled(info.id);
        return res ? "Created" : "Failed";
    }

    public String getNotificationChannelList() {
        JSONArray channelArray = new JSONArray();
        List<NotificationChannel> channels = notificationManager.getNotificationChannels();

        for (NotificationChannel channel : channels) {
            ChannelData info = new ChannelData(channel);
            channelArray.put(info.getAsJSON());
        }
        return channelArray.toString();
    }

    public String removeNotificationChannel(String id) {
        if (!checkNotificationChannelEnabled(id))
            return "Channel doesn't exists";
        notificationManager.deleteNotificationChannel(id);
        boolean res = checkNotificationChannelEnabled(id);
        return !res ? "Deleted" : "Failed";
    }

    public String getPayload() {
        Intent activityIntent = activity.getIntent();
        String payload = null;

        if (activityIntent != null) {
            Bundle extras = activityIntent.getExtras();
            if (extras != null && extras.containsKey(Constants.NOTIFICATION_PAYLOAD_KEY)) {
                payload = extras.getString(Constants.NOTIFICATION_PAYLOAD_KEY);
            } else {
                payload = "empty";
                // if (extras != null) {
                //     for (String key : extras.keySet()) {
                //         Object value = extras.get(key);
                //         String valueString = value != null ? value.toString() : null;
                //         Log.d(Constants.LOG_TAG, "Key: " + key + ", Value: " + valueString);
                //     }
                // }
            }
        }
        return payload;
    }

    // TODO Fix function to work under Ver.TIRAMISU
    public boolean hasNotificationPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            int check = ContextCompat.checkSelfPermission(context, Manifest.permission.POST_NOTIFICATIONS);
            return check == PackageManager.PERMISSION_GRANTED;
        }
        return true;
    }

    // TODO Fix function to work under Ver.TIRAMISU
    public void requestNotificationPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU)
            requestPermissions(activity, new String[]{Manifest.permission.POST_NOTIFICATIONS},
                    Constants.NOTIFICATION_PERMISSIONS_REQUEST_CODE);
    }

    public Intent getLaunchIntent(Context context) {
        String packageName = context.getPackageName();
        PackageManager packageManager = context.getPackageManager();
        return packageManager.getLaunchIntentForPackage(packageName);
    }

    public String showNotification(String channelId, String title, String content, String payload) {
        if (!hasNotificationPermission())
            return "Doesn't have permission";
        if (!checkNotificationChannelEnabled(channelId))
            return "Unknown channel";
        Intent intent = getLaunchIntent(context);
        intent.putExtra(Constants.NOTIFICATION_PAYLOAD_KEY, payload);
        intent.setAction(payload);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        PendingIntent pendingIntent = PendingIntent.getActivity(
                context, Constants.NOTIFICATION_PENDING_INTENT_REQUEST_CODE, intent, PendingIntent.FLAG_IMMUTABLE);

        NotificationCompat.Builder builder = new NotificationCompat.Builder(context, channelId)
                .setSmallIcon(R.drawable.notification_icon)
                .setContentTitle(title).setContentText(content)
                .setContentIntent(pendingIntent).setAutoCancel(true)
                .setPriority(NotificationCompat.PRIORITY_DEFAULT);
        try {
            notificationManager.notify(Constants.NOTIFICATION_NOTIFY_CODE, builder.build());
        } catch (Exception e) {
            Log.e(Constants.LOG_TAG, e.getMessage());
            return "Error when notify";
        }
        return "Send";
    }
}
