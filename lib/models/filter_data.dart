import 'dart:convert';

class FilterData {
  String id;
  int option; // 0: all, 1: and, 2: or
  String packageName;
  String? title;
  String? text;
  String? bigText;
  String? infoText;
  String? subText;
  String? summaryText;

  FilterData({
    required this.id,
    required this.option,
    required this.packageName,
    this.title,
    this.text,
    this.bigText,
    this.infoText,
    this.subText,
    this.summaryText,
  });

  static FilterData fromJson(Map<String, dynamic> data) {
    return FilterData(
      id: data['id'],
      option: data['option'],
      packageName: data['packageName'],
      title: data['title'],
      text: data['text'],
      bigText: data['bigText'],
      infoText: data['infoText'],
      subText: data['subText'],
      summaryText: data['summaryText'],
    );
  }

  static Map<String, List<FilterData>> toMapData(String? res) {
    Map<String, dynamic> decodedMap = json.decode(res ?? '');
    Map<String, List<FilterData>> resultMap = {};

    decodedMap.forEach((key, value) {
      List<FilterData> dataList = [];
      for (var item in value) {
        dataList.add(FilterData.fromJson(item));
      }
      resultMap[key] = dataList;
    });

    return resultMap;
  }

  static Map<String, dynamic> toJson(FilterData data) {
    return {
      'id': data.id,
      'option': data.option,
      'packageName': data.packageName,
      'title': data.title ?? "",
      'text': data.text ?? "",
      'bigText': data.bigText ?? "",
      'infoText': data.infoText ?? "",
      'subText': data.subText ?? "",
      'summaryText': data.summaryText ?? "",
    };
  }
}
