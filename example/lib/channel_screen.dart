import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:simple_android_notification/simple_android_notification.dart';
import 'package:simple_android_notification_example/widgets/info_box.dart';
import 'package:simple_android_notification_example/widgets/input_box.dart';

class ChannelScreen extends StatefulWidget {
  final SimpleAndroidNotification simpleAndroidNotificationPlugin;
  const ChannelScreen(
      {super.key, required this.simpleAndroidNotificationPlugin});

  @override
  State<ChannelScreen> createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen> {
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
            icon: const Icon(Icons.add),
          )
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
                      InfoBox(label: 'Name', value: list[i]['name']),
                      InfoBox(
                          label: 'Description', value: list[i]['description']),
                      InfoBox(
                          label: 'Importance',
                          value: list[i]['importance'].toString()),
                    ],
                  ),
                  if (list[i]['id'] != "default_channel")
                    IconButton(
                      onPressed: () =>
                          handleDeleteChannel(context, list[i]['id']),
                      icon: const Icon(Icons.delete),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
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
                  InputBox(
                      maxLength: 50, controller: idController, label: "ID"),
                  InputBox(
                      maxLength: 30, controller: nameController, label: "Name"),
                  InputBox(
                    maxLength: 300,
                    controller: descController,
                    label: "Description",
                  ),
                  InputBox(
                    maxLength: 1,
                    controller: importanceController,
                    action: TextInputAction.next,
                    label: "Importance(0~4)",
                    validatorLabel: "importance level",
                    inputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp('[01234]'))
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        handleCreateChannel(
                          idController.text,
                          nameController.text,
                          descController.text,
                          int.parse(importanceController.text),
                        );
                      }
                    },
                    child: const Text("Create Channel"),
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

  Future<void> getNotificationChannelList() async {
    final List<dynamic> res = await widget.simpleAndroidNotificationPlugin
        .getNotificationChannelList();
    setState(() => list = res);
  }

  Future<void> handleDeleteChannel(BuildContext context, String id) async {
    var sm = ScaffoldMessenger.of(context);
    String res = await widget.simpleAndroidNotificationPlugin
        .removeNotificationChannel(id);
    sm.showSnackBar(
        SnackBar(content: Text(res), duration: const Duration(seconds: 2)));
    await getNotificationChannelList();
  }

  Future<void> handleCreateChannel(
      String id, String name, String desc, int importance) async {
    Navigator.pop(context);
    var sm = ScaffoldMessenger.of(context);
    String res = await widget.simpleAndroidNotificationPlugin
        .createNotificationChannel(id, name, desc, importance);
    sm.showSnackBar(
      SnackBar(content: Text(res), duration: const Duration(seconds: 2)),
    );
    await getNotificationChannelList();
  }
}
