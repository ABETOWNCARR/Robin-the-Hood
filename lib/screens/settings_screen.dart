import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _tradingModeKey = 'trading_mode';
  static final Uri _privacyPolicyUri =
      Uri.parse('https://example.com/privacy-policy');

  bool notificationsEnabled = true;
  String currentMode = 'alerts';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      notificationsEnabled = prefs.getBool(_notificationsEnabledKey) ?? true;
      currentMode = prefs.getString(_tradingModeKey) ?? 'alerts';
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsEnabledKey, value);
    if (!mounted) return;
    setState(() => notificationsEnabled = value);
  }

  Future<void> _saveTradingMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tradingModeKey, mode);
    if (!mounted) return;
    setState(() => currentMode = mode);
  }

  Future<void> _showModeSelection() async {
    final selectedMode = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Trading Mode'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Alerts Mode'),
                subtitle: const Text('Receive pattern notifications only.'),
                trailing: currentMode == 'alerts'
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : const Icon(Icons.radio_button_unchecked),
                onTap: () => Navigator.of(context).pop('alerts'),
              ),
              ListTile(
                title: const Text('Agent Mode'),
                subtitle: const Text(
                    'Enable smart pattern review and suggested actions.'),
                trailing: currentMode == 'agent'
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : const Icon(Icons.radio_button_unchecked),
                onTap: () => Navigator.of(context).pop('agent'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (selectedMode != null && selectedMode != currentMode) {
      await _saveTradingMode(selectedMode);
    }
  }

  Future<void> _openPrivacyPolicy() async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final launched = await launchUrl(_privacyPolicyUri,
          mode: LaunchMode.externalApplication);
      if (!launched) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Could not open privacy policy.')),
        );
      }
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Could not open privacy policy.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          SwitchListTile(
            title: const Text('Push Notifications'),
            subtitle: const Text('Receive pattern alerts'),
            value: notificationsEnabled,
            onChanged: _toggleNotifications,
          ),
          ListTile(
            title: const Text('Trading Mode'),
            subtitle: Text(
                currentMode == 'agent' ? 'Smart Agent Mode' : 'Alerts Mode'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showModeSelection,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Agent mode lets the app suggest actions based on detected patterns. Alerts mode only sends notifications.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About Robin the Hood'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Robin the Hood',
                applicationVersion: '1.0.0',
                children: const [
                  Text(
                      'Educational chart pattern scanner for Robinhood users.'),
                ],
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.policy),
            title: const Text('Privacy Policy'),
            onTap: _openPrivacyPolicy,
          ),
        ],
      ),
    );
  }
}
