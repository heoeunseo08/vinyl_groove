import 'package:flutter/material.dart';
import 'package:vinyl_groove2/urils/info.dart';

Future<void> toPage(BuildContext context, Widget page) async {
  Navigator.push(context, MaterialPageRoute(builder: (cMntext) => page));
}
Future<void> showMessage(String text) async {
  await channel.invokeMethod('show_message', {'text': text});
}
