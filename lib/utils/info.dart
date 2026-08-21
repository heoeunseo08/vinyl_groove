import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

String baseUrl = '10.53.68.44:8000';
String token = '';

bool get isLogin => token.isNotEmpty;

Map<String, String> get headers => {
  "Content-Type": "application/json",
  if (isLogin) "Authorization": "Bearer ${token}",
};
int userId = 0;
String email = '';
String name = '';
String phone = '';

Color mainColor = Color(0xffd2a44a);
Color subColor = Color(0xff8a8a8c);
Color coverColor = Color(0xff2a2a2a);
Color bgColor = Color(0xff121212);

MethodChannel channel = MethodChannel('channel');

border(Color color) => OutlineInputBorder(
  borderRadius: BorderRadius.circular(8),
  borderSide: BorderSide(color: color),
);

String won(dynamic a) =>NumberFormat('#,###').format(a);

Map<String, String> genre_codes({bool home = true}) {
  if (home) {
    return {
      'ROCK': 'Rock',
      'JAZZ': 'Jazz',
      'POP': 'Pop',
      'HIPHOP': 'Hip-Hop',
      'ELECTRONIC': 'Electronic',
      'CLASSICAL': 'Classical',
      'RNB_SOUL': 'R&B/Soul',
      'ETC': '기타',
    };
  }
  return {
    'ROCK': 'Rock',
    'JAZZ': 'Jazz',
    'POP': 'Pop',
    'HIPHOP': 'Hip-Hop',
    'ELECTRONIC': 'Electronic',
    'CLASSICAL': 'Classical',
    'RNB_SOUL': 'R&B/Soul',
    'ETC': 'Etc',
  };
  ;
}

Map<String, String> condition_codes() {
  return {
    'M': 'Mint',
    'NM': 'NM',
    'VG+': 'VG+',
    'VG': 'VG',
    'G': 'G',
  };
}

Map<String, String> tradeMethod_codes() {
  return {
    'DIRECT': "직거래",
    'DELIVERY': "택배",
    'BOTH': "둘 다",
  };
}

Map<String, String> sort_codes({bool home = true}) {
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
