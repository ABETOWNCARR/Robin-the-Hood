import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static int _notificationId = 0;

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings darwinSettings =
        DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (kDebugMode) {
          debugPrint("Notification tapped: ${response.payload}");
        }
      },
    );

    try {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _showFirebaseNotification(message);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        if (kDebugMode) {
          debugPrint(
              "App opened from notification: ${message.notification?.title}");
        }
      });
    } catch (_) {
      // Firebase isn't configured (e.g. missing google-services.json) —
      // local notifications still work, push just won't.
    }
  }

  static Future<void> requestPermission() async {
    try {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    } catch (_) {
      // Firebase isn't configured — nothing to request.
    }
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

    const DarwinNotificationDetails darwinDetails = DarwinNotificationDetails();

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );

    await _localNotifications.show(
      id: _notificationId++,
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
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (_) {
      // Firebase isn't configured — scans can still run without a token.
      return null;
    }
  }
}
