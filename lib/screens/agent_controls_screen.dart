import 'package:flutter/material.dart';

class AgentControlsScreen extends StatelessWidget {
  const AgentControlsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agent Controls')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Agent Controls',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'This section will let you configure and manage the smart agent behavior for pattern alerts.',
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
            SizedBox(height: 20),
            Text(
              'For now, use the Settings tab to switch between Alerts mode and Agent mode.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
