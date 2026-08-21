import 'package:flutter/material.dart';
import 'package:vinyl_groove_test7/utils/info.dart';

Widget loadingWidget() => Center(child: CircularProgressIndicator());

Widget button(
  BuildContext context, {
  required String text,
  required GestureTapCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: MediaQuery.widthOf(context),
      padding: EdgeInsets.symmetric(vertical: 14),
      alignment: .center,
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    ),
  );
}

Widget chips({
  required Map<String, String> codes,
  required bool Function(String key) select,
  required void Function(String key) onTap,
  bool all = false,
  bool Function()? all_select,
  GestureTapCallback? all_onTap,
  bool add = false,
}) {
  return Wrap(
    alignment: .start,
    runSpacing: 8,
    spacing: 8,
    children: [
      if (all) chip(text: '전체', select: all_select!(), onTap: all_onTap),
      ...codes.entries
          .map(
            (e) => chip(
              text: add && e.value == '둘 다' ? '둘 다 가능' : e.value,
              select: select(e.key),
              onTap: () => onTap(e.key),
              add: add,
            ),
          )
          .toList(),
    ],
  );
}

Widget chip({
  required String text,
  required bool select,
  required GestureTapCallback? onTap,
  bool add = false,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: add
          ? EdgeInsets.symmetric(horizontal: 16, vertical: 10)
          : EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(99),
        color: select ? mainColor : coverColor,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: select ? Colors.black : Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}
