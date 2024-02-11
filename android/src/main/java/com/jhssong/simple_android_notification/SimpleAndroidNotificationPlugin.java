package com.jhssong.simple_android_notification;

import android.app.Activity;
import android.app.NotificationManager;
import android.content.Context;
import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import com.jhssong.simple_android_notification.models.NotificationChannelInfo;

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
        // Set Default Notification Channel
        this.simpleNotification.createNotificationChannel(Constants.DEFAULT_CHANNEL_INFO);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        final String id = call.argument("id");
        final String name = call.argument("name");
        final String desc = call.argument("desc");
        final Integer imp = call.argument("imp");
        final String packageName = call.argument("packageName");
        final String title = call.argument("title");
        final String content = call.argument("content");
        final String payload = call.argument("payload");

        switch (call.method) {
            case "checkNotificationChannelEnabled":
                result.success(simpleNotification.checkNotificationChannelEnabled(id));
                break;
            case "createNotificationChannel":
                NotificationChannelInfo info = new NotificationChannelInfo(id, name, desc, imp);
                result.success(simpleNotification.createNotificationChannel(info));
                break;
            case "getNotificationChannelList":
                result.success(simpleNotification.getNotificationChannelList());
                break;
            case "removeNotificationChannel":
                result.success(simpleNotification.removeNotificationChannel(id));
                break;
            case "getPayload":
                result.success(simpleNotification.getPayload());
                break;
            case "hasNotificationPermission":
                result.success(simpleNotification.hasNotificationPermission());
                break;
            case "requestNotificationPermission":
                simpleNotification.requestNotificationPermission();
                result.success(null);
                break;
            case "showNotification":
                result.success(simpleNotification.showNotification(id, title, content, payload));
                break;
            case "hasListenerPermission":
                result.success(simpleNotificationListener.hasListenerPermission());
                break;
            case "openListenerPermissionSetting":
                simpleNotificationListener.openListenerPermissionSetting();
                result.success(null);
                break;
            case "getListenedNotifications":
                result.success(simpleNotificationListener.getListenedNotifications());
                break;
            case "removeListenedNotifications":
                result.success(simpleNotificationListener.removeListenedNotifications(id));
                break;
            case "resetListenedNotifications":
                result.success(simpleNotificationListener.resetListenedNotifications());
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
                result.success(simpleNotificationListener.getPackageList());
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    @Override
    public void onDetachedFromActivity() {}

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {}

    @Override
    public void onDetachedFromActivityForConfigChanges() {}

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}
