import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  Future<void> messageHandler(RemoteMessage message) async {
    print('background message ${message.notification.body}');
  }
}
