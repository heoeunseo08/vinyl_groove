import 'package:flutter/material.dart';
import 'package:vinyl_groove_test4/utils/info.dart';

Widget loadingWidget() => Center(child: CircularProgressIndicator());

Widget button({
  required BuildContext context,
  required String text,
  required GestureTapCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: MediaQuery.widthOf(context),
      padding: EdgeInsets.symmetric(vertical: 16),
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
          fontSize: 16,
        ),
      ),
    ),
  );
}

Widget chipWrap({
  required Map<String, String> codes,
  required bool Function(String key) select,
  required void Function(String key) onTap,
  bool showAll = false,
  bool Function()? allSelect,
  GestureTapCallback? allTap,
}) {
  return Wrap(
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: 8,
    runSpacing: 8,
    children: [
      if (showAll) chip(text: '전체', select: allSelect!(), ontap: allTap),
      ...codes.entries.map(
        (e) => chip(
          text: e.value,
          select: select(e.key),
          ontap: () => onTap(e.key),
        ),
      ),
    ],
  );
}

Widget chip({
  required String text,
  required bool select,
  required GestureTapCallback? ontap,
}) {
  return GestureDetector(
    onTap: ontap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(99),
        color: select ? mainColor : coverColor,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: select ? Colors.black : Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    ),
  );
}
