import 'package:firebase_messaging/firebase_messaging.dart'
    show FirebaseMessaging, NotificationSettings, AuthorizationStatus;
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> setupFirebaseMessaging() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // 📢 Xin quyền (chủ yếu trên iOS / Web)
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('✅ Quyền thông báo được cấp');
  } else {
    print('🚫 Không có quyền gửi thông báo');
  }

  // 📱 Lấy token FCM (mỗi thiết bị 1 token duy nhất)
  String? token = await messaging.getToken();
  print('🔑 FCM Token: $token');

  // Lưu token lên Firestore nếu bạn muốn gửi targeted push sau này
}

Future<void> sendPushMessage(String token, String title, String body) async {
  const String serverKey =
      'AAAA...'; // 🔥 Server key lấy ở Firebase Console > Project Settings > Cloud Messaging > Server key
  await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    },
    body: jsonEncode(
      <String, dynamic>{
        'to': token,
        'notification': <String, dynamic>{
          'title': title,
          'body': body,
          'sound': 'default',
        },
        'priority': 'high',
      },
    ),
  );
}
