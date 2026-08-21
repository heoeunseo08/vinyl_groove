import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vinyl_groove_test7/utils/info.dart';

Future<T?> toPage<T>(BuildContext context, Widget page) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => page,
    ),
  );
}

Future<void> show_message({String text = "해당 기능은 준비 중입니다."}) async =>
    await channel.invokeMethod('show', {'text': text});
