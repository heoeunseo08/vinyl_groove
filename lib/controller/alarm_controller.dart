import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vinyl_groove_test4/utils/info.dart';
import 'package:vinyl_groove_test4/model/alarm_model.dart';


class AlarmController extends ChangeNotifier {
  AlarmController._();

  static final AlarmController alarmController = AlarmController._();

  bool isLoading = false;
  ValueNotifier<int> unreadCount = ValueNotifier(0);
  List<AlarmModel> alarmList = [];

  Future<void> load() async {
    isLoading = true;

    try {
      final url = Uri.parse("http://$baseUrl/notifications?userId=$userId");
      final res = await http.get(url, headers: header);

      print(url);
      print(res.statusCode);
      print(res.body);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        unreadCount.value = data['data']['unreadCount'];
        alarmList = (data['data']['notifications'] as List)
            .map(
              (e) => AlarmModel.fromJson(e),
            )
            .toList();
      }
    } catch (e) {
      print("$e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> read(int id) async {
    try {
      final url = Uri.parse(
        "http://$baseUrl/notifications/read?id=$id&userId=$userId",
      );
      final res = await http.put(url, headers: header);

      print(url);
      print(res.statusCode);
      print(res.body);

      if (res.statusCode == 200) {
        final data = alarmList.firstWhere((e) => e.id == id);
        if (!data.isRead) {
          data.isRead = true;
          unreadCount.value = unreadCount.value > 0 ? unreadCount.value - 1 : 0;
          notifyListeners();
        }
      }
    } catch (e) {
      print("$e");
    }
  }

  Future<void> readAll() async {
    try {
      final url = Uri.parse(
        "http://$baseUrl/notifications/read?userId=$userId&all=true",
      );
      final res = await http.put(url, headers: header);

      print(url);
      print(res.statusCode);
      print(res.body);

      if (res.statusCode == 200) {
        for (final n in alarmList) {
          n.isRead = true;
        }
        unreadCount.value = 0;
        notifyListeners();
      }
    } catch (e) {
      print("$e");
    }
  }

  Future<void> removeAll() async {
    try {
      final url = Uri.parse("http://$baseUrl/notifications?userId=$userId");
      final res = await http.delete(url, headers: header);

      print(url);
      print(res.statusCode);
      print(res.body);

      if (res.statusCode == 200) {
        alarmList.clear();
        unreadCount.value = 0;
        notifyListeners();
      }
    } catch (e) {
      print("$e");
    }
  }
}
