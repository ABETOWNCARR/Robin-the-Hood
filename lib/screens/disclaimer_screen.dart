import 'package:flutter/material.dart';

class DisclaimerScreen extends StatelessWidget {
  final VoidCallback onAccept;

  const DisclaimerScreen({super.key, required this.onAccept});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.warning_amber_rounded, size: 80, color: Colors.orange),
              const SizedBox(height: 24),
              const Text(
                "Important Disclaimer",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                "Robin the Hood is an educational tool only.\n\n"
                "• This app does NOT provide financial or investment advice.\n"
                "• All trading involves substantial risk of loss.\n"
                "• You are fully responsible for any trades or decisions made.\n"
                "• Past performance does not guarantee future results.\n"
                "• Automated features carry additional risks.\n\n"
                "By using this app you acknowledge these risks.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, height: 1.5),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: onAccept,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  backgroundColor: Colors.green[700],
                ),
                child: const Text("I Understand and Accept", style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 12),
              const Text(
                "Not affiliated with Robinhood Markets, Inc.",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
