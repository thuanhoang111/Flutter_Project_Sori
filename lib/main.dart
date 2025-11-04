import 'package:flutter/material.dart';
import 'package:Flutter_Project_Sori/screens/main_screen.dart';
import 'package:Flutter_Project_Sori/util/const.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/notification_service.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("📩 Nhận thông báo ở background: ${message.notification?.title}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print(DefaultFirebaseOptions.currentPlatform);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // // 🔔 Đăng ký handler khi app đang tắt hoặc background
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // 🔔 Khởi tạo notification service
  await NotificationService().initializeNotification();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.appName,
      theme: Constants.lightTheme,
      darkTheme: Constants.darkTheme,
      home: MainScreen(),
    );
  }
}
