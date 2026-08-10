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
