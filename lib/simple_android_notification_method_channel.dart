import 'package:flutter/services.dart';

import 'simple_android_notification_platform_interface.dart';

const _methodChannel = 'jhssong.com/simple_android_notification';
const _channel = MethodChannel(_methodChannel);

/// An implementation of [SimpleAndroidNotificationPlatform] that uses method channels.
class MethodChannelSimpleAndroidNotification
    extends SimpleAndroidNotificationPlatform {
  /// The method channel used to interact with the native platform.

  @override
  Future<String> getPlatformVersion() async {
    final version = await _channel.invokeMethod<String>('getPlatformVersion');
    return version ?? 'Unknown platform version';
  }

  @override
  Future<String> checkPermission() async {
    final hasPermission =
        await _channel.invokeMethod<String>('checkNotificationPermission');
    return hasPermission ?? "false";
  }

  @override
  Future<void> requestPermission() async {
    await _channel.invokeMethod<void>('requestNotificationPermission');
    return;
  }

  @override
  Future<void> show() async {
    await _channel.invokeMethod<String>('showNotification');
    return;
  }
}
