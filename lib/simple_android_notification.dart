import 'dart:convert';

import 'package:flutter/services.dart';

const _channel = MethodChannel('jhssong/simple_android_notification');

class SimpleAndroidNotification {
  Future<bool> checkNotificationChannelEnabled(String id) async {
    final bool? res = await _channel
        .invokeMethod('checkNotificationChannelEnabled', {'id': id});
    return res ?? false;
  }

  Future<String> createNotificationChannel(
      String id, String name, String desc, int importance) async {
    final String? res = await _channel.invokeMethod('createNotificationChannel',
        {'id': id, 'name': name, 'desc': desc, 'importance': importance});
    return res ?? "Error";
  }

  Future<List<dynamic>> getNotificationChannelList() async {
    final String? res =
        await _channel.invokeMethod('getNotificationChannelList');
    return json.decode(res ?? '[]');
  }

  Future<String> removeNotificationChannel(String id) async {
    final String? res =
        await _channel.invokeMethod('removeNotificationChannel', {'id': id});
    return res ?? "Error";
  }

  Future<String> getPayload() async {
    final String? res = await _channel.invokeMethod('getPayload');
    return res ?? "Error";
  }

  Future<bool> hasNotificationPermission() async {
    final bool? res = await _channel.invokeMethod('hasNotificationPermission');
    return res ?? false;
  }

  Future<void> requestNotificationPermission() async {
    await _channel.invokeMethod('requestNotificationPermission');
  }

  Future<String> showNotification(
      String id, String title, String content, String payload) async {
    final String? res = await _channel.invokeMethod('showNotification',
        {'id': id, 'title': title, 'content': content, 'payload': payload});
    return res ?? "Error";
  }

  Future<bool> hasListenerPermission() async {
    final bool? res = await _channel.invokeMethod('hasListenerPermission');
    return res ?? false;
  }

  Future<void> openListenerPermissionSetting() async {
    await _channel.invokeMethod('openListenerPermissionSetting');
  }

  Future<List<dynamic>> getListenedNotifications() async {
    final String? res = await _channel.invokeMethod('getListenedNotifications');
    return json.decode(res ?? '[]');
  }

  Future<String> removeListenedNotifications(String id) async {
    final String? res =
        await _channel.invokeMethod('removeListenedNotifications', {'id': id});
    return res ?? "Error";
  }

  Future<String> resetListenedNotifications() async {
    final String? res =
        await _channel.invokeMethod('resetListenedNotifications');
    return res ?? "Error";
  }

  Future<String> addListenerFilter(String packageName) async {
    final String? res = await _channel
        .invokeMethod('addListenerFilter', {'packageName': packageName});
    return res ?? "Error";
  }

  Future<List<dynamic>> getListenerFilter() async {
    final String? res = await _channel.invokeMethod('getListenerFilter');
    return json.decode(res ?? '[]');
  }

  Future<String> removeListenerFilter(String packageName) async {
    final String? res = await _channel
        .invokeMethod('removeListenerFilter', {'packageName': packageName});
    return res ?? "Error";
  }

  Future<String> resetListenerFilter() async {
    final String? res = await _channel.invokeMethod('resetListenerFilter');
    return res ?? "Error";
  }
}
