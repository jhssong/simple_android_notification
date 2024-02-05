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
import android.util.Log;

import androidx.core.app.NotificationCompat;
import androidx.core.content.ContextCompat;

import com.jhssong.simple_android_notification.models.NotificationChannelInfo;

import org.json.JSONArray;

import java.util.List;


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
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = notificationManager.getNotificationChannel(id);
            if (channel == null) return false;
            return channel.getImportance() != NotificationManager.IMPORTANCE_NONE;
        }
        return true;
    }

    public void createNotificationChannel(NotificationChannelInfo info) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel(info.id, info.name, info.importance);
            channel.setDescription(info.description);
            notificationManager.createNotificationChannel(channel);
        }
    }

    public void removeNotificationChannel(String id) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            notificationManager.deleteNotificationChannel(id);
        }
    }

    public String getNotificationChannelList() {
        JSONArray channelArray = new JSONArray();

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            List<NotificationChannel> channels = notificationManager.getNotificationChannels();
            for (NotificationChannel channel : channels) {
                String id = channel.getId();
                CharSequence name = channel.getName();
                String desc = channel.getDescription();
                int importance = channel.getImportance();

                NotificationChannelInfo info = new NotificationChannelInfo(id, name, desc, importance);
                channelArray.put(info.getAsJSON());
            }
        }
        return channelArray.toString();
    }

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
