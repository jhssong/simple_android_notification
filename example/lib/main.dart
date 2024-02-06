// ignore: unused_import
import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:simple_android_notification/simple_android_notification.dart';
import 'package:simple_android_notification_example/channel_screen.dart';
import 'package:simple_android_notification_example/listener_screen.dart';
import 'package:simple_android_notification_example/widgets/input_box.dart';

final simpleAndroidNotificationPlugin = SimpleAndroidNotification();

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
    hasNotificationListenerPermission();
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
            "If not null, app was opened by tapping the notification",
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
                    builder: (context) => ChannelScreen(
                          simpleAndroidNotificationPlugin:
                              simpleAndroidNotificationPlugin,
                        )),
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
                'hasNotificationListenerPermission : $_notificationListenerPermission'),
          ),
          ElevatedButton(
            onPressed: hasNotificationListenerPermission,
            child: const Text('Check Notification Listener Permission'),
          ),
          ElevatedButton(
            onPressed: openNotificationListenerPermissionSetting,
            child: const Text('Open Listener Permission Setting'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ListenerScreen(
                          simpleAndroidNotificationPlugin:
                              simpleAndroidNotificationPlugin,
                        )),
              );
            },
            child: const Text("Open Listener Screen"),
          ),
        ],
      ),
    );
  }

  Future<void> getPayload() async {
    var payload = await simpleAndroidNotificationPlugin.getPayload();
    setState(() => _payload = payload);
  }

  Future<void> hasNotificationPermission() async {
    bool permission =
        await simpleAndroidNotificationPlugin.hasNotificationPermission();
    setState(() => _notificationPermission = permission);
  }

  Future<void> requestNotificationPermission() async {
    await simpleAndroidNotificationPlugin.requestNotificationPermission();
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
                    label: "Payload",
                    activeValidator: false,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        handleShowNotification(
                          idController.text,
                          titleController.text,
                          contentController.text,
                          payloadController.text,
                        );
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

  Future<void> hasNotificationListenerPermission() async {
    bool permission = await simpleAndroidNotificationPlugin
        .hasNotificationListenerPermission();
    setState(() => _notificationListenerPermission = permission);
  }

  Future<void> openNotificationListenerPermissionSetting() async {
    bool permission = await simpleAndroidNotificationPlugin
        .openNotificationListenerPermissionSetting();
    setState(() => _notificationListenerPermission = permission);
  }

  Future<void> handleShowNotification(
      String id, String title, String content, String payload) async {
    var navigator = Navigator.of(context);
    var sm = ScaffoldMessenger.of(context);
    String res = await simpleAndroidNotificationPlugin.showNotification(
        id, title, content, payload);
    if (res == "Send") {
      navigator.pop();
    }
    sm.showSnackBar(
      SnackBar(content: Text(res), duration: const Duration(seconds: 1)),
    );
  }
}
