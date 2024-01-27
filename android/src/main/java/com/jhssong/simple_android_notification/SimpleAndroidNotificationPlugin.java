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

/** SimpleAndroidNotificationPlugin */
public class SimpleAndroidNotificationPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  private Context context;
  private Activity activity;
  private MethodChannel channel;
  private static final String METHOD_CHANNEL = "jhssong.com/simple_android_notification";

  private NotificationManager notificationManager;

  String test_channel_id = "Test_Channel_ID";
  public static final int NOTIFICATION_PERMISSIONS_REQUEST_CODE = 1001;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), METHOD_CHANNEL);
    channel.setMethodCallHandler(this);
    this.context = flutterPluginBinding.getApplicationContext();
    notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
    createNotificationChannel();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method) {
      case "getPlatformVersion":
        result.success("Android " + android.os.Build.VERSION.RELEASE);
        break;
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

  private void createNotificationChannel() {
    // Create the NotificationChannel, but only on API 26+ because
    // the NotificationChannel class is not in the Support Library.
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      CharSequence name = "Test_Channel";
      String description = "Hi i am Test_channel";
      int importance = NotificationManager.IMPORTANCE_DEFAULT;

      NotificationChannel channel = new NotificationChannel(test_channel_id, name, importance);
      channel.setDescription(description);

      // Register the channel with the system; you can't change the importance
      // or other notification behaviors after this.
      notificationManager.createNotificationChannel(channel);
    }
  }

  private String checkNotificationPermission() {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      if (ContextCompat.checkSelfPermission(
              context, Manifest.permission.POST_NOTIFICATIONS)
              == PackageManager.PERMISSION_GRANTED) {
        return "true";
      }
      else {
        return "false";
      }
    }
    else {
      return "true";
    }
  }

  private void requestNotificationPermission() {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
      requestPermissions(activity,
              new String[]{Manifest.permission.POST_NOTIFICATIONS},
              NOTIFICATION_PERMISSIONS_REQUEST_CODE);
    }
  }

  private void showNotification() {
    Log.d("simple_android_notification", "showNotification Function!");
    // Create an explicit intent for an Activity in your app.
    Intent intent = new Intent(context, SimpleAndroidNotificationPlugin.class);
    intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
    PendingIntent pendingIntent = PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_IMMUTABLE);

    NotificationCompat.Builder builder = new NotificationCompat.Builder(context, test_channel_id)
            .setSmallIcon(R.drawable.notification_icon)
            .setContentTitle("textTitle")
            .setContentText("textContent")
            .setContentIntent(pendingIntent)
            .setPriority(NotificationCompat.PRIORITY_DEFAULT);

    notificationManager.notify(1, builder.build());
  }


  @Override
  public void onDetachedFromActivity() {
    throw new UnsupportedOperationException("Not yet implemented");
  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
    throw new UnsupportedOperationException("Not yet implemented");
  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding binding) {
    this.activity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    throw new UnsupportedOperationException("Not yet implemented");
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
