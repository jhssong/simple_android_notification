// ignore: unused_import
import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:simple_android_notification/simple_android_notification.dart';
import 'package:simple_android_notification_example/channel_screen.dart';
import 'package:simple_android_notification_example/listener_screen.dart';

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
            onPressed: () => showNotification(context),
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
            child: const Text("Open Listend Notification List Screen"),
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
    bool permission =
        await simpleAndroidNotificationPlugin.requestNotificationPermission();
    setState(() => _notificationPermission = permission);
  }

  void showNotification(BuildContext context) {
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
                    TextFormField(
                      maxLength: 50,
                      controller: idController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Channel ID',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Channel ID';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      maxLength: 30,
                      controller: titleController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Title',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Title';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      maxLength: 60,
                      controller: contentController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Content',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Content';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      maxLength: 30,
                      controller: payloadController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Payload',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Payload';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          bool res = await simpleAndroidNotificationPlugin
                              .showNotification(
                            idController.text,
                            titleController.text,
                            contentController.text,
                            payloadController.text,
                          );
                          if (res) {
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Failed!'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text("Send Notification"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
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
}
