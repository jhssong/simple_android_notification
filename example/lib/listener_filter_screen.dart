import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:simple_android_notification/models/package_data.dart';

import 'package:simple_android_notification/simple_android_notification.dart';

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
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FilterSetting(package: list[i]),
                          ),
                        );
                      },
                      child: Text(
                        list[i].appName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 10,
                      ),
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

class FilterSetting extends StatefulWidget {
  final PackageData package;
  const FilterSetting({
    super.key,
    required this.package,
  });

  @override
  State<FilterSetting> createState() => _FilterSettingState();
}

class _FilterSettingState extends State<FilterSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.package.appName),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListView(
            children: const [
              Row(
                children: [
                  Text('Filter all notifications from this app'),
                  // Switch(
                  //   onChanged: (bool value) =>
                  //       handleFilterSwitch(list[i], value),
                  //   value: checkIsFiltered(list[i]),
                  // ),
                ],
              ),
            ],
          ),
        ));
  }
}
