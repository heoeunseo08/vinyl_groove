import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vinyl_groove_test5/controller/favorite_controller.dart';
import 'package:vinyl_groove_test5/utils/info.dart';

Widget LoadingWidget() => Center(child: CircularProgressIndicator());

Widget button({
  required BuildContext context,
  required String text,
  required GestureTapCallback? onTap,
}) => GestureDetector(
  onTap: onTap,
  child: Container(
    width: MediaQuery.widthOf(context),
    alignment: .center,
    decoration: BoxDecoration(
      color: mainColor,
      borderRadius: BorderRadius.circular(8),
    ),
    padding: EdgeInsets.symmetric(vertical: 16),
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
  bool showAll = false,
  bool Function()? AllSelect,
  GestureTapCallback? AllOnTap,
  bool add = false,
}) {
  return Wrap(
    crossAxisAlignment: .start,
    alignment: WrapAlignment.start,
    spacing: 8,
    runSpacing: 8,
    children: [
      if (showAll) chip(text: '전체', select: AllSelect!(), onTap: AllOnTap),

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
      padding: add ? EdgeInsets.symmetric(horizontal: 18, vertical: 12) :EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(99),
        color: select ? mainColor : coverColor,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: select ? Colors.black : Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
      ),
    ),
  );
}

Widget favoriteButton({
  required int id,
  double? size = 20,
}) {
  return AnimatedBuilder(
    animation: FavoriteController.favoriteController,
    builder: (context, child) {
      final like = FavoriteController.favoriteController.isFavorite(id);
      return GestureDetector(
        key: ValueKey('favorite'),
        behavior: HitTestBehavior.opaque,
        onTap: () => FavoriteController.favoriteController.set(id),

        child: TweenAnimationBuilder<double>(
          key: ValueKey(like),
          duration: Duration(milliseconds: 600),
          tween: Tween(begin: 0, end: 1),
          builder: (context, value, child) {
            final scale = 1 + sin(value * pi) * 0.3;
            return Transform.scale(scale: scale, child: child);
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bgColor.withValues(alpha: 0.8),
            ),
            child: Icon(
              like ? Icons.favorite : Icons.favorite_border,
              color: like ? Colors.red : Colors.white,
              size: size,
            ),
          ),
        ),
      );
    },
  );
}

Widget noList(
  BuildContext context, {
  required Widget icons,
  required String title,
  required String sub,
}) {
  return Column(
    spacing: 10,
    mainAxisAlignment: .center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(width: MediaQuery.widthOf(context)),
      icons,
      Text(
        title,
        style: TextStyle(
          color: subColor,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      Text(
        sub,
        style: TextStyle(
          color: subColor,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    ],
  );
}
