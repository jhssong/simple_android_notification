import 'dart:convert';

class ChannelData {
  String id;
  String name;
  String desc;
  int imp;

  ChannelData({
    required this.id,
    required this.name,
    required this.desc,
    required this.imp,
  });

  static Map<String, dynamic> toMap(ChannelData data) {
    return {
      'id': data.id,
      'name': data.name,
      'desc': data.desc,
      'imp': data.imp,
    };
  }

  static List<ChannelData> toList(String? res) {
    List<dynamic> decodedList = json.decode(res ?? '[]');
    List<ChannelData> channelDataList = decodedList.map((item) {
      return ChannelData(
        id: item['id'],
        name: item['name'],
        desc: item['desc'],
        imp: item['imp'],
      );
    }).toList();
    return channelDataList;
  }
}
