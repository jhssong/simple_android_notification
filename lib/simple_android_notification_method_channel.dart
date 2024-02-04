import 'dart:convert';
import 'package:flutter/services.dart';

import 'simple_android_notification_platform_interface.dart';

const _methodChannel = 'jhssong/simple_android_notification';
const _channel = MethodChannel(_methodChannel);

/// An implementation of [SimpleAndroidNotificationPlatform] that uses method channels.
class MethodChannelSimpleAndroidNotification
    extends SimpleAndroidNotificationPlatform {
  /// The method channel used to interact with the native platform.

  @override
  Future<String?> getPayload() async {
    final version = await _channel.invokeMethod<String>('getPayloadFromIntent');
    return version;
  }

  @override
  Future<void> createChannel(
    String id,
    String name,
    String desc,
    int importance,
  ) async {
    await _channel
        .invokeMethod<void>('createNotificationChannel', <String, dynamic>{
      'id': id,
      'name': name,
      'desc': desc,
      'importance': importance,
    });
  }

  @override
  Future<bool?> checkNotificationPermission() async {
    final hasPermission =
        await _channel.invokeMethod<bool?>('checkNotificationPermission');
    return hasPermission;
  }

  @override
  Future<void> requestNotificationPermission() async {
    await _channel.invokeMethod<String?>('requestNotificationPermission');
  }

  @override
  Future<void> show() async {
    // TODO check if channel is created and have the notification permissions
    await _channel.invokeMethod<String?>('showNotification');
  }

  @override
  Future<void> openNotificationListenerPermissionSettingScreen() async {
    await _channel.invokeMethod<String?>(
        'openNotificationListenerPermissionSettingScreen');
  }

  @override
  Future<List<dynamic>> getListenedNotificationsList() async {
    final String res =
        await _channel.invokeMethod('getListenedNotificationsList');
    final List<dynamic> jsonArray = json.decode(res);
    return jsonArray;
  }
}
