import 'dart:convert';
import 'dart:developer';

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
    return res ?? "error";
  }

  Future<String> removeNotificationChannel(String id) async {
    final String? res =
        await _channel.invokeMethod('removeNotificationChannel', {'id': id});
    return res ?? "error";
  }

  Future<List<dynamic>> getNotificationChannelList() async {
    final String? res =
        await _channel.invokeMethod('getNotificationChannelList');
    return json.decode(res ?? '[]');
  }

  Future<String> getPayload() async {
    final String? res = await _channel.invokeMethod('getPayload');
    return res ?? "error";
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
    return res ?? 'error';
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
