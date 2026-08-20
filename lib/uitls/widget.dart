import 'package:flutter/material.dart';
import 'package:vinyl_groove_test6/uitls/info.dart';

Widget loadingWidget() => Center(child: CircularProgressIndicator());

Widget button({
  required BuildContext context,
  required String text,
  required GestureTapCallback? onTap,
}) => GestureDetector(
  onTap: onTap,
  child: Container(
    padding: EdgeInsets.symmetric(vertical: 14),
    width: MediaQuery.widthOf(context),
    decoration: BoxDecoration(
      color: mainColor,
      borderRadius: BorderRadius.circular(8),
    ),
    alignment: .center,
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

Widget chipWrap({
  required Map<String, String> codes,
  required bool Function(String key) select,
  required void Function(String key) onTap,
  bool all = false,
  bool Function()? all_select,
  GestureTapCallback? all_onTap,
  bool add = false,
}) {
  return Wrap(
    alignment: WrapAlignment.start,
    runSpacing: 8,
    spacing: 8,
    children: [
      if (all) chip(text: '전체', select: all_select!(), onTap: all_onTap),
      ...codes.entries
          .map(
            (e) => chip(
              text: add && e.value == '들 다' ? '둘 다 가능' : e.value,
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
}) => GestureDetector(
  onTap: onTap,
  child: Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(99),
      color: select ? mainColor : coverColor,
    ),
    padding: add
        ? EdgeInsets.symmetric(horizontal: 18, vertical: 10)
        : EdgeInsets.symmetric(vertical: 6, horizontal: 14),
    child: Text(
      add&&text == '둘 다' ? '둘 다 가능' : text,
      style: TextStyle(
        color: select ? Colors.black : Colors.white,
        fontSize: 14,
      ),
    ),
  ),
);

Widget noList(
  BuildContext context, {
  required Widget icon,
  required String title,
  required String sub,
}) {
  return Column(
    spacing: 10,
    crossAxisAlignment: .center,
    mainAxisAlignment: .center,
    children: [
      Container(width: MediaQuery.widthOf(context)),
      icon,
      Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: subColor,
        ),
      ),
      Text(
        sub,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: subColor,
        ),
      ),
    ],
  );
}
