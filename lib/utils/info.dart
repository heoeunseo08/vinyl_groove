import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove/model/product_model.dart';

final String baseUrl = "10.0.2.2:8080";

String token = '';

Map<String, String> get header => {
  'Content-Type': 'application/json',
  if (isLogin) 'Authorization': 'Bearer $token',
};

int user_id = 0;
String email = "";
String name = "";
String phone = "";

bool get isLogin => token.isNotEmpty;

String won(dynamic value){
  return NumberFormat('#,###').format(value);
}

Color mainColor = Color(0xffD4A54B);
Color subColor = Color(0xffa5a5a5);
Color bgColor = Color(0xff101113);
Color coverColor = Color(0xff1E1E1E);

OutlineInputBorder border(Color color) => OutlineInputBorder(
  borderRadius: BorderRadius.circular(8),
  borderSide: BorderSide(color: color, width: 1.5),
);

const Map<String, String> genresCode = {
  "ROCK": "Rock",
  "JAZZ": "Jazz",
  "POP": "Pop",
  "HIPHOP": "Hip-Hop",
  "ELECTRONIC": "Electronic",
  "CLASSICAL": "Classical",
  "RNB_SOUL": "R&B/Soul",
  "ETC": "기타",
};

Map<String, String> sortCode({bool search = false}) {
  if (search) {
    return {
      "recent": "최신 등록순",
      "popular": "인기 매물순",
      "price_asc": "최저 가격순",
    };
  }

  return {
    "popular": "인기 매물",
    "recent": "최신 등록",
    "price_asc": "가격 인하",
  };
}

const Map<String, String> conditionCode = {
  "M": "Mint",
  "NM": "NM",
  "VG+": "VG+",
  "VG": "VG",
  "G": "G",
};

const Map<String, String> tradeMethodCode = {
  'DIRECT': '직거래',
  'DELIVERY': '택배',
  'BOTH': '둘 다',
};

class keys {}
