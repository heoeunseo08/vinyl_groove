import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vinyl_groove_test6/controller/product_controller.dart';
import 'package:vinyl_groove_test6/model/product_model.dart';
import 'package:vinyl_groove_test6/uitls/info.dart';

class FavoriteController extends ChangeNotifier {
  FavoriteController._();

  static final FavoriteController favoriteController = FavoriteController._();

  final controller = ProductController();
  bool isLoading = false;
  String key = 'fva';
  List<detail_ProductModel> model_list = [];
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

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key, required this.id, this.size = 18});

  final int id;
  final double size;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 500),
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> tap() async {
    FavoriteController.favoriteController.set(widget.id);
    controller.forward(from: 0);
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        FavoriteController.favoriteController,
        controller,
      ]),
      builder: (context, child) {
        final like =
        FavoriteController.favoriteController.isFavorite(widget.id);
        final scale = 1 + sin(controller.value * pi) * 0.3;

        return GestureDetector(
          key: ValueKey('he'),
          behavior: HitTestBehavior.opaque,
          onTap: tap,
          child: Transform.scale(
            scale: scale,
            child: Container(
              alignment: .center,
              width: widget.size + 10,
              height: widget.size + 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: bgColor.withValues(alpha: 0.8),
              ),
              child: Icon(
                like ? Icons.favorite : Icons.favorite_border,
                color: like ? Colors.red : Colors.white,
                size: widget.size,
              ),
            ),
          ),
        );
      },
    );
  }
}
