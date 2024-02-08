import 'package:flutter/material.dart';

import 'package:simple_android_notification/simple_android_notification.dart';
import 'package:simple_android_notification_example/widgets/info_box.dart';

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
            icon: const Icon(Icons.filter_alt_outlined),
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
                    onPressed: () => removeListenedNotifications(list[i]['id']),
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
    final List<dynamic> res =
        await widget.simpleAndroidNotificationPlugin.getListenedNotifications();
    setState(() => list = res);
  }

  Future<void> removeListenedNotifications(String id) async {
    final sm = ScaffoldMessenger.of(context);
    final res = await widget.simpleAndroidNotificationPlugin
        .removeListenedNotifications(id);
    sm.showSnackBar(
      SnackBar(content: Text(res), duration: const Duration(seconds: 2)),
    );
    await getListenedNotifications();
  }

  Future<void> resetListenedNotifications() async {
    final sm = ScaffoldMessenger.of(context);
    final res = await widget.simpleAndroidNotificationPlugin
        .resetListenedNotifications();
    sm.showSnackBar(
      SnackBar(content: Text(res), duration: const Duration(seconds: 2)),
    );
    await getListenedNotifications();
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
            onPressed: () => showAddListenerFilterDialog(context),
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: resetListenerFilter,
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
                      InfoBox(
                          label: 'PackageName', value: list[i]['packageName']),
                    ],
                  ),
                  IconButton(
                    onPressed: () =>
                        removeListenerFilter(list[i]['packageName']),
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void showAddListenerFilterDialog(BuildContext context) {
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
                              .addListenerFilter(
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

  Future<void> addListenerFilter(String packageName) async {
    final sm = ScaffoldMessenger.of(context);
    final res = await widget.simpleAndroidNotificationPlugin
        .addListenerFilter(packageName);
    sm.showSnackBar(
      SnackBar(content: Text(res), duration: const Duration(seconds: 2)),
    );
    await getListenerFilter();
  }

  Future<void> getListenerFilter() async {
    final List<dynamic> res =
        await widget.simpleAndroidNotificationPlugin.getListenerFilter();
    setState(() => list = res);
  }

  Future<void> removeListenerFilter(String packageName) async {
    final sm = ScaffoldMessenger.of(context);
    final res = await widget.simpleAndroidNotificationPlugin
        .removeListenerFilter(packageName);
    sm.showSnackBar(
      SnackBar(content: Text(res), duration: const Duration(seconds: 2)),
    );
    await getListenerFilter();
  }

  Future<void> resetListenerFilter() async {
    final sm = ScaffoldMessenger.of(context);
    final res =
        await widget.simpleAndroidNotificationPlugin.resetListenerFilter();
    sm.showSnackBar(
      SnackBar(content: Text(res), duration: const Duration(seconds: 2)),
    );
    await getListenerFilter();
  }
}
