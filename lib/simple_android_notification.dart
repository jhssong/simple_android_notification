import 'dart:convert';

import 'package:flutter/services.dart';

const _channel = MethodChannel('jhssong/simple_android_notification');

class SimpleAndroidNotification {
  Future<String> getPayload() async {
    final String? res = await _channel.invokeMethod('getPayload');
    return res ?? "null";
  }

  Future<bool> checkNotificationChannelEnabled(String id) async {
    final bool? res = await _channel
        .invokeMethod('checkNotificationChannelEnabled', {'id': id});
    return res ?? false;
  }

  Future<bool> createNotificationChannel(
      String id, String name, String desc, int importance) async {
    final bool? res = await _channel.invokeMethod('createNotificationChannel',
        {'id': id, 'name': name, 'desc': desc, 'importance': importance});
    return res ?? false;
  }

  Future<bool> removeNotificationChannel(String id) async {
    final bool? res =
        await _channel.invokeMethod('removeNotificationChannel', {'id': id});
    return res ?? false;
  }

  Future<List<dynamic>> getNotificationChannelList() async {
    final String? res =
        await _channel.invokeMethod('getNotificationChannelList');
    return json.decode(res ?? '[]');
  }

  Future<bool> hasNotificationPermission() async {
    final bool? res = await _channel.invokeMethod('hasNotificationPermission');
    return res ?? false;
  }

  Future<bool> requestNotificationPermission() async {
    final bool? res =
        await _channel.invokeMethod('requestNotificationPermission');
    return res ?? false;
  }

  Future<bool> showNotification(
      String id, String title, String content, String payload) async {
    await _channel.invokeMethod('showNotification',
        {'id': id, 'title': title, 'content': content, 'payload': payload});
    return true;
  }

  Future<bool> hasNotificationListenerPermission() async {
    final bool? res =
        await _channel.invokeMethod('hasNotificationListenerPermission');
    return res ?? false;
  }

  Future<bool> openNotificationListenerPermissionSetting() async {
    final bool? res = await _channel
        .invokeMethod('openNotificationListenerPermissionSetting');
    return res ?? false;
  }

  Future<List<dynamic>> getListenedNotificationsList() async {
    final String? res =
        await _channel.invokeMethod('getListenedNotificationsList');
    return json.decode(res ?? '[]');
  }

  Future<List<dynamic>> updateListenedNotificationsList(String id) async {
    final String? res = await _channel
        .invokeMethod('updateListenedNotificationsList', {'id': id});
    return json.decode(res ?? '[]');
  }

  Future<List<dynamic>> resetListenedNotificationsList() async {
    final String? res =
        await _channel.invokeMethod('resetListenedNotificationsList');
    return json.decode(res ?? '[]');
  }

  Future<List<dynamic>> setListenerFilter(String packageName) async {
    final String? res = await _channel
        .invokeMethod('setListenerFilter', {'packageName': packageName});
    return json.decode(res ?? '[]');
  }

  Future<List<dynamic>> getListenerFilter() async {
    final String? res = await _channel.invokeMethod('getListenerFilter');
    return json.decode(res ?? '[]');
  }

  Future<List<dynamic>> updateListenerFilter(String packageName) async {
    final String? res = await _channel
        .invokeMethod('updateListenerFilter', {'packageName': packageName});
    return json.decode(res ?? '[]');
  }

  Future<List<dynamic>> resetListenerFilter() async {
    final String? res = await _channel.invokeMethod('resetListenerFilter');
    return json.decode(res ?? '[]');
  }
}
