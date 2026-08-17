import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vinyl_groove_test3/utils/info.dart';

Future<T?> toPage<T>({
  required BuildContext context,
  required Widget page,
}) async {
 return  Navigator.push<T>(
    context,
    MaterialPageRoute(
      builder: (context) => page,
    ),
  );
}

Future<void> showMessage(String text) async {
  channel.invokeMethod("show_message", {'text': text});
}

Future<void> step({
  required WidgetTester tester,
  required int number,
  required String text,
  required Future<void> Function() action,
}) async {
  print('[STEP No.$number] $text');
  await action();
  await tester.pumpAndSettle();
  await Future.delayed(Duration(seconds: 5));
}
