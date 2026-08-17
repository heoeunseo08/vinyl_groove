import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:vinyl_groove_test3/model/alarm_model.dart';
import 'package:vinyl_groove_test3/utils/info.dart';

AlarmController alarmController = AlarmController();

class AlarmController extends ChangeNotifier {
  String? error;
  bool isListLoading = false;
  int unreadCount = 0;
  List<AlarmModel> alarmList = [];

  Future<void> load() async {
    isListLoading = true;

    try {
      final url = Uri.parse("http://$baseUrl/notifications?userId=$userId");
      final res = await http.get(url, headers: header);

      // print(url);
      // print(res.statusCode);
      // print(res.body);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        unreadCount = data['data']['unreadCount'];
        alarmList = (data['data']['notifications'] as List)
            .map((e) => AlarmModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      error = "$e";
      print(error);
    }

    isListLoading = false;
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
        final data = alarmList.firstWhere((element) => element.id == id);
        if (!data.isRead) {
          data.isRead = true;
          unreadCount = unreadCount > 0 ? unreadCount - 1 : 0;
          notifyListeners();
        }
      }
    } catch (e) {
      error = "$e";
      print(error);
    }
  }

  Future<void> readAll() async {
    try {
      final url = Uri.parse(
        'http://$baseUrl/notifications/read?userId=$userId&all=true',
      );
      final res = await http.put(url, headers: header);

      print(url);
      print(res.statusCode);
      print(res.body);

      if (res.statusCode == 200) {
        for (final id in alarmList) {
          id.isRead = true;
        }

        unreadCount = 0;
        notifyListeners();
      }
    } catch (e) {
      error = "$e";
      print(error);
    }
  }
  Future<void> removeAll() async {
    try {
      final url = Uri.parse(
        'http://$baseUrl/notifications?userId=$userId',
      );
      final res = await http.delete(url, headers: header);

      print(url);
      print(res.statusCode);
      print(res.body);

      if (res.statusCode == 200) {
        alarmList.clear();
        unreadCount = 0;
        notifyListeners();
      }
    } catch (e) {
      error = "$e";
      print(error);
    }
  }
}
