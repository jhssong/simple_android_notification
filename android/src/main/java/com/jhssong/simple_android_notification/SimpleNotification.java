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

import androidx.core.app.NotificationCompat;
import androidx.core.content.ContextCompat;


public class SimpleNotification {
    private final Context context;
    private final Activity activity;
    private final NotificationManager notificationManager;

    SimpleNotification(Context context, Activity activity, NotificationManager notificationManager) {
        this.context = context;
        this.activity = activity;
        this.notificationManager = notificationManager;
        createNotificationChannel(Constants.DEFAULT_CHANNEL_ID, Constants.DEFAULT_CHANNEL_NAME,
                Constants.DEFAULT_CHANNEL_DESC, Constants.DEFAULT_CHANNEL_IMPORTANCE);
    }

    public boolean checkNotificationChannelEnabled(String id) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = notificationManager.getNotificationChannel(id);
            return channel.getImportance() != NotificationManager.IMPORTANCE_NONE;
        }
        return true;
    }

    public void createNotificationChannel(
            String id, CharSequence name, String description, int importance) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel(id, name, importance);
            channel.setDescription(description);
            notificationManager.createNotificationChannel(channel);
        }
    }

    // TODO Delete Notification Channel

    // TODO Get Notification Channel List

    public boolean hasNotificationPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            int check = ContextCompat.checkSelfPermission(context, Manifest.permission.POST_NOTIFICATIONS);
            return check == PackageManager.PERMISSION_GRANTED;
        }
        return true;
    }

    public void requestNotificationPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU)
            requestPermissions(
                    activity,
                    new String[]{Manifest.permission.POST_NOTIFICATIONS},
                    Constants.NOTIFICATION_PERMISSIONS_REQUEST_CODE
            );
    }

    public void showNotification(String channelId, String title, String content, String payload) {  // TODO set channel ID
        Intent intent = Constants.getLaunchIntent(context);
        intent.putExtra(Constants.NOTIFICATION_PAYLOAD_KEY, payload);  // payload
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        PendingIntent pendingIntent = PendingIntent.getActivity(context,
                Constants.NOTIFICATION_PENDING_INTENT_REQUEST_CODE, intent, PendingIntent.FLAG_IMMUTABLE);

        NotificationCompat.Builder builder = new NotificationCompat.Builder(context, channelId)
                .setSmallIcon(R.drawable.notification_icon)
                .setContentTitle(title)
                .setContentText(content)
                .setContentIntent(pendingIntent)
                .setAutoCancel(true)
                .setPriority(NotificationCompat.PRIORITY_DEFAULT);

        notificationManager.notify(1, builder.build());
    }

    // TODO Delete Notification

    // TODO Get Notification List
}
