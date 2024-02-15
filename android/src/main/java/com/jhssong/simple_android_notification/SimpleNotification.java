package com.jhssong.simple_android_notification;

import static androidx.core.app.ActivityCompat.requestPermissions;
import static com.jhssong.simple_android_notification.ErrorHandler.handleError;

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
import com.jhssong.simple_android_notification.models.NotificationData;

import org.json.JSONArray;

import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.Result;

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

    public void checkNotificationChannelEnabled(MethodCall call, Result result) {
        final String id = call.argument("id");
        NotificationChannel channel = notificationManager.getNotificationChannel(id);
        if (channel == null) result.success(false);
        else result.success(channel.getImportance() != NotificationManager.IMPORTANCE_NONE);
    }

    public void createNotificationChannel(MethodCall call, Result result) {
        Map<String, Object> arguments = call.arguments();
        ChannelData data = ChannelData.from(arguments);

        NotificationChannel channel = new NotificationChannel(data.id, data.name, data.imp);
        channel.setDescription(data.desc);

        notificationManager.createNotificationChannel(channel);
        result.success(null);
    }

    public void getNotificationChannelList(Result result) {
        JSONArray array = new JSONArray();
        List<NotificationChannel> channels = notificationManager.getNotificationChannels();

        for (NotificationChannel channel : channels) {
            ChannelData data = new ChannelData(channel);
            array.put(data.getAsJSON(result));
        }
        result.success(array.toString());
    }

    public void removeNotificationChannel(MethodCall call, Result result) {
        final String id = call.argument("id");
        notificationManager.deleteNotificationChannel(id);
        result.success(null);
    }

    public void getPayload(Result result) {
        Intent activityIntent = activity.getIntent();
        if (activityIntent != null) {
            Bundle extras = activityIntent.getExtras();
            if (extras != null && extras.containsKey(Constants.NOTIFICATION_PAYLOAD_KEY)) {
                String payload = extras.getString(Constants.NOTIFICATION_PAYLOAD_KEY);
                result.success(payload);
            } else {
                result.success("empty");
            }
        }
        else result.success("error with activityIntent");
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
    public void requestNotificationPermission(Result result) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU)
            requestPermissions(activity, new String[]{Manifest.permission.POST_NOTIFICATIONS},
                    Constants.NOTIFICATION_PERMISSIONS_REQUEST_CODE);
        result.success(null);
    }


    public void showNotification(MethodCall call, Result result) {
        Map<String, Object> arguments = call.arguments();
        NotificationData data = NotificationData.from(arguments);

        Intent intent = getLaunchIntent();
        intent.putExtra(Constants.NOTIFICATION_PAYLOAD_KEY, data.payload);
        intent.setAction(data.payload);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        PendingIntent pendingIntent = PendingIntent.getActivity(
                context, Constants.NOTIFICATION_PENDING_INTENT_REQUEST_CODE, intent, PendingIntent.FLAG_IMMUTABLE);
        NotificationCompat.Builder builder = new NotificationCompat.Builder(context, data.channelId)
                .setSmallIcon(R.drawable.notification_icon)
                .setContentTitle(data.title).setContentText(data.content)
                .setContentIntent(pendingIntent).setAutoCancel(true)
                .setPriority(NotificationCompat.PRIORITY_DEFAULT);
        try {
            notificationManager.notify(Constants.NOTIFICATION_NOTIFY_CODE, builder.build());
            result.success(null);
        } catch (Exception e) {
            handleError(ErrorHandler.NOTIFY_FAILED, result, null);
        }
    }

    private Intent getLaunchIntent() {
        String packageName = context.getPackageName();
        PackageManager packageManager = context.getPackageManager();
        return packageManager.getLaunchIntentForPackage(packageName);
    }
}
