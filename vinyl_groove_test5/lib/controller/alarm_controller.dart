import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:vinyl_groove_test5/model/alarm_model.dart';
import 'package:vinyl_groove_test5/utils/info.dart';
import 'package:vinyl_groove_test5/utils/utils.dart';

AlarmController alarmController = AlarmController();

class AlarmController extends ChangeNotifier {
  bool isLoading = false;
  ValueNotifier<int> unreadCount = ValueNotifier(0);
  List<AlarmModel> alarm_list = [];

  Future<void> load() async {
    isLoading = true;
    try {
      final url = Uri.parse("http://$baseUrl/notifications?userId=$userId");
      final res = await http.get(url, headers: headers);

      // print(url);
      // print(res.statusCode);
      // print(res.body);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        unreadCount.value = data['data']['unreadCount'];
        alarm_list = (data['data']['notifications'] as List)
            .map((e) => AlarmModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      showMessage('$e');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> read(int id) async {
    try {
      final url = Uri.parse(
        "http://$baseUrl/notifications/read?id=$id&userId=$userId",
      );
      final res = await http.put(url, headers: headers);

      // print(url);
      // print(res.statusCode);
      // print(res.body);

      if (res.statusCode == 200) {
        final data = alarm_list.firstWhere((element) => element.id == id);
        if (!data.isRead) {
          data.isRead = true;
          unreadCount.value = unreadCount.value > 0 ? unreadCount.value - 1 : 0;
          notifyListeners();
        }
      }
    } catch (e) {
      showMessage('$e');
    }
  }
  Future<void> all_read() async {
    try {
      final url = Uri.parse(
        "http://$baseUrl/notifications/read?userId=$userId&all=true",
      );
      final res = await http.put(url, headers: headers);

      // print(url);
      // print(res.statusCode);
      // print(res.body);

      if (res.statusCode == 200) {
        for(final id in alarm_list){
          id.isRead = true;
        }
        unreadCount.value = 0;
        notifyListeners();
      }
    } catch (e) {
      showMessage('$e');
    }
  }
  Future<void> all_delete() async {
    try {
      final url = Uri.parse(
        "http://$baseUrl/notifications?userId=$userId",
      );
      final res = await http.delete(url, headers: headers);

      // print(url);
      // print(res.statusCode);
      // print(res.body);

      if (res.statusCode == 200) {
        alarm_list.clear();
        unreadCount.value = 0;
        notifyListeners();
      }
    } catch (e) {
      showMessage('$e');
    }
  }
}
