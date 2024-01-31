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
  bool _hasNotificationPermission = false;
  final _simpleAndroidNotificationPlugin = SimpleAndroidNotification();

  @override
  void initState() {
    super.initState();
    getPayload();
  }

  Future<void> getPayload() async {
    String? payload = await _simpleAndroidNotificationPlugin.getPayload();
    setState(() => _payload = payload);
  }

  Future<void> hasNotificationPermission() async {
    bool hasNotificationPermission =
        await _simpleAndroidNotificationPlugin.checkPermission() ?? false;
    setState(() => _hasNotificationPermission = hasNotificationPermission);
  }

  Future<void> requestPermission() async {
    await _simpleAndroidNotificationPlugin.requestPermission();
  }

  Future<void> show() async {
    await _simpleAndroidNotificationPlugin.show();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView(
          children: [
            Center(
              child: Text('Running on: $_payload\n'),
            ),
            ElevatedButton(
              onPressed: show,
              child: const Text('Show notification'),
            ),
            Center(
              child: Text(
                  'hasNotificationPermission? : $_hasNotificationPermission'),
            ),
            ElevatedButton(
              onPressed: hasNotificationPermission,
              child: const Text('Check hasNotificationPermission'),
            ),
            ElevatedButton(
              onPressed: requestPermission,
              child: const Text('request permission'),
            ),
          ],
        ),
      ),
    );
  }
}
