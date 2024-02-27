class NotificationData {
  String channelId;
  String title;
  String text;
  String payload;

  NotificationData({
    required this.channelId,
    required this.title,
    required this.text,
    required this.payload,
  });

  static Map<String, dynamic> toJson(NotificationData data) {
    return {
      'channelId': data.channelId,
      'title': data.title,
      'text': data.text,
      'payload': data.payload,
    };
  }
}
