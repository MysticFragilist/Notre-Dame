import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static Future<void> initialize() async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.subscribeToTopic('global');

    FirebaseMessaging.onBackgroundMessage(NotificationService.messageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
  }

  static Future<void> messageHandler(RemoteMessage message) async {
    print('background message ${message.notification.body}');
  }
}
