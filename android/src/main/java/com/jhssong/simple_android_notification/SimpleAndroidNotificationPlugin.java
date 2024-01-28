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

/** SimpleAndroidNotificationPlugin */
public class SimpleAndroidNotificationPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  private Context context;
  private Activity activity;
  private MethodChannel channel;
  private static final String METHOD_CHANNEL = "jhssong.com/simple_android_notification";

  private NotificationManager notificationManager;

  String test_channel_id = "Test_Channel_ID";
  private static final int NOTIFICATION_PERMISSIONS_REQUEST_CODE = 1001;
  private static final int NOTIFICATION_PENDING_INTENT_REQUEST_CODE = 1002;
  private static final String LOG_TAG = "simple_android_notification";
  private static final String NOTIFICATION_PAYLOAD_KEY = "payload_key";

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    Log.d(LOG_TAG, "onAttachedToEngine Function!");
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), METHOD_CHANNEL);
    channel.setMethodCallHandler(this);
    this.context = flutterPluginBinding.getApplicationContext();
    notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
    createNotificationChannel();
    // onAttachedToEngine -> onAttachedToActivity -> flutter -> onDetachedFromActivity -> onDetachedFromEngine
  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding binding) {
    Log.d(LOG_TAG, "onAttachedToActivity Function!");
    this.activity = binding.getActivity();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method) {
      case "getPayloadFromIntent":
//        result.success("Android " + android.os.Build.VERSION.RELEASE);
        // Retrieve payload data from Intent extras
        Intent activityIntent = activity.getIntent();
        String payload;

        if (activityIntent != null) {
          Bundle extras = activityIntent.getExtras();
          if (extras != null && extras.containsKey(NOTIFICATION_PAYLOAD_KEY)) {
            payload = extras.getString(NOTIFICATION_PAYLOAD_KEY);
            if (payload != null) Log.d(LOG_TAG, "Payload: " + payload);
            else Log.d(LOG_TAG, "Payload is null");
          }
          else {
            Log.d(LOG_TAG, "Payload key not found iterate all extras");
            payload = null;

            // Iterate over all extras
            for (String key : extras.keySet()) {
              Object value = extras.get(key);
              Log.d(LOG_TAG, "Key: " + key + ", Value: " + value.toString());
            }
          }
          result.success(payload);
        }
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

  private static Intent getLaunchIntent(Context context) {
    String packageName = context.getPackageName();
    PackageManager packageManager = context.getPackageManager();
    return packageManager.getLaunchIntentForPackage(packageName);
  }

  private void showNotification() {
    Log.d(LOG_TAG, "showNotification Function!");
    Intent intent = getLaunchIntent(context);
    intent.putExtra(NOTIFICATION_PAYLOAD_KEY, "TestWorld");
    intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
    PendingIntent pendingIntent = PendingIntent.getActivity(context, NOTIFICATION_PENDING_INTENT_REQUEST_CODE, intent, PendingIntent.FLAG_IMMUTABLE);

    NotificationCompat.Builder builder = new NotificationCompat.Builder(context, test_channel_id)
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
//    throw new UnsupportedOperationException("Not yet implemented");
    Log.d(LOG_TAG, "onDetachedFromActivity Function!");
  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
//    throw new UnsupportedOperationException("Not yet implemented");
    Log.d(LOG_TAG, "onReattachedToActivityForConfigChanges Function!");
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
//    throw new UnsupportedOperationException("Not yet implemented");
    Log.d(LOG_TAG, "onDetachedFromActivityForConfigChanges Function!");
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    Log.d(LOG_TAG, "onDetachedFromEngine Function!");
    channel.setMethodCallHandler(null);
  }
}
