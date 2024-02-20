import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_android_notification/models/filter_data.dart';
import 'package:simple_android_notification/models/package_data.dart';

import 'package:simple_android_notification/simple_android_notification.dart';
import 'package:simple_android_notification_example/main.dart';
import 'package:simple_android_notification_example/widgets/info_box.dart';
import 'package:simple_android_notification_example/widgets/input_box.dart';

enum ViewList { all, filteredOnly, systemApp, searched }

class ListenerFilterScreen extends StatefulWidget {
  final SimpleAndroidNotification plugin;
  const ListenerFilterScreen({super.key, required this.plugin});

  @override
  State<ListenerFilterScreen> createState() => _ListenerFilterScreenState();
}

class _ListenerFilterScreenState extends State<ListenerFilterScreen> {
  ViewList viewList = ViewList.all;
  List<PackageData> searchedList = [];
  Map<String, List<FilterData>> filterData = {};
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
    switch (viewList) {
      case ViewList.all:
        setState(() {
          list = listAll.where((appInfo) => !appInfo.isSystemApp).toList();
        });
        break;
      case ViewList.filteredOnly:
        setState(() => list = getFilteredList());
        break;
      case ViewList.systemApp:
        setState(() {
          list = listAll.where((appInfo) => appInfo.isSystemApp).toList();
        });
        break;
      case ViewList.searched:
        setState(() => list = searchedList);
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Listener Filter List"),
        actions: [
          IconButton(
              onPressed: () async {
                await widget.plugin.resetListenerFilter();
                await getListenerFilter();
              },
              icon: const Icon(Icons.delete_outline))
        ],
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
                        onPressed: () {
                          setState(() => viewList = ViewList.all);
                        },
                        child: const Text('Apps'),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextButton(
                        onPressed: () {
                          setState(() => viewList = ViewList.filteredOnly);
                        },
                        child: const Text('Activated'),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextButton(
                        onPressed: () {
                          setState(() => viewList = ViewList.systemApp);
                        },
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
                            builder: (context) => FilterSetting(
                              package: list[i],
                              addListenerFilter: addListenerFilter,
                              removeListenerFilter: removeListenerFilter,
                              updateFilterData: updateFilterData,
                            ),
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

  Future<void> addListenerFilter(FilterData data) async {
    await plugin.addListenerFilter(data);
    await getListenerFilter();
  }

  Future<void> getListenerFilter() async {
    final Map<String, List<FilterData>> res =
        await widget.plugin.getListenerFilter();
    setState(() => filterData = res);
  }

  List<PackageData> getFilteredList() {
    List<String> filteredApp = [];
    for (var key in filterData.keys.toList()) {
      if (filterData[key]!.isNotEmpty) {
        filteredApp.add(key);
      }
    }
    List<PackageData> filteredList = listAll
        .where((item) => filteredApp.contains(item.packageName))
        .toList();
    return filteredList;
  }

  Future<void> removeListenerFilter(FilterData data) async {
    await plugin.removeListenerFilter(data);
    await getListenerFilter();
  }

  Future<void> getPackageList() async {
    final res = await widget.plugin.getPackageList();
    setState(() => listAll = res);
  }

  void filterSearchResults(String value) {
    List<PackageData> newSearchedList = [];
    if (value.isNotEmpty) {
      for (var item in listAll) {
        if (item.packageName.toLowerCase().contains(value.toLowerCase())) {
          newSearchedList.add(item);
        } else if (item.appName.toLowerCase().contains(value.toLowerCase())) {
          newSearchedList.add(item);
        }
      }
    } else {
      newSearchedList = listAll;
    }
    setState(() => searchedList = newSearchedList);
    setState(() => viewList = ViewList.searched);
  }

  List<FilterData> updateFilterData(String packageName) {
    return filterData[packageName] ?? [];
  }
}

class FilterSetting extends StatefulWidget {
  final PackageData package;
  final Future<void> Function(FilterData) addListenerFilter;
  final Future<void> Function(FilterData) removeListenerFilter;
  final List<FilterData> Function(String) updateFilterData;

  const FilterSetting({
    super.key,
    required this.package,
    required this.addListenerFilter,
    required this.removeListenerFilter,
    required this.updateFilterData,
  });

  @override
  State<FilterSetting> createState() => _FilterSettingState();
}

class _FilterSettingState extends State<FilterSetting> {
  List<FilterData> filterData = [];
  bool isOption0 = false;

  @override
  void initState() {
    super.initState();
    handleStateUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.package.appName),
        actions: [
          IconButton(
            onPressed: () {
              createFilterDialog(context, widget.package.packageName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          children: [
            Row(
              children: [
                const Text('Filter all notifications from this app'),
                Switch(value: isOption0, onChanged: (v) => handleOption0(v)),
              ],
            ),
            Expanded(
              child: ListView(
                children: [
                  for (var item in filterData)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            InfoBox(label: "ID", value: item.id),
                            InfoBox(
                                label: "PackageName", value: item.packageName),
                            InfoBox(
                                label: "Option", value: item.option.toString()),
                            if (item.title != "")
                              InfoBox(label: "Title", value: item.title!),
                            if (item.text != "")
                              InfoBox(label: "Text", value: item.text!),
                            if (item.bigText != "")
                              InfoBox(label: "BigText", value: item.bigText!),
                            if (item.infoText != "")
                              InfoBox(label: "InfoText", value: item.infoText!),
                            if (item.subText != "")
                              InfoBox(label: "SubText", value: item.subText!),
                            if (item.summaryText != "")
                              InfoBox(
                                label: "SummaryText",
                                value: item.summaryText!,
                              ),
                          ],
                        ),
                        IconButton(
                          onPressed: () async {
                            await widget.removeListenerFilter(item);
                            handleStateUpdate();
                          },
                          icon: const Icon(Icons.delete_outline),
                        )
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void createFilterDialog(BuildContext context, String packageName) {
    final TextEditingController optionController = TextEditingController();
    final TextEditingController titleController = TextEditingController();
    final TextEditingController textController = TextEditingController();
    final TextEditingController bigTextController = TextEditingController();
    final TextEditingController infoTextController = TextEditingController();
    final TextEditingController subTextontroller = TextEditingController();
    final TextEditingController summaryTextController = TextEditingController();
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
                    maxLength: 1,
                    controller: optionController,
                    action: TextInputAction.done,
                    label: "Option(1: and, 2: or)",
                    validatorLabel: "option",
                    inputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp('[12]'))
                    ],
                  ),
                  InputBox(
                    maxLength: 50,
                    controller: titleController,
                    label: "Title",
                    activeValidator: false,
                  ),
                  InputBox(
                    maxLength: 50,
                    controller: textController,
                    label: "Text",
                    activeValidator: false,
                  ),
                  InputBox(
                    maxLength: 50,
                    controller: bigTextController,
                    label: "BigText",
                    activeValidator: false,
                  ),
                  InputBox(
                    maxLength: 50,
                    controller: infoTextController,
                    label: "InfoText",
                    activeValidator: false,
                  ),
                  InputBox(
                    maxLength: 50,
                    controller: subTextontroller,
                    label: "SubText",
                    activeValidator: false,
                  ),
                  InputBox(
                    maxLength: 50,
                    controller: summaryTextController,
                    action: TextInputAction.done,
                    label: "SummaryText",
                    activeValidator: false,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        var data = FilterData(
                          id: DateTime.now().microsecondsSinceEpoch.toString(),
                          option: int.parse(optionController.text),
                          packageName: packageName,
                          title: titleController.text,
                          text: textController.text,
                          bigText: bigTextController.text,
                          infoText: infoTextController.text,
                          subText: subTextontroller.text,
                          summaryText: summaryTextController.text,
                        );
                        Navigator.pop(context);
                        await widget.addListenerFilter(data);
                        handleStateUpdate();
                      }
                    },
                    child: const Text("Create Filter"),
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

  void handleOption0(bool value) async {
    if (value) {
      await widget.addListenerFilter(FilterData(
        id: "option0",
        option: 0,
        packageName: widget.package.packageName,
      ));
    } else {
      await widget.removeListenerFilter(FilterData(
        id: "option0",
        option: 0,
        packageName: widget.package.packageName,
      ));
    }
    handleStateUpdate();
  }

  void handleStateUpdate() {
    String packageName = widget.package.packageName;
    List<FilterData> newFilterData = widget.updateFilterData(packageName);

    setState(() {
      filterData = newFilterData;
      isOption0 = newFilterData.any((item) => item.option == 0);
    });
  }
}
