import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vinyl_groove/model/notification_model.dart';
import 'package:vinyl_groove/utils/info.dart';

NotifController notifController = NotifController();

class NotifController extends ChangeNotifier {
  bool isLoading = false;
  int unreadCount = 0;
  List<NotificationModel> model_list = [];

  Future<void> load() async {
    isLoading = true;

    try {
      final url = Uri.parse("http://$baseUrl/notifications?userId=$user_id");
      final res = await http.get(url, headers: header);

      print(url);
      print(res.statusCode);
      print(res.body);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        unreadCount = data['data']['unreadCount'];
        model_list = (data['data']['notifications'] as List)
            .map(
              (e) => NotificationModel.fromJson(e),
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
        "http://$baseUrl/notifications/read?id=$id&userId=$user_id",
      );
      final res = await http.put(url, headers: header);

      print(url);
      print(res.statusCode);
      print(res.body);

      if (res.statusCode == 200) {
        final data = model_list.firstWhere((e) => e.id == id);
        if (!data.isRead) {
          data.isRead = true;
          unreadCount = unreadCount > 0 ? unreadCount - 1 : 0;
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
        "http://$baseUrl/notifications/read?userId=$user_id&all=true",
      );
      final res = await http.put(url, headers: header);

      print(url);
      print(res.statusCode);
      print(res.body);

      if (res.statusCode == 200) {
        for (final n in model_list) {
          n.isRead = true;
        }
        unreadCount = 0;
        notifyListeners();
      }
    } catch (e) {
      print("$e");
    }
  }

  Future<void> deleteAll() async {
    try {
      final url = Uri.parse("http://$baseUrl/notifications?userId=$user_id");
      final res = await http.delete(url, headers: header);

      print(url);
      print(res.statusCode);
      print(res.body);

      if (res.statusCode == 200) {
        model_list.clear();
        unreadCount = 0;
        notifyListeners();
      }
    } catch (e) {
      print("$e");
    }
  }
}
