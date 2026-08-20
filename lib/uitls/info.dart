import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

bool testMode = false;

String baseUrl = '10.53.68.44:8000';

String token = '';

bool get isLogin => token.isNotEmpty;

Map<String, String> get headers => {
  "Content-Type": 'application/json',
  if (isLogin) "Authorization": "Bearer $token",
};

OutlineInputBorder border(Color color) => OutlineInputBorder(
  borderRadius: BorderRadius.circular(8),
  borderSide: BorderSide(color: color),
);

String won(dynamic value) => NumberFormat('#,###').format(value);

Color mainColor = Color(0xffd2a44a);
Color subColor = Color(0xff9d9d9d);
Color coverColor = Color(0xff2a2a2a);
Color bgColor = Color(0xff121212);

MethodChannel channel = MethodChannel('channel');

int id = 0;
String email = '';
String name = '';
String phone = '';

Map<String, String> sortCodes({bool home = false}) {
  if (home) {
    return {
      "popular": "인기 매물",
      "recent": "최신 등록",
      "price_asc": "가격 인하",
    };
  }
  return {
    "recent": "최신 등록순",
    "popular": "인기 매물순",
    "price_asc": "최저 가격순",
  };
}

Map<String, String> genreCodes({bool home = false}) => {
  'ROCK': 'Rock',
  'JAZZ': 'Jazz',
  'POP': 'Pop',
  'HIPHOP': 'Hip-Hop',
  'ELECTRONIC': 'Electronic',
  'CLASSICAL': 'Classical',
  'RNB_SOUL': 'R&B/Soul',
  'ETC': home ? '기타' : 'Etc',
};

Map<String, String> conditionCodes = {
  "M": "Mint",
  "NM": "NM",
  "VG+": "VG+",
  "VG": "VG",
  "G": "G",
};
Map<String, String> tradeMethodCodes = {
  'DIRECT': "직거래",
  'DELIVERY': "택배",
  'BOTH': "둘 다",
};
