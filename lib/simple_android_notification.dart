import 'simple_android_notification_platform_interface.dart';

class SimpleAndroidNotification {
  Future<String?> getPayload() {
    return SimpleAndroidNotificationPlatform.instance.getPayload();
  }

  Future<String> checkPermission() {
    return SimpleAndroidNotificationPlatform.instance.checkPermission();
  }

  Future<void> requestPermission() {
    return SimpleAndroidNotificationPlatform.instance.requestPermission();
  }

  Future<void> show() {
    return SimpleAndroidNotificationPlatform.instance.show();
  }
}
