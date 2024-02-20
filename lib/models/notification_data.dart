class NotificationData {
  String channelId;
  String title;
  String content;
  String payload;

  NotificationData({
    required this.channelId,
    required this.title,
    required this.content,
    required this.payload,
  });

  static Map<String, dynamic> toJson(NotificationData data) {
    return {
      'channelId': data.channelId,
      'title': data.title,
      'content': data.content,
      'payload': data.payload,
    };
  }
}
