// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:robin_the_hood/screens/agent_controls_screen.dart';

void main() {
  testWidgets('AgentControlsScreen displays title',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AgentControlsScreen(),
      ),
    );

    expect(find.byType(AgentControlsScreen), findsOneWidget);
    expect(
        find.text(
            'This section will let you configure and manage the smart agent behavior for pattern alerts.'),
        findsOneWidget);
  });
}
