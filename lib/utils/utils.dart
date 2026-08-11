import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vinyl_groove/controller/method_controller.dart';

Future<T?> toPage<T>(BuildContext context, Widget page) async {
  return Navigator.push<T>(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}

Future<void> showMessage(String text) async {
  await MethodController.channel.invokeMethod('show_message', {'text': text});
}

Future<void> test({
  required WidgetTester tester,
  required int number,
  required String action,
  required Future<void> Function() step,
}) async {
  print('[STEP No.$number] $action');
  await step;
  await tester.pumpAndSettle();
  await Future.delayed(Duration(seconds: 5));
}
