import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/pattern_api_service.dart';
import '../services/notification_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PatternApiService apiService = PatternApiService();
  List<String> holdings = ["TSLA", "AAPL", "NVDA"];
  Map<String, dynamic> scanResults = {};
  bool isLoading = false;

  Future<void> runScan() async {
    setState(() => isLoading = true);
    try {
      String? token = await NotificationService.getFcmToken();
      final data = await apiService.scanAndNotify(holdings, token ?? "");
      setState(() => scanResults = data["results"] ?? {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Scan failed: $e")),
      );
    }
    setState(() => isLoading = false);
  }

  Widget _buildChart() {
    return SizedBox(
      height: 180,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 65), FlSpot(1, 78), FlSpot(2, 72),
                FlSpot(3, 89), FlSpot(4, 85), FlSpot(5, 92),
              ],
              isCurved: true,
              color: Colors.green,
              barWidth: 3,
            ),
          ],
          titlesData: const FlTitlesData(show: false),
          gridData: const FlGridData(show: false),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Robin the Hood")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Portfolio Summary", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildChart(),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: isLoading ? null : runScan,
              icon: const Icon(Icons.search),
              label: Text(isLoading ? "Scanning..." : "Scan My Holdings"),
            ),
            const SizedBox(height: 20),
            const Text("Recent Signals", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: scanResults.isEmpty
                  ? const Center(child: Text("No scans yet"))
                  : ListView(
                      children: scanResults.entries.map((entry) {
                        return Card(
                          child: ListTile(
                            title: Text(entry.key),
                            subtitle: Text(entry.value.toString()),
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
