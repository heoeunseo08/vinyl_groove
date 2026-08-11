import 'package:flutter/material.dart';
import 'package:vinyl_groove/controller/method_controller.dart';

Future<T?> toPage<T>(BuildContext context, Widget page) async {
  return Navigator.push<T>(context, MaterialPageRoute(builder: (context) => page));
}

Future<void> showMessage(String text) async {
  await MethodController.channel.invokeMethod('show_message', {'text':text});
}
