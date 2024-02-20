import 'dart:convert';

class PackageData {
  String packageName;
  String appName;
  bool isSystemApp;

  PackageData({
    required this.packageName,
    required this.appName,
    required this.isSystemApp,
  });

  static List<PackageData> toList(String? res) {
    List<dynamic> decodedList = json.decode(res ?? '[]');
    List<PackageData> packageDataList = decodedList.map((item) {
      return PackageData(
        packageName: item['packageName'],
        appName: item['appName'],
        isSystemApp: item['isSystemApp'],
      );
    }).toList();
    return packageDataList;
  }
}
