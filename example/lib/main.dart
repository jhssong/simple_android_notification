import 'package:flutter/material.dart';
import 'dart:async';

import 'package:simple_android_notification/simple_android_notification.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _payload;
  List<dynamic> _listendArray = [];
  bool _hasNotificationPermission = false;
  final bool _hasNotificationListenerPermission = false;
  final _simpleAndroidNotificationPlugin = SimpleAndroidNotification();

  @override
  void initState() {
    super.initState();
    getPayload();
    hasNotificationPermission();
  }

  Future<void> getPayload() async {
    String? payload = await _simpleAndroidNotificationPlugin.getPayload();
    setState(() => _payload = payload);
  }

  Future<void> hasNotificationPermission() async {
    bool hasNotificationPermission =
        await _simpleAndroidNotificationPlugin.checkNotificationPermission() ??
            false;
    setState(() => _hasNotificationPermission = hasNotificationPermission);
  }

  Future<void> requestNotificationPermission() async {
    await _simpleAndroidNotificationPlugin.requestNotificationPermission();
  }

  Future<void> show() async {
    await _simpleAndroidNotificationPlugin.show();
  }

  Future<void> requestNotificationListenerPermission() async {
    await _simpleAndroidNotificationPlugin
        .openNotificationListenerPermissionSettingScreen();
  }

  Future<void> getListenedNotificationsList() async {
    final List<dynamic> array =
        await _simpleAndroidNotificationPlugin.getListenedNotificationsList();
    setState(() => _listendArray = array);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: [
            Center(child: Text('Payload: $_payload')),
            const Center(
                child: Text(
              "if app was opened by tapping the notification",
              style: TextStyle(fontSize: 12, color: Colors.black45),
            )),
            Center(
              child: Text(
                  'hasNotificationPermission : $_hasNotificationPermission'),
            ),
            Center(
              child: Text(
                  'hasNotificationListenerPermission : $_hasNotificationListenerPermission'),
            ),
            ElevatedButton(
              onPressed: show,
              child: const Text('Show notification'),
            ),
            ElevatedButton(
              onPressed: hasNotificationPermission,
              child: const Text('Check hasNotificationPermission'),
            ),
            ElevatedButton(
              onPressed: requestNotificationPermission,
              child: const Text('request notification permission'),
            ),
            ElevatedButton(
              onPressed: requestNotificationListenerPermission,
              child: const Text('open listener permission setting screen'),
            ),
            ElevatedButton(
              onPressed: getListenedNotificationsList,
              child: const Text("get listened notifications"),
            ),
            for (var i = 0; i < _listendArray.length; i++)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Title: ${_listendArray[i]['title']}'),
                  Text('Text: ${_listendArray[i]['text']}'),
                  Text('BigText: ${_listendArray[i]['bigText']}'),
                  Text('InfoText: ${_listendArray[i]['infoText']}'),
                  Text('SubText: ${_listendArray[i]['subText']}'),
                  Text('SummaryText: ${_listendArray[i]['summaryText']}'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
