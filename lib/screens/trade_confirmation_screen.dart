import 'package:flutter/material.dart';
import '../services/pattern_api_service.dart';

class TradeConfirmationScreen extends StatelessWidget {
  final String ticker;
  final String action;
  final double quantity;

  const TradeConfirmationScreen({
    super.key,
    required this.ticker,
    required this.action,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Confirm Trade")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "⚠️ IMPORTANT DISCLAIMER",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 12),
            const Text(
              "This is an educational app. We do not provide financial advice. "
              "Trading involves significant risk of loss. You are solely responsible for any trades executed. "
              "Robin the Hood and its developers are not liable for any financial losses.",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 30),
            Text(
              "You are about to ${action.toUpperCase()} $quantity shares of $ticker",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 55),
              ),
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                final navigator = Navigator.of(context);
                try {
                  await PatternApiService()
                      .executeTrade(ticker, action, quantity);
                  messenger.showSnackBar(
                    const SnackBar(content: Text("Trade request sent")),
                  );
                  navigator.pop();
                } catch (error) {
                  messenger.showSnackBar(
                    SnackBar(content: Text("Trade request failed: $error")),
                  );
                }
              },
              child: const Text("I Understand the Risks — Confirm Trade"),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
          ],
        ),
      ),
    );
  }
}
