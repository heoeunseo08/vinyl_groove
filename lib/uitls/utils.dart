import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vinyl_groove_test6/uitls/info.dart';

Future<T?> toPage<T>(BuildContext context, Widget page) {
  return Navigator.push<T>(
    context,
    MaterialPageRoute(
      builder: (context) => page,
    ),
  );
}

Future<void> showMessage({String text = '해당 기능은 준비 중입니다.'}) async {
  return channel.invokeMethod('message', {'text': text});
}

Future<void> step({
  required String text,
  required WidgetTester tester,
  required Future<void> Function() action,
}) async {
  print(text);
  await tester.pumpAndSettle();
  await action();
  await Future.delayed(Duration(seconds: 5));
}
