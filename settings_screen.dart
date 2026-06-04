import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  String currentMode = "alerts";

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      currentMode = prefs.getString('trading_mode') ?? "alerts";
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
    setState(() => notificationsEnabled = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Push Notifications"),
            subtitle: const Text("Receive pattern alerts"),
            value: notificationsEnabled,
            onChanged: _toggleNotifications,
          ),
          ListTile(
            title: const Text("Trading Mode"),
            subtitle: Text(currentMode == "agent" ? "Smart Agent Mode" : "Alerts Mode"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to mode selection or Agentic setup
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("About Robin the Hood"),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "Robin the Hood",
                applicationVersion: "1.0.0",
                children: const [
                  Text("Educational chart pattern scanner for Robinhood users."),
                ],
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.policy),
            title: const Text("Privacy Policy"),
            onTap: () {
              // Open hosted privacy policy
            },
          ),
        ],
      ),
    );
  }
}
