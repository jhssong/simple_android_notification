import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'simple_android_notification_method_channel.dart';

abstract class SimpleAndroidNotificationPlatform extends PlatformInterface {
  /// Constructs a SimpleAndroidNotificationPlatform.
  SimpleAndroidNotificationPlatform() : super(token: _token);

  static final Object _token = Object();

  static SimpleAndroidNotificationPlatform _instance =
      MethodChannelSimpleAndroidNotification();

  /// The default instance of [SimpleAndroidNotificationPlatform] to use.
  ///
  /// Defaults to [MethodChannelSimpleAndroidNotification].
  static SimpleAndroidNotificationPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SimpleAndroidNotificationPlatform] when
  /// they register themselves.
  static set instance(SimpleAndroidNotificationPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPayload() {
    throw UnimplementedError('getPayload() has not been implemented.');
  }

  Future<void> createChannel(
    String id,
    String name,
    String desc,
    int importance,
  ) {
    throw UnimplementedError('createChannel() has not been implemented.');
  }

  Future<bool?> checkNotificationPermission() {
    throw UnimplementedError(
        'checkNotificationPermission() has not been implemented.');
  }

  Future<void> requestNotificationPermission() {
    throw UnimplementedError(
        'requestNotificationPermission() has not been implemented.');
  }

  Future<void> show() {
    throw UnimplementedError('show() has not been implemented.');
  }

  Future<void> openNotificationListenerPermissionSettingScreen() {
    throw UnimplementedError(
        'openNotificationListenerPermissionSettingScreen() has not been implemented.');
  }

  Future<List<dynamic>> getListenedNotificationsList() {
    throw UnimplementedError(
        'getListenedNotificationsList() has not been implemented.');
  }
}
