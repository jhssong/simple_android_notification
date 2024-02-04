import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';

const _channel = MethodChannel('jhssong/simple_android_notification');

class SimpleAndroidNotification {
  Future<String> getPayload() async {
    return await _channel.invokeMethod('getPayload') ?? "null";
  }

  // TODO checkNotificationChannelEnabled (if necessary)

  Future<bool> createNotificationChannel(
      String id, String name, String desc, int importance) async {
    return await _channel.invokeMethod('createNotificationChannel', {
          'id': id,
          'name': name,
          'desc': desc,
          'importance': importance,
        }) ??
        false;
  }

  // TODO delete notification channel

  // TODO get Notification Channel List

  Future<bool> hasNotificationPermission() async {
    return await _channel.invokeMethod('hasNotificationPermission') ?? false;
  }

  Future<bool> requestNotificationPermission() async {
    return await _channel.invokeMethod('requestNotificationPermission') ??
        false;
  }

  Future<void> showNotification() async {
    // TODO check if channel is created
    if (!await hasNotificationPermission()) {
      log("NotificationPermission was denied!");
      return;
    }
    await _channel.invokeMethod('showNotification');
  }

  Future<bool> hasNotificationListenerPermission() async {
    return await _channel.invokeMethod('hasNotificationListenerPermission') ??
        false;
  }

  Future<bool> openNotificationListenerPermissionSetting() async {
    return await _channel
            .invokeMethod('openNotificationListenerPermissionSetting') ??
        false;
  }

  Future<List<dynamic>> getListenedNotificationsList() async {
    final String res =
        await _channel.invokeMethod('getListenedNotificationsList') ?? "[]";
    return json.decode(res);
  }
}
