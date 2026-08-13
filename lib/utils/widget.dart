import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vinyl_groove/controller/favorite_controller.dart';
import 'package:vinyl_groove/utils/info.dart';

Widget loadingWidget() {
  return Center(child: CircularProgressIndicator());
}

Widget favoriteWidget({
  required int id,
  double size = 20,
}) {
  return AnimatedBuilder(
    animation: FavoriteController.instance,
    builder: (context, child) {
      final like = FavoriteController.instance.isFavorite(id);
      return GestureDetector(
        key: ValueKey('favorite'),
        behavior: HitTestBehavior.opaque,
        onTap: () => FavoriteController.instance.set(id),
        child: TweenAnimationBuilder<double>(
          key: ValueKey(like),
          builder: (context, value, child) {
            final scale = 1 + sin(value * pi) * 0.3;
            return Transform.scale(scale: scale, child: child);
          },
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 300),
          child: Container(
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

Widget chip({
  required String text,
  required bool select,
  required GestureTapCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: select ? mainColor : coverColor,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: select ? Colors.black : Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 12,
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
  GestureTapCallback? onAllTap,
}) {
  return Wrap(
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: 8,
    runSpacing: 8,
    children: [
      if (showAll)
        chip(
          text: "전체",
          select: allSelect!(),
          onTap: onAllTap!,
        ),
      ...codes.entries.map(
        (e) => chip(
          text: e.value,
          select: select(e.key),
          onTap: () => onTap(e.key),
        ),
      ),
    ],
  );
}
