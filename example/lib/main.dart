// ignore: unused_import
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:simple_android_notification/models/notification_data.dart';
import 'dart:async';

import 'package:simple_android_notification/simple_android_notification.dart';
import 'package:simple_android_notification_example/channel_screen.dart';
import 'package:simple_android_notification_example/listener_screen.dart';
import 'package:simple_android_notification_example/widgets/input_box.dart';

final plugin = SimpleAndroidNotification();

void main() {
  runApp(const MaterialApp(
    title: "Simple Android Notification",
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _payload;
  bool _notificationPermission = false;
  bool _notificationListenerPermission = false;

  @override
  void initState() {
    super.initState();
    getPayload();
    hasNotificationPermission();
    hasListenerPermission();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          Center(child: Text('Payload: $_payload')),
          Center(
              child: Text(
            "If not null, App was opened by tapping the notifications",
            style: theme.textTheme.labelSmall,
          )),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Channel Features",
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChannelScreen(plugin: plugin)),
              );
            },
            child: const Text("Open Channel List Screen"),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Notification Features",
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          Center(
            child: Text('hasNotificationPermission : $_notificationPermission'),
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
            onPressed: () => showNotificationDialog(context),
            child: const Text('Show Notification'),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Notification Listener Features",
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          Center(
            child: Text(
                'hasListenerPermission : $_notificationListenerPermission'),
          ),
          ElevatedButton(
            onPressed: hasListenerPermission,
            child: const Text('Check Notification Listener Permission'),
          ),
          ElevatedButton(
            onPressed: openListenerPermissionSetting,
            child: const Text('Open Listener Permission Setting'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListenerScreen(plugin: plugin),
                ),
              );
            },
            child: const Text("Open Listener Screen"),
          ),
        ],
      ),
    );
  }

  Future<void> getPayload() async {
    var payload = await plugin.getPayload();
    setState(() => _payload = payload);
  }

  Future<void> hasNotificationPermission() async {
    bool permission = await plugin.hasNotificationPermission();
    setState(() => _notificationPermission = permission);
  }

  Future<void> requestNotificationPermission() async {
    await plugin.requestNotificationPermission();
  }

  void showNotificationDialog(BuildContext context) {
    final TextEditingController idController = TextEditingController();
    final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();
    final TextEditingController payloadController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  InputBox(
                    maxLength: 50,
                    controller: idController,
                    label: "Channel ID",
                  ),
                  InputBox(
                    maxLength: 30,
                    controller: titleController,
                    label: "Title",
                  ),
                  InputBox(
                    maxLength: 60,
                    controller: contentController,
                    label: "Content",
                  ),
                  InputBox(
                    maxLength: 30,
                    controller: payloadController,
                    action: TextInputAction.done,
                    label: "Payload",
                    activeValidator: false,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        var notificationData = NotificationData(
                            channelId: idController.text,
                            title: titleController.text,
                            content: contentController.text,
                            payload: payloadController.text);
                        showNotification(notificationData);
                      }
                    },
                    child: const Text("Send Notification"),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> showNotification(NotificationData notificationData) async {
    Navigator.of(context).pop();
    await plugin.showNotification(notificationData);
  }

  Future<void> hasListenerPermission() async {
    bool permission = await plugin.hasListenerPermission();
    setState(() => _notificationListenerPermission = permission);
  }

  Future<void> openListenerPermissionSetting() async {
    await plugin.openListenerPermissionSetting();
  }
}
