// ignore: unused_import
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:simple_android_notification/simple_android_notification.dart';

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
  List<dynamic> _listendArray = [];
  bool _notificationPermission = false;
  final bool _notificationListenerPermission = false;

  @override
  void initState() {
    super.initState();
    getPayload();
    hasNotificationPermission();
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
                    builder: (context) => const ChannelListScreen()),
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
                child: Column(
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

  Future<void> openNotificationListenerPermissionSetting() async {
    await simpleAndroidNotificationPlugin
        .openNotificationListenerPermissionSetting();
  }

  Future<void> getListenedNotificationsList() async {
    final List<dynamic> array =
        await simpleAndroidNotificationPlugin.getListenedNotificationsList();
    setState(() => _listendArray = array);
  }
}

class ChannelListScreen extends StatefulWidget {
  const ChannelListScreen({super.key});

  @override
  State<ChannelListScreen> createState() => _ChannelListScreenState();
}

class _ChannelListScreenState extends State<ChannelListScreen> {
  List<dynamic> list = [];
  @override
  void initState() {
    super.initState();
    getNotificationChannelList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Channels List"),
        actions: [
          IconButton(
            onPressed: () => showCreateChannelDialog(context),
            icon: const Icon(Icons.add_box_outlined),
          )
        ],
      ),
      body: ListView(children: [
        for (var i = 0; i < list.length; i++)
          ChannelBlock(
            item: list[i],
            getNotificationChannelList: getNotificationChannelList,
          )
      ]),
    );
  }

  Future<void> getNotificationChannelList() async {
    final List<dynamic> res =
        await simpleAndroidNotificationPlugin.getNotificationChannelList();
    setState(() => list = res);
  }

  void showCreateChannelDialog(BuildContext context) {
    final TextEditingController idController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    final TextEditingController importanceController = TextEditingController();
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
                      maxLength: 50,
                      controller: idController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'ID',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter ID';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      maxLength: 30,
                      controller: nameController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      maxLength: 300,
                      controller: descController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Description',
                      ),
                    ),
                    TextFormField(
                      maxLength: 1,
                      controller: importanceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Importance(0~4)',
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[01234]')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Importance Level';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          Navigator.pop(context);
                          bool res = await simpleAndroidNotificationPlugin
                              .createNotificationChannel(
                            idController.text,
                            nameController.text,
                            descController.text,
                            int.parse(importanceController.text),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(res ? 'Created!' : 'Failed!'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                          await getNotificationChannelList();
                        }
                      },
                      child: const Text("Create Channel"),
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

class ChannelBlock extends StatelessWidget {
  final dynamic item;
  final Future<void> Function() getNotificationChannelList;

  const ChannelBlock({
    super.key,
    required this.item,
    required this.getNotificationChannelList,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('id: ${item['id']}'),
              Text('name: ${item['name']}'),
              Text('description: ${item['description']}'),
              Text('importance: ${item['importance']}'),
            ],
          ),
          if (item['id'] != "default_channel")
            IconButton(
              onPressed: () async {
                bool res = await simpleAndroidNotificationPlugin
                    .removeNotificationChannel(item['id']);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(res ? 'Failed!' : 'Deleted!'),
                    duration: const Duration(seconds: 1),
                  ),
                );
                await getNotificationChannelList();
              },
              icon: const Icon(Icons.delete),
            ),
        ],
      ),
    );
  }
}
