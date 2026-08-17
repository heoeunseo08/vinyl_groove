import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_test3/controller/favorite_comtroller.dart';
import 'package:vinyl_groove_test3/model/product_model.dart';
import 'package:vinyl_groove_test3/screen/detail_screen.dart';
import 'package:vinyl_groove_test3/utils/info.dart';
import 'package:vinyl_groove_test3/utils/util.dart';
import 'package:vinyl_groove_test3/utils/widget.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>
    with WidgetsBindingObserver {
  Set<int> yetRemoveList = {};

  @override
  void initState() {
    super.initState();
    FavoriteController.favoriteController.addListener(load);
    WidgetsBinding.instance.addObserver(this);
    load();
  }

  Future<void> load() async {
    await FavoriteController.favoriteController.modelLoad();
    setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached)
      yetRemoveReset();
    super.didChangeAppLifecycleState(state);
  }

  void yetRemoveReset() {
    for (final id in yetRemoveList)
      FavoriteController.favoriteController.set(id);
    yetRemoveList.clear();
  }

  @override
  void dispose() {
    FavoriteController.favoriteController.removeListener(load);
    WidgetsBinding.instance.removeObserver(this);
    yetRemoveReset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        surfaceTintColor: bgColor,
        automaticallyImplyLeading: false,
        title: Text(
          "관심 상품",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
      ),
      body: FavoriteController.favoriteController.ids.isEmpty
          ? noList()
          : FavoriteController.favoriteController.isLoading
          ? loadingWidget()
          : ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final model =
                    FavoriteController.favoriteController.favoriteList[index];
                return card(model);
              },
              separatorBuilder: (context, index) => SizedBox(height: 16),
              itemCount:
                  FavoriteController.favoriteController.favoriteList.length,
            ),
    );
  }

  Widget card(ProductDetailModel model) {
    bool yetRemove = yetRemoveList.contains(model.id);

    return Opacity(
      opacity: yetRemove ? 0.4 : 1,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => toPage(
                context: context,
                page: DetailScreen(product_id: model.id),
              ),
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            model.albumImage,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.white,
                                ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                model.albumName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                model.artist,
                                style: TextStyle(
                                  color: subColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 6),
                              Row(
                                spacing: 8,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Colors.black,
                                    ),
                                    child: Text(
                                      model.condition,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    genreCodes[model.genre]!,
                                    style: TextStyle(
                                      color: subColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    spacing: 6,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "₩ ${won(model.price)}",
                        style: TextStyle(
                          color: mainColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        tradeMethodCodes[model.tradeMethod]!,
                        style: TextStyle(
                          color: subColor.withValues(alpha: 0.4),
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            key: ValueKey('heart'),
            onTap: () => setState(() {
              if (yetRemove) {
                yetRemoveList.remove(model.id);
              } else {
                yetRemoveList.add(model.id);
              }
            }),
            child: Icon(
              yetRemove ? Icons.favorite_border : Icons.favorite,
              color: yetRemove ? subColor : Colors.red,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  String won(dynamic value) => NumberFormat('#,###').format(value);

  Widget noList() => Column(
    spacing: 6,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(width: MediaQuery.widthOf(context)),
      Icon(
        Icons.favorite_border,
        color: subColor,
        size: 80,
      ),
      Text(
        '관심 상품이 없습니다',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: subColor,
        ),
      ),
      Text(
        '마음에 드는 상품에 하트를 눌러보세요',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: subColor.withValues(alpha: 0.6),
        ),
      ),
    ],
  );
}
