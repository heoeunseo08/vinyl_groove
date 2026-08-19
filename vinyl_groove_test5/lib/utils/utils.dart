import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart' show Future, WidgetTester;

import 'info.dart' show channel;

Future<T?> topage<T>(BuildContext context, Widget page) {
  return Navigator.push<T>(
    context,
    MaterialPageRoute(
      builder: (context) => page,
    ),
  );
}

void showMessage(String text) async =>
    await channel.invokeMethod('show_message', {"text": text});

Future<void> step({
  required String text,
  required WidgetTester tester,
  required Future<void> Function() action,
}) async {
  print(text);
  await action();
  await tester.pumpAndSettle();
  await Future.delayed(Duration(seconds: 5));
}
