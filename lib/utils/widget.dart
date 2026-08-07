import 'package:flutter/material.dart';
import 'package:vinyl_groove/utils/info.dart';

Widget loadingWidget() {
  return Center(
    child: CircularProgressIndicator()
  );
}

Widget button({
  required BuildContext context,
  required String text,
  required GestureTapCallback onTap,
}) => GestureDetector(
  onTap: onTap,
  child: Container(
    alignment: Alignment.center,
    width: MediaQuery.widthOf(context),
    padding: EdgeInsets.symmetric(vertical: 14),
    decoration: BoxDecoration(
      color: mainColor,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    ),
  ),
);
