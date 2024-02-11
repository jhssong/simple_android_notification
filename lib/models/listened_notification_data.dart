import 'dart:convert';

class ListenedNotificationData {
  String id;
  String packageName;
  String title;
  String text;
  String bigText;
  String infoText;
  String subText;
  String summaryText;

  ListenedNotificationData({
    required this.id,
    required this.packageName,
    required this.title,
    required this.text,
    required this.bigText,
    required this.infoText,
    required this.subText,
    required this.summaryText,
  });

  static List<ListenedNotificationData> parseJSONArrayToList(String? res) {
    List<dynamic> decodedList = json.decode(res ?? '[]');
    List<ListenedNotificationData> listenedNotificationDataList =
        decodedList.map((item) {
      return ListenedNotificationData(
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
