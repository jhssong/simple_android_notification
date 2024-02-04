package com.jhssong.simple_android_notification;

import static com.jhssong.simple_android_notification.SimpleNotificationListener.checkNotificationListenerPermission;
import static com.jhssong.simple_android_notification.SimpleNotificationListener.getListenedNotificationsList;
import static com.jhssong.simple_android_notification.SimpleNotificationListener.openNotificationListenerPermissionSettingScreen;

import android.app.Activity;
import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;

import androidx.annotation.NonNull;
import androidx.core.app.NotificationManagerCompat;

import java.util.Set;

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
public class SimpleAndroidNotificationPlugin
        implements FlutterPlugin, MethodCallHandler, ActivityAware {


    private Context context;
    private Activity activity;
    private MethodChannel channel;
    private NotificationManager notificationManager;
    private SimpleNotification simpleNotification;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        Log.d(Constants.LOG_TAG, "onAttachedToEngine Function!");
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), Constants.METHOD_CHANNEL);
        channel.setMethodCallHandler(this);
        this.context = flutterPluginBinding.getApplicationContext();
        this.notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);

    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        Log.d(Constants.LOG_TAG, "onAttachedToActivity Function!");
        this.activity = binding.getActivity();
        simpleNotification = new SimpleNotification(context, activity, notificationManager);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "getPayloadFromIntent":
                result.success(getPayloadExtra());
                break;
            case "checkNotificationChannelEnabled":
                result.success(simpleNotification.checkNotificationChannelEnabled(Constants.DEFAULT_CHANNEL_ID));
                break;
            case "createNotificationChannel":
                final String id = call.argument("id");
                final String name = call.argument("name");
                final String desc = call.argument("desc");
                final int importance = Constants.getImportance(call.argument("importance"));
                simpleNotification.createNotificationChannel(id, name, desc, importance);
                break;

            // TODO delete notification channel

            // TODO get Notification Channel List

            case "checkNotificationPermission":
                result.success(simpleNotification.checkNotificationPermission());
                break;
            case "requestNotificationPermission":
                simpleNotification.requestNotificationPermission();
                break;
            case "showNotification":
                simpleNotification.showNotification(
                        "testTitle", "testContent", "testPayload");
                break;
            case "checkNotificationListenerPermission":
                result.success(checkNotificationListenerPermission(context));
                break;
            case "openNotificationListenerPermissionSettingScreen":
                openNotificationListenerPermissionSettingScreen(context);
                break;
            case "getListenedNotificationsList":
                result.success(getListenedNotificationsList(context));
                break;

            // TODO Delete ListenedNotification List

            // TODO Update ListenedNotification List
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
            if (extras != null && extras.containsKey(Constants.NOTIFICATION_PAYLOAD_KEY)) {
                payload = extras.getString(Constants.NOTIFICATION_PAYLOAD_KEY);
            } else {
                payload = null;
                Log.d(Constants.LOG_TAG, "Payload key not found iterate all extras");
                if (extras != null) {
                    for (String key : extras.keySet()) {
                        Object value = extras.get(key);
                        String valueString = value != null ? value.toString() : null;
                        Log.d(Constants.LOG_TAG, "Key: " + key + ", Value: " + valueString);
                    }
                }
            }
        } else payload = null;

        return payload;
    }






    @Override
    public void onDetachedFromActivity() {
        Log.d(Constants.LOG_TAG, "onDetachedFromActivity Function!");
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        Log.d(Constants.LOG_TAG, "onReattachedToActivityForConfigChanges Function!");
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        Log.d(Constants.LOG_TAG, "onDetachedFromActivityForConfigChanges Function!");
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}
