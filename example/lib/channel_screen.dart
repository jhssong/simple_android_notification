import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:simple_android_notification/simple_android_notification.dart';
import 'package:simple_android_notification_example/info_box.dart';

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

  Future<void> getNotificationChannelList() async {
    final List<dynamic> res = await widget.simpleAndroidNotificationPlugin
        .getNotificationChannelList();
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
                          bool res = await widget
                              .simpleAndroidNotificationPlugin
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

  Future<void> handleDeleteChannel(BuildContext context, String id) async {
    bool res = await widget.simpleAndroidNotificationPlugin
        .removeNotificationChannel(id);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(res ? 'Failed!' : 'Deleted!'),
      duration: const Duration(seconds: 1),
    ));
    await getNotificationChannelList();
  }
}
