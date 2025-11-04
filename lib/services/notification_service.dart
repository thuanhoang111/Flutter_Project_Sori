// 📁 lib/services/notification_service.dart
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  // Singleton (đảm bảo chỉ có 1 instance dùng trong toàn app)
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  /// Gọi khi app khởi động (trong main)
  Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      null, // icon mặc định (sử dụng icon của app)
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic Notifications',
          channelDescription: 'Thông báo cơ bản',
          defaultColor: Colors.orange,
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          channelShowBadge: true,
        ),
      ],
      debug: true, // để log debug trong giai đoạn dev
    );

    // Kiểm tra & xin quyền thông báo (chỉ 1 lần)
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  /// Hiển thị thông báo cơ bản
  Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now()
            .millisecondsSinceEpoch
            .remainder(100000), // random id
        channelKey: 'basic_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }

  /// Hiển thị thông báo riêng khi thanh toán thành công
  Future<void> showPaymentSuccessNotification() async {
    await showNotification(
      title: 'Thanh toán thành công!',
      body: 'Đơn hàng của bạn đã được xác nhận. Cảm ơn bạn đã mua hàng!',
    );
  }
}
