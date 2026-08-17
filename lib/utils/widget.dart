import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vinyl_groove_test3/controller/favorite_comtroller.dart';
import 'package:vinyl_groove_test3/utils/info.dart';

Widget loadingWidget() => Center(child: CircularProgressIndicator());

Widget button({
  required String text,
  required BuildContext context,
  required GestureTapCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 14),
      width: MediaQuery.widthOf(context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: mainColor,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}

Widget favoriteButton({
  required int id,
  double size = 20,
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
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 400),
          builder: (context, value, child) {
            final scale = 1 + sin(value * pi) * 0.3;
            return Transform.scale(scale: scale, child: child);
          },
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: bgColor.withValues(alpha: 0.8),
              shape: BoxShape.circle,
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

Widget noList({
  required Widget icon,
  required String title,
  required String sub,
  required BuildContext context,
}) {
  return Center(
    child: Column(
      spacing: 6,
      crossAxisAlignment: .center,
      mainAxisAlignment: .center,
      children: [
        SizedBox(width: MediaQuery.widthOf(context)),
        icon,
        Text(
          title,
          style: TextStyle(color: subColor,fontWeight: FontWeight.w700,fontSize: 16),
        ),
        Text(
          sub,
          style: TextStyle(color: subColor.withValues(alpha: 0.6),fontWeight: FontWeight.w500,fontSize: 14),
        ),
      ],
    ),
  );
}

Widget chipWrap({
  required Map<String, String> codes,
  required bool Function(String key) select,
  required void Function(String key) onTap,
  bool add = false,
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
          text: add && e.value == '둘 다'? '둘 다 가능' : e.value,
          select: select(e.key),
          onTap: () => onTap(e.key),
        ),
      ),
    ],
  );
}


Widget chip({
  required String text,
  required bool select,
  required GestureTapCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: select ? mainColor : coverColor,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: select ? Colors.black : Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    ),
  );
}