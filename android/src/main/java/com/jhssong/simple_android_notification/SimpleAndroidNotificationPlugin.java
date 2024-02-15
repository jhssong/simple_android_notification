package com.jhssong.simple_android_notification;

import android.app.Activity;
import android.app.NotificationManager;
import android.content.Context;
import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

@RequiresApi(api = Build.VERSION_CODES.O)
public class SimpleAndroidNotificationPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
    private Context context;
    private MethodChannel channel;
    private NotificationManager notificationManager;
    private SimpleNotification simpleNotification;
    private SimpleNotificationListener simpleNotificationListener;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), Constants.METHOD_CHANNEL);
        channel.setMethodCallHandler(this);
        this.context = flutterPluginBinding.getApplicationContext();
        this.notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        Activity activity = binding.getActivity();
        this.simpleNotification = new SimpleNotification(context, activity, notificationManager);
        this.simpleNotificationListener = new SimpleNotificationListener(context);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        final String packageName = call.argument("packageName");

        switch (call.method) {
            case "checkNotificationChannelEnabled":
                simpleNotification.checkNotificationChannelEnabled(call, result);
                break;
            case "createNotificationChannel":
                simpleNotification.createNotificationChannel(call, result);
                break;
            case "getNotificationChannelList":
                simpleNotification.getNotificationChannelList(result);
                break;
            case "removeNotificationChannel":
                simpleNotification.removeNotificationChannel(call, result);
                break;
            case "getPayload":
                simpleNotification.getPayload(result);
                break;
            case "hasNotificationPermission":
                result.success(simpleNotification.hasNotificationPermission());
                break;
            case "requestNotificationPermission":
                simpleNotification.requestNotificationPermission(result);
                break;
            case "showNotification":
                simpleNotification.showNotification(call, result);
                break;
            case "hasListenerPermission":
                simpleNotificationListener.hasListenerPermission(result);
                break;
            case "openListenerPermissionSetting":
                simpleNotificationListener.openListenerPermissionSetting(result);
                break;
            case "getListenedNotifications":
                simpleNotificationListener.getListenedNotifications(result);
                break;
            case "removeListenedNotifications":
                simpleNotificationListener.removeListenedNotifications(call, result);
                break;
            case "resetListenedNotifications":
                simpleNotificationListener.resetListenedNotifications(result);
                break;
            case "addListenerFilter":
                result.success(simpleNotificationListener.addListenerFilter(packageName));
                break;
            case "getListenerFilter":
                result.success(simpleNotificationListener.getListenerFilter());
                break;
            case "removeListenerFilter":
                result.success(simpleNotificationListener.removeListenerFilter(packageName));
                break;
            case "resetListenerFilter":
                result.success(simpleNotificationListener.resetListenerFilter());
                break;
            case "getPackageList":
                simpleNotificationListener.getPackageList(result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    @Override
    public void onDetachedFromActivity() {
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}
