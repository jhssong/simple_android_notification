import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:simple_android_notification/models/channel_data.dart';
import 'package:simple_android_notification/models/listened_notification_data.dart';
import 'package:simple_android_notification/models/notification_data.dart';
import 'package:simple_android_notification/models/package_data.dart';

const _channel = MethodChannel('jhssong/simple_android_notification');

class SimpleAndroidNotification {
  Future<bool> checkNotificationChannelEnabled(ChannelData channelData) async {
    final bool? res = await _channel.invokeMethod(
        'checkNotificationChannelEnabled', {'id': channelData.id});
    return res ?? false;
  }

  Future<String> createNotificationChannel(ChannelData channelData) async {
    final String? res =
        await _channel.invokeMethod('createNotificationChannel', {
      'id': channelData.id,
      'name': channelData.name,
      'desc': channelData.desc,
      'imp': channelData.imp
    });
    return res ?? "Error";
  }

  Future<List<ChannelData>> getNotificationChannelList() async {
    final String? res =
        await _channel.invokeMethod('getNotificationChannelList');
    return ChannelData.parseJSONArrayToList(res);
  }

  Future<String> removeNotificationChannel(ChannelData channelData) async {
    final String? res = await _channel
        .invokeMethod('removeNotificationChannel', {'id': channelData.id});
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

  Future<String> showNotification(NotificationData notificationData) async {
    final String? res = await _channel.invokeMethod('showNotification', {
      'id': notificationData.id,
      'title': notificationData.title,
      'content': notificationData.content,
      'payload': notificationData.payload,
    });
    return res ?? "Error";
  }

  Future<bool> hasListenerPermission() async {
    final bool? res = await _channel.invokeMethod('hasListenerPermission');
    return res ?? false;
  }

  Future<void> openListenerPermissionSetting() async {
    await _channel.invokeMethod('openListenerPermissionSetting');
  }

  Future<List<ListenedNotificationData>> getListenedNotifications() async {
    final String? res = await _channel.invokeMethod('getListenedNotifications');
    return ListenedNotificationData.parseJSONArrayToList(res);
  }

  Future<String> removeListenedNotifications(
      ListenedNotificationData listenedNotificationData) async {
    final String? res = await _channel.invokeMethod(
        'removeListenedNotifications', {'id': listenedNotificationData.id});
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

  Future<List<PackageData>> getPackageList() async {
    final String? res = await _channel.invokeMethod('getPackageList');
    return PackageData.parseJSONArrayToList(res);
  }
}
