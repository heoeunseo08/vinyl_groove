import 'package:flutter/material.dart';
import 'package:vinyl_groove/controller/method_controller.dart';

Future<void> toPage(BuildContext context, Widget page) async {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

Future<void> showMessage(String text) async {
  await MethodController.channel.invokeMethod('show_message', {'text':text});
}
