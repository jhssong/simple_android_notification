import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:simple_android_notification/models/package_data.dart';

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

class ListenerFilterScreen extends StatefulWidget {
  final SimpleAndroidNotification simpleAndroidNotificationPlugin;
  const ListenerFilterScreen(
      {super.key, required this.simpleAndroidNotificationPlugin});

  @override
  State<ListenerFilterScreen> createState() => _ListenerFilterScreenState();
}

class _ListenerFilterScreenState extends State<ListenerFilterScreen> {
  List<dynamic> filteredApp = [];
  List<PackageData> listAll = [];
  List<PackageData> list = [];
  bool showSystemApp = false;

  @override
  void initState() {
    super.initState();
    getListenerFilter();
    getPackageList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Listener Filter List"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) => filterSearchResults(value),
                  decoration: const InputDecoration(
                    labelText: 'Search',
                    prefixIcon: Icon(Icons.search),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Text('Filter'),
                    Expanded(
                      flex: 1,
                      child: TextButton(
                        onPressed: getPackageList,
                        child: const Text('All'),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextButton(
                        onPressed: filterActivated,
                        child: const Text('Activated'),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextButton(
                        onPressed: filterSystemApps,
                        child: const Text('System apps'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                for (var i = 0; i < list.length; i++)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Text(
                            list[i].appName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 10,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Switch(
                            onChanged: (bool value) =>
                                handleFilterSwitch(list[i], value),
                            value: checkIsFiltered(list[i]),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> addListenerFilter(String packageName) async {
    final sm = ScaffoldMessenger.of(context);
    final res = await widget.simpleAndroidNotificationPlugin
        .addListenerFilter(packageName);
    sm.showSnackBar(
      SnackBar(content: Text(res), duration: const Duration(seconds: 1)),
    );
    await getListenerFilter();
  }

  Future<void> getListenerFilter() async {
    final List<dynamic> res =
        await widget.simpleAndroidNotificationPlugin.getListenerFilter();
    setState(() => filteredApp = res);
  }

  Future<void> removeListenerFilter(String packageName) async {
    final sm = ScaffoldMessenger.of(context);
    final res = await widget.simpleAndroidNotificationPlugin
        .removeListenerFilter(packageName);
    sm.showSnackBar(
      SnackBar(content: Text(res), duration: const Duration(seconds: 1)),
    );
    await getListenerFilter();
  }

  Future<void> resetListenerFilter() async {
    final sm = ScaffoldMessenger.of(context);
    final res =
        await widget.simpleAndroidNotificationPlugin.resetListenerFilter();
    sm.showSnackBar(
      SnackBar(content: Text(res), duration: const Duration(seconds: 1)),
    );
    await getListenerFilter();
  }

  Future<void> getPackageList() async {
    final res = await widget.simpleAndroidNotificationPlugin.getPackageList();
    setState(() => listAll = res);
    setState(() => list = res);
  }

  void filterActivated() {
    List<PackageData> filteredList = [];
    for (var appInfo in listAll) {
      if (checkIsFiltered(appInfo)) {
        filteredList.add(appInfo);
      }
    }
    setState(() => list = filteredList);
  }

  void filterSystemApps() {
    List<PackageData> filteredList = [];
    for (var appInfo in listAll) {
      if (appInfo.isSystemApp) {
        filteredList.add(appInfo);
      }
    }
    setState(() => list = filteredList);
  }

  void filterSearchResults(String value) {
    List<PackageData> searchedList = [];
    if (value.isNotEmpty) {
      log(value);
      for (var item in listAll) {
        if (item.packageName.toLowerCase().contains(value.toLowerCase())) {
          searchedList.add(item);
        } else if (item.appName.toLowerCase().contains(value.toLowerCase())) {
          searchedList.add(item);
        }
      }
    } else {
      searchedList = listAll;
    }
    setState(() => list = searchedList);
  }

  void handleFilterSwitch(PackageData appInfo, bool value) {
    if (value == true) {
      addListenerFilter(appInfo.packageName);
    } else {
      removeListenerFilter(appInfo.packageName);
    }
  }

  bool checkIsFiltered(PackageData appInfo) {
    for (var item in filteredApp) {
      if (item.containsValue(appInfo.packageName)) {
        return true;
      }
    }
    return false;
  }
}
