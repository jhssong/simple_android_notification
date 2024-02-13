import 'package:flutter/material.dart';
import 'package:simple_android_notification/models/listened_notification_data.dart';

import 'package:simple_android_notification/simple_android_notification.dart';
import 'package:simple_android_notification_example/listener_filter_screen.dart';
import 'package:simple_android_notification_example/widgets/info_box.dart';

class ListenerScreen extends StatefulWidget {
  final SimpleAndroidNotification simpleAndroidNotificationPlugin;
  const ListenerScreen(
      {super.key, required this.simpleAndroidNotificationPlugin});

  @override
  State<ListenerScreen> createState() => _ListenerScreenState();
}

class _ListenerScreenState extends State<ListenerScreen> {
  List<ListenedNotificationData> list = [];
  @override
  void initState() {
    super.initState();
    getListenedNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Listened List"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ListenerFilterScreen(
                          simpleAndroidNotificationPlugin:
                              widget.simpleAndroidNotificationPlugin,
                        )),
              );
            },
            icon: const Icon(Icons.filter_list),
          ),
          IconButton(
            onPressed: resetListenedNotifications,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: ListView(
        children: [
          for (var i = 0; i < list.length; i++)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InfoBox(label: 'Id', value: list[i].id),
                      InfoBox(label: 'PackageName', value: list[i].packageName),
                      InfoBox(label: 'Title', value: list[i].title),
                      InfoBox(label: 'Text', value: list[i].text),
                      InfoBox(label: 'BigText', value: list[i].bigText),
                      InfoBox(label: 'InfoText', value: list[i].infoText),
                      InfoBox(label: 'SubText', value: list[i].subText),
                      InfoBox(label: 'SummaryText', value: list[i].summaryText),
                    ],
                  ),
                  IconButton(
                    onPressed: () => removeListenedNotifications(list[i]),
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> getListenedNotifications() async {
    final List<ListenedNotificationData> res =
        await widget.simpleAndroidNotificationPlugin.getListenedNotifications();
    setState(() => list = res);
  }

  Future<void> removeListenedNotifications(
      ListenedNotificationData listenedNotificationData) async {
    final sm = ScaffoldMessenger.of(context);
    final res = await widget.simpleAndroidNotificationPlugin
        .removeListenedNotifications(listenedNotificationData);
    sm.showSnackBar(
      SnackBar(content: Text(res), duration: const Duration(seconds: 1)),
    );
    await getListenedNotifications();
  }

  Future<void> resetListenedNotifications() async {
    final sm = ScaffoldMessenger.of(context);
    final res = await widget.simpleAndroidNotificationPlugin
        .resetListenedNotifications();
    sm.showSnackBar(
      SnackBar(content: Text(res), duration: const Duration(seconds: 1)),
    );
    await getListenedNotifications();
  }
}
