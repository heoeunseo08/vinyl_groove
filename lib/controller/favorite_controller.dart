import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteController extends ChangeNotifier {
  FavoriteController._();

  static final FavoriteController instance = FavoriteController._();
  String key = 'favor';
  Set<int> favoriteList = {};

  List<int> get ids => favoriteList.toList();

  bool isFavorite(int id) => favoriteList.contains(id);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final res = prefs.getStringList(key) ?? [];

    favoriteList
      ..clear()
      ..addAll(res.map((e) => int.parse(e)));
    notifyListeners();
  }

  Future<void> set(int id) async {
    if (favoriteList.contains(id)) {
      favoriteList.remove(id);
    } else {
      favoriteList.add(id);
    }
    notifyListeners();
    await save();
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, favoriteList.map((e) => '$e').toList());
  }
}
