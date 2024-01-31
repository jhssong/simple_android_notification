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

import androidx.annotation.NonNull;
import androidx.core.app.NotificationCompat;
import androidx.core.content.ContextCompat;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * SimpleAndroidNotificationPlugin
 */
public class SimpleAndroidNotificationPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
    public static final String LOG_TAG = "simple_notification";
    private static final String METHOD_CHANNEL = "jhssong.com/simple_android_notification";
    private static final String DEFAULT_CHANNEL_ID = "Default_Channel_ID";
    private static final String DEFAULT_CHANNEL_NAME = "Default Channel";
    private static final String DEFAULT_CHANNEL_DESC = "Default Notification Channel";
    private static final int NOTIFICATION_PERMISSIONS_REQUEST_CODE = 1001;
    private static final int NOTIFICATION_PENDING_INTENT_REQUEST_CODE = 1002;
    private static final String NOTIFICATION_PAYLOAD_KEY = "payload_key";
    private Context context;
    private Activity activity;
    private MethodChannel channel;
    private NotificationManager notificationManager;

    private static int getImportance(String importance) {
        if (importance == null) return 3;
        switch (importance) {
            case "IMPORTANCE_NONE":     // no sound, doesn't appear in the status bar or shade.
                return 0;
            case "IMPORTANCE_MIN":      // no sound, doesn't appear in the status bar
                return 1;
            case "IMPORTANCE_LOW":      // no sound
                return 2;
            case "IMPORTANCE_HIGH":     // make sound, appears as a heads-up notification
                return 4;
            default:                    // make sound
                return 3;
        }
    }


    private static Intent getLaunchIntent(Context context) {
        String packageName = context.getPackageName();
        PackageManager packageManager = context.getPackageManager();
        return packageManager.getLaunchIntentForPackage(packageName);
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), METHOD_CHANNEL);
        channel.setMethodCallHandler(this);
        this.context = flutterPluginBinding.getApplicationContext();
        notificationManager =
                (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
        createNotificationChannel(
                DEFAULT_CHANNEL_ID, DEFAULT_CHANNEL_NAME,
                DEFAULT_CHANNEL_DESC, getImportance(null));
    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        this.activity = binding.getActivity();
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "getPayloadFromIntent":
                result.success(getPayloadExtra());
                break;
            case "checkNotificationChannelEnabled":
                result.success(checkNotificationChannelEnabled(DEFAULT_CHANNEL_ID));
            case "createNotificationChannel":
                final String id = call.argument("id");
                final String name = call.argument("name");
                final String desc = call.argument("desc");
                final int importance = getImportance(call.argument("importance"));
                createNotificationChannel(id, name, desc, importance);
            case "checkNotificationPermission":
                result.success(checkNotificationPermission());
                break;
            case "requestNotificationPermission":
                requestNotificationPermission();
                break;
            case "showNotification":
                showNotification();
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private String getPayloadExtra() {
        Intent activityIntent = activity.getIntent();
        String payload;

        if (activityIntent != null) {
            Bundle extras = activityIntent.getExtras();
            if (extras != null && extras.containsKey(NOTIFICATION_PAYLOAD_KEY)) {
                payload = extras.getString(NOTIFICATION_PAYLOAD_KEY);
            } else {
                payload = null;
                Log.d(LOG_TAG, "Payload key not found iterate all extras");
                if (extras != null) {
                    for (String key : extras.keySet()) {
                        Object value = extras.get(key);
                        String valueString = value != null ? value.toString() : null;
                        Log.d(LOG_TAG, "Key: " + key + ", Value: " + valueString);
                    }
                }
            }
        } else payload = null;

        return payload;
    }

    private boolean checkNotificationChannelEnabled(String id) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = notificationManager.getNotificationChannel(id);
            return channel.getImportance() != NotificationManager.IMPORTANCE_NONE;
        }
        return true;
    }


    private void createNotificationChannel(String id, CharSequence name, String description, int importance) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel(id, name, importance);
            channel.setDescription(description);
            notificationManager.createNotificationChannel(channel);
        }
    }

    private boolean checkNotificationPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            int check = ContextCompat.checkSelfPermission(context, Manifest.permission.POST_NOTIFICATIONS);
            return check == PackageManager.PERMISSION_GRANTED;
        }
        return true;
    }

    private void requestNotificationPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU)
            requestPermissions(
                    activity,
                    new String[]{Manifest.permission.POST_NOTIFICATIONS},
                    NOTIFICATION_PERMISSIONS_REQUEST_CODE
            );
    }

    private void showNotification() {
        Log.d(LOG_TAG, "showNotification Function!");
        Intent intent = getLaunchIntent(context);
        intent.putExtra(NOTIFICATION_PAYLOAD_KEY, "TestWorld");
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        PendingIntent pendingIntent = PendingIntent.getActivity(context, NOTIFICATION_PENDING_INTENT_REQUEST_CODE, intent, PendingIntent.FLAG_IMMUTABLE);

        NotificationCompat.Builder builder = new NotificationCompat.Builder(context, DEFAULT_CHANNEL_ID)
                .setSmallIcon(R.drawable.notification_icon)
                .setContentTitle("textTitle")
                .setContentText("textContent")
                .setContentIntent(pendingIntent)
                .setAutoCancel(true)
                .setPriority(NotificationCompat.PRIORITY_DEFAULT);

        notificationManager.notify(1, builder.build());
    }

    @Override
    public void onDetachedFromActivity() {
        Log.d(LOG_TAG, "onDetachedFromActivity Function!");
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        Log.d(LOG_TAG, "onReattachedToActivityForConfigChanges Function!");
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        Log.d(LOG_TAG, "onDetachedFromActivityForConfigChanges Function!");
    }


    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}
