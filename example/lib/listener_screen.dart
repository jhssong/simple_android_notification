import 'package:flutter/material.dart';

import 'package:simple_android_notification/simple_android_notification.dart';
import 'package:simple_android_notification_example/info_box.dart';

class ListenerScreen extends StatefulWidget {
  final SimpleAndroidNotification simpleAndroidNotificationPlugin;
  const ListenerScreen(
      {super.key, required this.simpleAndroidNotificationPlugin});

  @override
  State<ListenerScreen> createState() => _ListenerScreenState();
}

class _ListenerScreenState extends State<ListenerScreen> {
  List<dynamic> list = [];
  @override
  void initState() {
    super.initState();
    getListenedNotificationsList();
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
            icon: const Icon(Icons.filter_alt_outlined),
          ),
          IconButton(
            onPressed: resetListenedNotificationsList,
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
                      InfoBox(label: 'Id', value: list[i]['id']),
                      InfoBox(
                          label: 'PackageName', value: list[i]['packageName']),
                      InfoBox(label: 'Title', value: list[i]['title']),
                      InfoBox(label: 'Text', value: list[i]['text']),
                      InfoBox(label: 'BigText', value: list[i]['bigText']),
                      InfoBox(label: 'InfoText', value: list[i]['infoText']),
                      InfoBox(label: 'SubText', value: list[i]['subText']),
                      InfoBox(
                          label: 'SummaryText', value: list[i]['summaryText']),
                    ],
                  ),
                  IconButton(
                    onPressed: () =>
                        updateListenedNotificationsList(list[i]['id']),
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> getListenedNotificationsList() async {
    final List<dynamic> res = await widget.simpleAndroidNotificationPlugin
        .getListenedNotificationsList();
    setState(() => list = res);
  }

  Future<void> resetListenedNotificationsList() async {
    final List<dynamic> res = await widget.simpleAndroidNotificationPlugin
        .resetListenedNotificationsList();
    setState(() => list = res);
  }

  Future<void> updateListenedNotificationsList(String id) async {
    final List<dynamic> res = await widget.simpleAndroidNotificationPlugin
        .updateListenedNotificationsList(id);
    setState(() => list = res);
  }
}

class ListenerFilterScreen extends StatefulWidget {
  final SimpleAndroidNotification simpleAndroidNotificationPlugin;
  const ListenerFilterScreen(
      {super.key, required this.simpleAndroidNotificationPlugin});

  @override
  State<ListenerFilterScreen> createState() => _ListenerFilterScreenState();
}

class _ListenerFilterScreenState extends State<ListenerFilterScreen> {
  List<dynamic> list = [];
  @override
  void initState() {
    super.initState();
    getListenerFilter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Listener Filter List"),
        actions: [
          IconButton(
            onPressed: () => showCreateChannelDialog(context),
            icon: const Icon(Icons.add),
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
                      InfoBox(
                          label: 'PackageName', value: list[i]['packageName']),
                    ],
                  ),
                  IconButton(
                    onPressed: () =>
                        updateListenerFilter(list[i]['packageName']),
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> setListenerFilter(String packageName) async {
    final List<dynamic> res = await widget.simpleAndroidNotificationPlugin
        .setListenerFilter(packageName);
    setState(() => list = res);
  }

  Future<void> getListenerFilter() async {
    final List<dynamic> res =
        await widget.simpleAndroidNotificationPlugin.getListenerFilter();
    setState(() => list = res);
  }

  Future<void> updateListenerFilter(String packageName) async {
    final List<dynamic> res = await widget.simpleAndroidNotificationPlugin
        .updateListenerFilter(packageName);
    setState(() => list = res);
  }

  Future<void> resetListenerFilter() async {
    final List<dynamic> res =
        await widget.simpleAndroidNotificationPlugin.resetListenerFilter();
    setState(() => list = res);
  }

  void showCreateChannelDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      maxLength: 30,
                      controller: nameController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Package name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          Navigator.pop(context);
                          await widget.simpleAndroidNotificationPlugin
                              .setListenerFilter(
                            nameController.text,
                          );
                          await getListenerFilter();
                        }
                      },
                      child: const Text("Create Filter"),
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
}
