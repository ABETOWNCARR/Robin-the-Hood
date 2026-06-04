import 'package:flutter/material.dart';
import '../services/pattern_api_service.dart';
import '../services/notification_service.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final PatternApiService apiService = PatternApiService();
  Map<String, dynamic> results = {};
  bool isLoading = false;
  List<String> defaultTickers = ["TSLA", "AAPL", "NVDA", "SPY", "QQQ", "AMD"];

  Future<void> runMarketScan() async {
    setState(() => isLoading = true);
    try {
      String? token = await NotificationService.getFcmToken();
      final data = await apiService.scanAndNotify(defaultTickers, token ?? "");
      setState(() => results = data["results"] ?? {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Scan failed: $e")),
      );
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Market Scanner")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: isLoading ? null : runMarketScan,
              icon: const Icon(Icons.search),
              label: Text(isLoading ? "Scanning Market..." : "Scan Popular Tickers"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: results.isEmpty
                  ? const Center(
                      child: Text(
                        "Tap the button above to scan popular tickers for patterns.",
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView(
                      children: results.entries.map((entry) {
                        final patterns = entry.value as List;
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ExpansionTile(
                            title: Text(
                              entry.key,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            children: patterns.map((pattern) {
                              return ListTile(
                                title: Text(pattern["pattern"] ?? "Unknown Pattern"),
                                subtitle: Text(
                                  "${pattern["signal"] ?? ""} • Confidence: ${(pattern["confidence"] * 100).toStringAsFixed(0)}%",
                                ),
                                trailing: Icon(
                                  pattern["signal"]?.toString().contains("Bullish") == true
                                      ? Icons.trending_up
                                      : Icons.trending_down,
                                  color: pattern["signal"]?.toString().contains("Bullish") == true
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
