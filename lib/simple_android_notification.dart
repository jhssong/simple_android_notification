import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';

const _channel = MethodChannel('jhssong/simple_android_notification');

class SimpleAndroidNotification {
  Future<String> getPayload() async {
    return await _channel.invokeMethod('getPayload') ?? "null";
  }

  Future<bool> checkNotificationChannelEnabled(String id) async {
    return await _channel
            .invokeMethod('checkNotificationChannelEnabled', {'id': id}) ??
        false;
  }

  Future<bool> createNotificationChannel(
      String id, String name, String desc, int importance) async {
    return await _channel.invokeMethod('createNotificationChannel',
            {'id': id, 'name': name, 'desc': desc, 'importance': importance}) ??
        false;
  }

  Future<bool> removeNotificationChannel(String id) async {
    return await _channel
            .invokeMethod('removeNotificationChannel', {'id': id}) ??
        false;
  }

  Future<List<dynamic>> getNotificationChannelList() async {
    final String res =
        await _channel.invokeMethod('getNotificationChannelList') ?? "[]";
    return json.decode(res);
  }

  Future<bool> hasNotificationPermission() async {
    return await _channel.invokeMethod('hasNotificationPermission') ?? false;
  }

  Future<bool> requestNotificationPermission() async {
    return await _channel.invokeMethod('requestNotificationPermission') ??
        false;
  }

  Future<bool> showNotification(
      String id, String title, String content, String payload) async {
    if (!await checkNotificationChannelEnabled(id)) {
      log("NotificationChannel was unable!");
      return false;
    }
    if (!await hasNotificationPermission()) {
      log("NotificationPermission was denied!");
      return false;
    }
    await _channel.invokeMethod('showNotification',
        {'id': id, 'title': title, 'content': content, 'payload': payload});
    return true;
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
