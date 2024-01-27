// import 'package:flutter_test/flutter_test.dart';
// import 'package:simple_android_notification/simple_android_notification.dart';
// import 'package:simple_android_notification/simple_android_notification_platform_interface.dart';
// import 'package:simple_android_notification/simple_android_notification_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockSimpleAndroidNotificationPlatform
//     with MockPlatformInterfaceMixin
//     implements SimpleAndroidNotificationPlatform {

//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final SimpleAndroidNotificationPlatform initialPlatform = SimpleAndroidNotificationPlatform.instance;

//   test('$MethodChannelSimpleAndroidNotification is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelSimpleAndroidNotification>());
//   });

//   test('getPlatformVersion', () async {
//     SimpleAndroidNotification simpleAndroidNotificationPlugin = SimpleAndroidNotification();
//     MockSimpleAndroidNotificationPlatform fakePlatform = MockSimpleAndroidNotificationPlatform();
//     SimpleAndroidNotificationPlatform.instance = fakePlatform;

//     expect(await simpleAndroidNotificationPlugin.getPlatformVersion(), '42');
//   });
// }
