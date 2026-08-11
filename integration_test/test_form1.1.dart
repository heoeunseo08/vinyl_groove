import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:vinyl_groove/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test form 1.1', () {
    testWidgets('1', (tester) async {
      // Load app widget.
      await tester.pumpWidget(const MyApp());

      // Finds the floating action button to tap on.
      final fab = find.byKey(const ValueKey('increment'));

      await tester.tap(fab);

      // Trigger a frame.
      await tester.pumpAndSettle();
    });
  });
}
