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

import androidx.annotation.RequiresApi;
import androidx.core.app.NotificationCompat;
import androidx.core.content.ContextCompat;

import com.jhssong.simple_android_notification.models.NotificationChannelInfo;

import org.json.JSONArray;

import java.util.List;

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

    public String checkNotificationChannelEnabled(String id) {
        NotificationChannel channel = notificationManager.getNotificationChannel(id);
        if (channel == null) return "false";
        return channel.getImportance() != NotificationManager.IMPORTANCE_NONE ? "true" : "false";
    }

    public String createNotificationChannel(NotificationChannelInfo info) {
        if (checkNotificationChannelEnabled(info.id).equals("true"))
            return "Channel already exists";

        NotificationChannel channel = new NotificationChannel(info.id, info.name, info.importance);
        channel.setDescription(info.description);
        notificationManager.createNotificationChannel(channel);

        String res = checkNotificationChannelEnabled(info.id);
        return res.equals("true") ? "created" : "failed";
    }

    public String removeNotificationChannel(String id) {
        notificationManager.deleteNotificationChannel(id);
        String res = checkNotificationChannelEnabled(id);
        return res.equals("false") ? "deleted" : "failed";
    }

    public String getNotificationChannelList() {
        JSONArray channelArray = new JSONArray();
        List<NotificationChannel> channels = notificationManager.getNotificationChannels();

        for (NotificationChannel channel : channels) {
            String id = channel.getId();
            CharSequence name = channel.getName();
            String desc = channel.getDescription();
            int importance = channel.getImportance();
            NotificationChannelInfo info = new NotificationChannelInfo(id, name, desc, importance);
            channelArray.put(info.getAsJSON());
        }
        return channelArray.toString();
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

    // TODO Check if the channel is unable
    // TODO Check if notification permission was granted
    // TODO Add priority option
    public void showNotification(String channelId, String title, String content, String payload) {
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

        notificationManager.notify(Constants.NOTIFICATION_NOTIFY_CODE, builder.build());
    }
}
