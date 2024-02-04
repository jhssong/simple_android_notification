import 'simple_android_notification_platform_interface.dart';

class SimpleAndroidNotification {
  Future<String?> getPayload() {
    return SimpleAndroidNotificationPlatform.instance.getPayload();
  }

  Future<void> createChannel(
    String id,
    String name,
    String desc,
    int importance,
  ) {
    return SimpleAndroidNotificationPlatform.instance
        .createChannel(id, name, desc, importance);
  }

  Future<bool?> checkNotificationPermission() {
    return SimpleAndroidNotificationPlatform.instance
        .checkNotificationPermission();
  }

  Future<void> requestNotificationPermission() {
    return SimpleAndroidNotificationPlatform.instance
        .requestNotificationPermission();
  }

  Future<void> show() {
    return SimpleAndroidNotificationPlatform.instance.show();
  }

  Future<void> openNotificationListenerPermissionSettingScreen() {
    return SimpleAndroidNotificationPlatform.instance
        .openNotificationListenerPermissionSettingScreen();
  }

  Future<List<dynamic>> getListenedNotificationsList() {
    return SimpleAndroidNotificationPlatform.instance
        .getListenedNotificationsList();
  }
}
