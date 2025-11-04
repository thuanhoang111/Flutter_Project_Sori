import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// ✅ Firebase config tự tạo thủ công
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      // case TargetPlatform.iOS:
      //   return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions chưa được hỗ trợ cho nền tảng này.',
        );
    }
  }

  // 🌐 Web config
  static const FirebaseOptions web = FirebaseOptions(
      apiKey: "AIzaSyCsvvixD9s3fiV-hYVY6P-o0GdXh1obeMo",
      authDomain: "flutter-project-sori.firebaseapp.com",
      projectId: "flutter-project-sori",
      storageBucket: "flutter-project-sori.firebasestorage.app",
      messagingSenderId: "515959441817",
      appId: "1:515959441817:web:203dd588593443d5c5eb08");

  // 🤖 Android config (nếu có)
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyCEfW1l6D8bBUYBZ5gWcpsTwn-tZh8qQU0",
    appId: "1:515959441817:android:a7c41af0ae6f08dac5eb08",
    messagingSenderId: "515959441817",
    projectId: "flutter-project-sori",
    storageBucket: "flutter-project-sori.firebasestorage.app",
  );

  // // 🍎 iOS config (nếu bạn build iOS)
  // static const FirebaseOptions ios = FirebaseOptions(
  //   apiKey: "AIzaSyA...xyz",
  //   appId: "1:1234567890:ios:abcdef123456",
  //   messagingSenderId: "1234567890",
  //   projectId: "myapp",
  //   storageBucket: "myapp.appspot.com",
  //   iosClientId: "1234567890-abcdef.apps.googleusercontent.com",
  //   iosBundleId: "com.example.myapp",
  // );
}
