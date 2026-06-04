import 'package:http/http.dart' as http;
import 'dart:convert';
import 'notification_service.dart';

class PatternApiService {
  // ← Update this with your deployed backend URL (Railway, etc.)
  static const String baseUrl = "https://your-backend-url.up.railway.app";

  Future<Map<String, dynamic>> scanAndNotify(List<String> tickers, String fcmToken) async {
    final response = await http.post(
      Uri.parse("$baseUrl/scan_and_notify"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "tickers": tickers,
        "fcm_token": fcmToken,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['high_confidence_alerts'] != null) {
        for (var alert in data['high_confidence_alerts']) {
          await NotificationService.showPatternAlert(
            alert['ticker'],
            "${alert['pattern']} (${(alert['confidence'] * 100).toStringAsFixed(0)}%)",
          );
        }
      }
      return data;
    } else {
      throw Exception("Failed to scan");
    }
  }
}
