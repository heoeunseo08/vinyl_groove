import 'package:flutter/material.dart';
import 'package:vinyl_groove_test3/controller/product_controller.dart';
import 'package:vinyl_groove_test3/model/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteController extends ChangeNotifier {
  FavoriteController._();

  static final FavoriteController favoriteController = FavoriteController._();
  bool isLoading = false;
  String key = 'favor';
  List<ProductDetailModel> favoriteList = [];
  Set<int> idList = {};

  List<int> get ids => idList.toList();

  bool isFavorite(int id) => idList.contains(id);

  Future<void> modelLoad() async {
    if (isLoading) return;
    isLoading = true;
    favoriteList.clear();

    for (final id in ids) {
      final ProductController productController = ProductController();
      await productController.loadDetail(id);
      if (productController.detailModel != null) {
        favoriteList.add(productController.detailModel!);
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

      final ProductController productController = ProductController();
      await productController.loadDetail(id);
      if (productController.detailModel != null) {
        favoriteList.add(productController.detailModel!);
      }
    }
    notifyListeners();
    await save();
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      key,
      idList.map((e) => '$e').toList(),
    );
  }
}
