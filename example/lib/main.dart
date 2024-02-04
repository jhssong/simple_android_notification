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
  bool _notificationPermission = false;
  final bool _notificationListenerPermission = false;
  final _simpleAndroidNotificationPlugin = SimpleAndroidNotification();

  @override
  void initState() async {
    super.initState();
    var payload = await _simpleAndroidNotificationPlugin.getPayload();
    setState(() => _payload = payload);

    hasNotificationPermission();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: [
            Center(child: Text('Payload: $_payload')),
            Center(
                child: Text(
              "If not null, app was opened by tapping the notification",
              style: theme.textTheme.labelSmall,
            )),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Channel Features",
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),
            const Center(
              child: Text('DefaultNotifcationChannelEnabled : false'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Check Channel Enabled"),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Create Channel"),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Delete Channel"),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Get Channel List"),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Notification Features",
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child:
                  Text('hasNotificationPermission : $_notificationPermission'),
            ),
            ElevatedButton(
              onPressed: hasNotificationPermission,
              child: const Text('Check Notification Permission'),
            ),
            ElevatedButton(
              onPressed: requestNotificationPermission,
              child: const Text('Request Notification Permission'),
            ),
            ElevatedButton(
              onPressed: showNotification,
              child: const Text('Show Notification'),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Notification Listener Features",
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: Text(
                  'hasNotificationListenerPermission : $_notificationListenerPermission'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Check Notification Listener Permission'),
            ),
            ElevatedButton(
              onPressed: openNotificationListenerPermissionSetting,
              child: const Text('Open Listener Permission Setting'),
            ),
            ElevatedButton(
              onPressed: getListenedNotificationsList,
              child: const Text("Get Listened Notifications"),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Update Listened Notifications"),
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

  Future<void> hasNotificationPermission() async {
    bool permission =
        await _simpleAndroidNotificationPlugin.hasNotificationPermission();
    setState(() => _notificationPermission = permission);
  }

  Future<void> requestNotificationPermission() async {
    bool permission =
        await _simpleAndroidNotificationPlugin.requestNotificationPermission();
    setState(() => _notificationPermission = permission);
  }

  Future<void> showNotification() async {
    await _simpleAndroidNotificationPlugin.showNotification();
  }

  Future<void> openNotificationListenerPermissionSetting() async {
    await _simpleAndroidNotificationPlugin
        .openNotificationListenerPermissionSetting();
  }

  Future<void> getListenedNotificationsList() async {
    final List<dynamic> array =
        await _simpleAndroidNotificationPlugin.getListenedNotificationsList();
    setState(() => _listendArray = array);
  }
}
