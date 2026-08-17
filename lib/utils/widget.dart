import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vinyl_groove_test4/controller/alarm_controller.dart';
import 'package:vinyl_groove_test4/controller/favorite_controller.dart';
import 'package:vinyl_groove_test4/screen/alarm_screen.dart';
import 'package:vinyl_groove_test4/utils/info.dart';
import 'package:vinyl_groove_test4/utils/utils.dart';

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

Widget favorite_button({
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

Widget appbar(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Image.asset("assets/simbol/logo_vertical.png", height: 60),
      GestureDetector(
        onTap: () => toPage(context, AlarmScreen()),
        child: ValueListenableBuilder(
          valueListenable: AlarmController.alarmController.unreadCount,
          builder: (context, value, child) {
            return Stack(
              alignment: .center,
              children: [
                SvgPicture.asset(
                  "assets/icons/notification.svg",
                  height: 25,
                  color: Colors.white,
                ),
                if (AlarmController.alarmController.unreadCount.value != 0)
                  Positioned(
                    top: 3,
                    right: 0,
                    child: Container(
                      alignment: .center,
                      width: 15,
                      height: 15,
                      child: Text(
                        AlarmController.alarmController.unreadCount.value > 9
                            ? '9+'
                            : '${AlarmController.alarmController.unreadCount.value}',
                        style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    ],
  );
}
