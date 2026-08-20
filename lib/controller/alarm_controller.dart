import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:vinyl_groove_test6/model/alarm_model.dart';
import 'package:vinyl_groove_test6/uitls/info.dart';
import 'package:vinyl_groove_test6/uitls/utils.dart';

AlarmController alarmController = AlarmController();

class AlarmController extends ChangeNotifier {
  bool isLoading = false;

  ValueNotifier<int> unreadCount = ValueNotifier(0);
  List<AlarmModel> alarm_list = [];

  Future<void> load() async {
    isLoading = true;
    try {
      final url = Uri.parse("http://$baseUrl/notifications?userId=$id");
      final res = await http.get(url, headers: headers);

      // print(url);
      // print(res.body);
      // print(res.statusCode);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        unreadCount.value = data['data']['unreadCount'];

        alarm_list = (data['data']['notifications'] as List)
            .map((e) => AlarmModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      print('$e');
      showMessage(text: '$e');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> read(int aid) async {
    try {
      final url = Uri.parse(
        "http://${baseUrl}/notifications/read?id=$aid&userId=${id}",
      );
      final res = await http.put(url, headers: headers);

      print(url);
      print(res.body);
      print(res.statusCode);

      if (res.statusCode == 200) {
        final data = alarm_list.firstWhere((element) => element.id == aid);
        if (!data.isRead) {
          unreadCount.value = unreadCount.value > 0 ? unreadCount.value - 1 : 0;
          notifyListeners();
        }
      }
    } catch (e) {
      showMessage(text: '$e');
    }
  }

  Future<void> all_read() async {
    try {
      final url = Uri.parse(
        "http://$baseUrl/notifications/read?userId=$id&all=true",
      );
      final res = await http.put(url, headers: headers);

      // print(url);
      // print(res.body);
      // print(res.statusCode);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        for (final id in alarm_list) {
          id.isRead = true;
        }
        unreadCount.value = 0;
        notifyListeners();
      }
    } catch (e) {
      showMessage(text: '$e');
    }
  }

  Future<void> delete() async {
    try {
      final url = Uri.parse(
        "http://$baseUrl/notifications?userId=$id",
      );
      final res = await http.delete(url, headers: headers);

      // print(url);
      // print(res.body);
      // print(res.statusCode);

      if (res.statusCode == 200) {
        alarm_list.clear();
        unreadCount.value = 0;
        notifyListeners();
      }
    } catch (e) {
      showMessage(text: '$e');
    }
  }
}
