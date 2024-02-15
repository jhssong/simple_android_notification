import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_android_notification/models/channel_data.dart';

import 'package:simple_android_notification/simple_android_notification.dart';
import 'package:simple_android_notification_example/widgets/info_box.dart';
import 'package:simple_android_notification_example/widgets/input_box.dart';

class ChannelScreen extends StatefulWidget {
  final SimpleAndroidNotification plugin;
  const ChannelScreen({super.key, required this.plugin});

  @override
  State<ChannelScreen> createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen> {
  List<ChannelData> list = [];

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
            onPressed: () => createChannelDialog(context),
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
                      InfoBox(label: 'Id', value: list[i].id),
                      InfoBox(label: 'Name', value: list[i].name),
                      InfoBox(label: 'Description', value: list[i].desc),
                      InfoBox(
                        label: 'Importance',
                        value: list[i].imp.toString(),
                      ),
                    ],
                  ),
                  if (list[i].id != "default_channel")
                    IconButton(
                      onPressed: () => removeNotificationChannel(list[i]),
                      icon: const Icon(Icons.delete),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void createChannelDialog(BuildContext context) {
    final TextEditingController idController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    final TextEditingController impController = TextEditingController();
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
                    controller: impController,
                    action: TextInputAction.done,
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
                        var channelData = ChannelData(
                          id: idController.text,
                          name: nameController.text,
                          desc: descController.text,
                          imp: int.parse(impController.text),
                        );
                        createNotificationChannel(channelData);
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

  Future<void> createNotificationChannel(ChannelData data) async {
    Navigator.pop(context);
    await widget.plugin.createNotificationChannel(data);
    await getNotificationChannelList();
  }

  Future<void> getNotificationChannelList() async {
    final List<ChannelData> res =
        await widget.plugin.getNotificationChannelList();
    setState(() => list = res);
  }

  Future<void> removeNotificationChannel(ChannelData data) async {
    await widget.plugin.removeNotificationChannel(data);
    await getNotificationChannelList();
  }
}
