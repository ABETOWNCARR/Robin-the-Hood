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
      initializationSettings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print("Notification tapped: ${response.payload}");
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
      print("App opened from notification: ${message.notification?.title}");
    });
  }

  static Future<void> showPatternAlert(String ticker, String message) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
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
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: 'Pattern Detected: $ticker',
      body: message,
      notificationDetails: notificationDetails,
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
