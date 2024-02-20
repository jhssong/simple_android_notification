import 'package:flutter/material.dart';
import 'package:simple_android_notification/models/listened_data.dart';

import 'package:simple_android_notification/simple_android_notification.dart';
import 'package:simple_android_notification_example/listener_filter_screen.dart';
import 'package:simple_android_notification_example/widgets/info_box.dart';

class ListenerScreen extends StatefulWidget {
  final SimpleAndroidNotification plugin;
  const ListenerScreen({super.key, required this.plugin});

  @override
  State<ListenerScreen> createState() => _ListenerScreenState();
}

class _ListenerScreenState extends State<ListenerScreen> {
  List<ListenedData> list = [];
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
                          plugin: widget.plugin,
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
    final List<ListenedData> res =
        await widget.plugin.getListenedNotifications();
    setState(() => list = res);
  }

  Future<void> removeListenedNotifications(ListenedData data) async {
    await widget.plugin.removeListenedNotifications(data);
    await getListenedNotifications();
  }

  Future<void> resetListenedNotifications() async {
    await widget.plugin.resetListenedNotifications();
    await getListenedNotifications();
  }
}
