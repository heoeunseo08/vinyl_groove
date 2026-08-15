import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

String baseUrl = '10.53.68.44:8000';

String token = '';

bool get isLogin => token.isNotEmpty;

Map<String, String> header = {
  "Content-Type": "application/json",
  if (isLogin) "Authorization": "Bearer $token",
};

int userId = 0;
String email = '';
String name = '';
String phone = '';

Color mainColor = Color(0xffd2a44a);
Color subColor = Color(0xff9fa0a2);
Color bgColor = Color(0xff121212);
Color coverColor = Color(0xff2A2A2A);

MethodChannel channel = MethodChannel('channel');

OutlineInputBorder border(Color color) => OutlineInputBorder(
  borderRadius: BorderRadius.circular(8),
  borderSide: BorderSide(color: color),
);

String won(dynamic value) {
  return NumberFormat('#,###').format(value);
}

Map<String, String> genreCodes = {
  'ROCK': 'Rock',
  'JAZZ': 'Jazz',
  'POP': 'Pop',
  'HIPHOP': 'Hip-Hop',
  'ELECTRONIC': 'Electronic',
  'CLASSICAL': 'Classical',
  'RNB_SOUL': 'R&B/Soul',
  'ETC': 'Etc',
};

Map<String, String> conditionCodes = {
  'M': "Mint",
  'NM': "NM",
  'VG+': "VG+",
  'VG': "VG",
  'G': "G",
};

Map<String, String> tradeMethodCodes = {
  'DIRECT': "직거래",
  'DELIVERY': "택배",
  'BOTH': "둘 다",
};

Map<String, String> sortCodes({bool home = false}) {
  if (home) {
    return {
      'popular': "인기 매물",
      'recent': "최신 등록",
      'price_asc': "가격 인하",
    };
  }

  return {
    'recent': "최신 등록순",
    'popular': "인기 매물순",
    'price_asc': "최저 가격순",
  };
}
