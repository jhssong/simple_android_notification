import 'dart:convert';

class ListenedData {
  String id;
  String packageName;
  String title;
  String text;
  String bigText;
  String infoText;
  String subText;
  String summaryText;

  ListenedData({
    required this.id,
    required this.packageName,
    required this.title,
    required this.text,
    required this.bigText,
    required this.infoText,
    required this.subText,
    required this.summaryText,
  });

  static List<ListenedData> toList(String? res) {
    List<dynamic> decodedList = json.decode(res ?? '[]');
    List<ListenedData> listenedNotificationDataList = decodedList.map((item) {
      return ListenedData(
        id: item['id'],
        packageName: item['packageName'],
        title: item['title'],
        text: item['text'],
        bigText: item['bigText'],
        infoText: item['infoText'],
        subText: item['subText'],
        summaryText: item['summaryText'],
      );
    }).toList();
    return listenedNotificationDataList;
  }
}
