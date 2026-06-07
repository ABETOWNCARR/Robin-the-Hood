import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (kDebugMode) {
          debugPrint("Notification tapped: ${response.payload}");
        }
      },
    );

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showFirebaseNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        debugPrint(
            "App opened from notification: ${message.notification?.title}");
      }
    });
  }

  static Future<void> showPatternAlert(String ticker, String message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'pattern_alerts_channel',
      'Pattern Alerts',
      channelDescription: 'Notifications for detected chart patterns',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(2147483647),
      'Pattern Detected: $ticker',
      message,
      notificationDetails,
      payload: ticker,
    );
  }

  static Future<void> _showFirebaseNotification(RemoteMessage message) async {
    if (message.notification != null) {
      await showPatternAlert(
        message.notification!.title ?? "Alert",
        message.notification!.body ?? "A new pattern was detected.",
      );
    }
  }

  static Future<String?> getFcmToken() async {
    return await FirebaseMessaging.instance.getToken();
  }
}
