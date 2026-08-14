import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vinyl_groove2/urils/info.dart';
import 'package:vinyl_groove2/urils/util.dart';

Widget button({
  required BuildContext context,
  required String text,
  required GestureTapCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: MediaQuery.widthOf(context),
      alignment: .center,
      padding: EdgeInsets.symmetric(vertical: 14),

      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

Widget appBar1() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Image.asset("assets/simbol/logo_vertical.png", height: 55),
      GestureDetector(
         onTap: () => showMessage("해당 기능은 개발 중입니다."),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              "assets/icons/notification.svg",
              color: Colors.white,
              width: 25,
            ),
          ],
        ),
      ),
    ],
  );
}
