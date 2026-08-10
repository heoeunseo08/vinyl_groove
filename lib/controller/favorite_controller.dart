import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vinyl_groove/controller/product_controller.dart';
import 'package:vinyl_groove/model/product_model.dart';

class FavoriteController extends ChangeNotifier {
  FavoriteController._();

  static final FavoriteController instance = FavoriteController._();
  bool isLoading = false;
  String key = 'favor';
  List<ProductDetailModel> favoriteList = [];
  Set<int> idList = {};

  List<int> get ids => idList.toList();

  bool isFavorite(int id) => idList.contains(id);

  Future<void> model_load() async {
    if (isLoading) return;
    isLoading = true;
    favoriteList.clear();
    for (final id in ids) {
      final controller = ProductController();
      await controller.loadDetail(id);
      if (controller.detailModel != null) {
        favoriteList.add(controller.detailModel!);
      }
    }
    isLoading = false;
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final res = prefs.getStringList(key) ?? [];

    idList
      ..clear()
      ..addAll(res.map((e) => int.parse(e)));
    notifyListeners();
  }

  Future<void> set(int id) async {
    if (idList.contains(id)) {
      idList.remove(id);
      favoriteList.removeWhere((element) => element.id == id);
    } else {
      idList.add(id);
      final controller = ProductController();
      await controller.loadDetail(id);
      if (controller.detailModel != null)
        favoriteList.add(controller.detailModel!);
    }
    notifyListeners();
    await save();
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, idList.map((e) => '$e').toList());
  }
}
