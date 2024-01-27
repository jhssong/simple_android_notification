import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
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
  String _platformVersion = 'Unknown';
  String _hasNotificationPermission = 'false';
  final _simpleAndroidNotificationPlugin = SimpleAndroidNotification();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _simpleAndroidNotificationPlugin.getPlatformVersion();
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> hasNotificationPermission() async {
    String hasNotificationPermission;
    hasNotificationPermission =
        await _simpleAndroidNotificationPlugin.checkPermission();

    setState(() {
      _hasNotificationPermission = hasNotificationPermission;
    });
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
              child: Text('Running on: $_platformVersion\n'),
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
