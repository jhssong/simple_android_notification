// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:simple_android_notification/models/channel_data.dart';
import 'package:simple_android_notification/models/listened_data.dart';
import 'package:simple_android_notification/models/notification_data.dart';
import 'package:simple_android_notification/models/package_data.dart';

const _channel = MethodChannel('jhssong/simple_android_notification');

enum ErrorCode {
  UNAUTHORIZED,
  JSON_EXCEPTION,
  UNKNOWN,
  CHANNEL_DUPLICATE,
  CHANNEL_NON_EXISTS,
  NOTIFY_FAILED
}

String getErrorCode(ErrorCode code) {
  switch (code) {
    case ErrorCode.UNAUTHORIZED:
      return "1001";
    case ErrorCode.JSON_EXCEPTION:
      return "1002";
    case ErrorCode.UNKNOWN:
      return "1003";
    case ErrorCode.CHANNEL_DUPLICATE:
      return "2001";
    case ErrorCode.CHANNEL_NON_EXISTS:
      return "2002";
    case ErrorCode.NOTIFY_FAILED:
      return "3001";
    default:
      return "1001";
  }
}

String getErrorMsg(ErrorCode code) {
  switch (code) {
    case ErrorCode.UNAUTHORIZED:
      return "Doesn't have permission";
    case ErrorCode.JSON_EXCEPTION:
      return "Failed to add item to JsonArray";
    case ErrorCode.UNKNOWN:
      return "Unknown error";
    case ErrorCode.CHANNEL_DUPLICATE:
      return "Channel already exists";
    case ErrorCode.CHANNEL_NON_EXISTS:
      return "Channel doesn't exists";
    case ErrorCode.NOTIFY_FAILED:
      return "Failed to send notifications";
    default:
      return "1001";
  }
}

class SimpleAndroidNotification {
  Future<bool> checkNotificationChannelEnabled(ChannelData data) async {
    bool? res;
    try {
      res = await _channel
          .invokeMethod('checkNotificationChannelEnabled', {'id': data.id});
    } on PlatformException catch (e) {
      log(getErrorMsg(ErrorCode.UNKNOWN) + (e.message ?? "null"));
    }
    return res ?? false;
  }

  Future<void> createNotificationChannel(ChannelData data) async {
    if (await checkNotificationChannelEnabled(data) == true) {
      log(getErrorMsg(ErrorCode.CHANNEL_DUPLICATE));
      return;
    }
    try {
      await _channel.invokeMethod(
          'createNotificationChannel', ChannelData.toMap(data));
    } on PlatformException catch (e) {
      log(getErrorMsg(ErrorCode.UNKNOWN) + (e.message ?? "null"));
    }
  }

  Future<List<ChannelData>> getNotificationChannelList() async {
    String? res;
    try {
      res = await _channel.invokeMethod('getNotificationChannelList');
    } on PlatformException catch (e) {
      if (e.code == getErrorCode(ErrorCode.CHANNEL_DUPLICATE)) {
        log(getErrorMsg(ErrorCode.NOTIFY_FAILED) + (e.message ?? "null"));
      } else {
        log(getErrorMsg(ErrorCode.UNKNOWN) + (e.message ?? "null"));
      }
    }
    return ChannelData.toList(res);
  }

  Future<void> removeNotificationChannel(ChannelData data) async {
    if (await checkNotificationChannelEnabled(data) == false) {
      log(getErrorMsg(ErrorCode.CHANNEL_NON_EXISTS));
      return;
    }
    try {
      await _channel.invokeMethod('removeNotificationChannel', {'id': data.id});
    } on PlatformException catch (e) {
      log(getErrorMsg(ErrorCode.UNKNOWN) + (e.message ?? "null"));
    }
  }

  Future<String> getPayload() async {
    String? res;
    try {
      res = await _channel.invokeMethod('getPayload');
    } on PlatformException catch (e) {
      log(getErrorMsg(ErrorCode.UNKNOWN) + (e.message ?? "null"));
    }
    return res ?? "error with invokeMethod";
  }

  Future<bool> hasNotificationPermission() async {
    bool? res;
    try {
      res = await _channel.invokeMethod('hasNotificationPermission');
    } on PlatformException catch (e) {
      log(getErrorMsg(ErrorCode.UNKNOWN) + (e.message ?? "null"));
    }
    return res ?? false;
  }

  Future<void> requestNotificationPermission() async {
    try {
      await _channel.invokeMethod('requestNotificationPermission');
    } on PlatformException catch (e) {
      log(getErrorMsg(ErrorCode.UNKNOWN) + (e.message ?? "null"));
    }
  }

  Future<void> showNotification(NotificationData data) async {
    if (await hasNotificationPermission() == false) {
      log(getErrorMsg(ErrorCode.UNAUTHORIZED));
      return;
    }

    ChannelData channelData =
        ChannelData(id: data.channelId, name: "", desc: "", imp: -1);
    if (await checkNotificationChannelEnabled(channelData) == false) {
      log(getErrorMsg(ErrorCode.CHANNEL_NON_EXISTS));
      return;
    }

    try {
      await _channel.invokeMethod(
          'showNotification', NotificationData.toMap(data));
    } on PlatformException catch (e) {
      if (e.code == getErrorCode(ErrorCode.CHANNEL_DUPLICATE)) {
        log(getErrorMsg(ErrorCode.NOTIFY_FAILED) + (e.message ?? "null"));
      } else {
        log(getErrorMsg(ErrorCode.UNKNOWN) + (e.message ?? "null"));
      }
    }
  }

  Future<bool> hasListenerPermission() async {
    bool? res;
    try {
      res = await _channel.invokeMethod('hasListenerPermission');
    } on PlatformException catch (e) {
      log(getErrorMsg(ErrorCode.UNKNOWN) + (e.message ?? "null"));
    }
    return res ?? false;
  }

  Future<void> openListenerPermissionSetting() async {
    try {
      await _channel.invokeMethod('openListenerPermissionSetting');
    } on PlatformException catch (e) {
      log(getErrorMsg(ErrorCode.UNKNOWN) + (e.message ?? "null"));
    }
  }

  Future<List<ListenedData>> getListenedNotifications() async {
    String? res;
    try {
      res = await _channel.invokeMethod('getListenedNotifications');
    } on PlatformException catch (e) {
      if (e.code == getErrorCode(ErrorCode.JSON_EXCEPTION)) {
        log(getErrorMsg(ErrorCode.JSON_EXCEPTION) + (e.message ?? "null"));
      } else {
        log(getErrorMsg(ErrorCode.UNKNOWN) + (e.message ?? "null"));
      }
    }
    return ListenedData.parseJSONArrayToList(res);
  }

  Future<void> removeListenedNotifications(ListenedData data) async {
    try {
      await _channel
          .invokeMethod('removeListenedNotifications', {'id': data.id});
    } on PlatformException catch (e) {
      log(getErrorMsg(ErrorCode.UNKNOWN) + (e.message ?? "null"));
    }
  }

  Future<void> resetListenedNotifications() async {
    try {
      await _channel.invokeMethod('resetListenedNotifications');
    } on PlatformException catch (e) {
      log(getErrorMsg(ErrorCode.UNKNOWN) + (e.message ?? "null"));
    }
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
    String? res;
    try {
      res = await _channel.invokeMethod('getPackageList');
    } on PlatformException catch (e) {
      if (e.code == getErrorCode(ErrorCode.JSON_EXCEPTION)) {
        log(getErrorMsg(ErrorCode.JSON_EXCEPTION) + (e.message ?? "null"));
      } else {
        log(getErrorMsg(ErrorCode.UNKNOWN) + (e.message ?? "null"));
      }
    }
    return PackageData.parseJSONArrayToList(res);
  }
}
