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
        final Integer importance = call.argument("importance");
        final String packageName = call.argument("packageName");
        final String title = call.argument("title");
        final String content = call.argument("content");
        final String payload = call.argument("payload");

        // TODO When you handle the exception return what was that
        switch (call.method) {
            case "checkNotificationChannelEnabled":
                result.success(simpleNotification.checkNotificationChannelEnabled(id));
                break;
            case "createNotificationChannel":
                NotificationChannelInfo info = new NotificationChannelInfo(id, name, desc, importance);
                result.success(simpleNotification.createNotificationChannel(info));
                break;
            case "removeNotificationChannel":
                result.success(simpleNotification.removeNotificationChannel(id));
                break;
            case "getNotificationChannelList":
                result.success(simpleNotification.getNotificationChannelList());
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
            case "hasNotificationListenerPermission":
                result.success(simpleNotificationListener.hasNotificationListenerPermission());
                break;
            case "openNotificationListenerPermissionSetting":
                simpleNotificationListener.openNotificationListenerPermissionSetting();
                result.success(simpleNotificationListener.hasNotificationListenerPermission());
                break;
            case "getListenedNotificationsList":
                result.success(simpleNotificationListener.getListenedNotificationsList());
                break;
            case "updateListenedNotificationsList":
                simpleNotificationListener.updateListenedNotificationsList(id);
                result.success(simpleNotificationListener.getListenedNotificationsList());
                break;
            case "resetListenedNotificationsList":
                simpleNotificationListener.resetListenedNotificationsList();
                result.success(simpleNotificationListener.getListenedNotificationsList());
                break;
            case "setListenerFilter":
                simpleNotificationListener.setListenerFilter(packageName);
                result.success(simpleNotificationListener.getListenerFilter());
                break;
            case "getListenerFilter":
                result.success(simpleNotificationListener.getListenerFilter());
                break;
            case "updateListenerFilter":
                simpleNotificationListener.updateListenerFilter(packageName);
                result.success(simpleNotificationListener.getListenerFilter());
                break;
            case "resetListenerFilter":
                simpleNotificationListener.resetListenerFilter();
                result.success(simpleNotificationListener.getListenerFilter());
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
