import 'package:flutter/material.dart';
import 'package:vinyl_groove_test4/utils/info.dart';

Future<T?> toPage<T>(BuildContext context, Widget page) {
  return Navigator.push<T>(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}

Future<void> showMessage(String text) async {
  await channel.invokeMethod("show_message", {'text': text});
}
