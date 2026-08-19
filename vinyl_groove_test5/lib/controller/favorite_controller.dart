import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vinyl_groove_test5/controller/product_controller.dart';
import 'package:vinyl_groove_test5/model/product_model.dart';

class FavoriteController extends ChangeNotifier {
  FavoriteController._();

  static final FavoriteController favoriteController = FavoriteController._();

  final controller = ProductController();
  bool isLoading = false;
  String key = 'fva';
  List<DetailProductModel> model_list = [];
  Set<int> id_list = {};

  List<int> get ids => id_list.toList();

  bool isFavorite(int id) => id_list.contains(id);

  Future<void> model_load() async {
    if (isLoading) return;
    isLoading = true;

    model_list.clear();
    for (final id in ids) {
      await controller.loadDetail(id);
      if (controller.detailModel != null)
        model_list.add(controller.detailModel!);
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final res = prefs.getStringList(key) ?? [];

    id_list
      ..clear()
      ..addAll(res.map((e) => int.parse(e)).toList());
    notifyListeners();
  }

  Future<void> set(int id) async {
    if (id_list.contains(id)) {
      id_list.remove(id);
      model_list.removeWhere((element) => element.id == id);
    } else {
      id_list.add(id);
      await controller.loadDetail(id);
      if (controller.detailModel != null) {
        model_list.add(controller.detailModel!);
      }
    }
    notifyListeners();
    await save();
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      key,
      id_list
          .map(
            (e) => '$e',
          )
          .toList(),
    );
  }
}
