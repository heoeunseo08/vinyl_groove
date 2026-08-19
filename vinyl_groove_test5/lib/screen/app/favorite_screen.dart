import 'package:flutter/material.dart';
import 'package:vinyl_groove_test5/controller/favorite_controller.dart';
import 'package:vinyl_groove_test5/model/product_model.dart';
import 'package:vinyl_groove_test5/screen/detail_screen.dart';
import 'package:vinyl_groove_test5/utils/info.dart';
import 'package:vinyl_groove_test5/utils/utils.dart';
import 'package:vinyl_groove_test5/utils/widget.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>{
  List<DetailProductModel> snapshot = [];
  Set<int> expectedList = {};

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    await FavoriteController.favoriteController.model_load();
    setState(() {
      snapshot = List.of(FavoriteController.favoriteController.model_list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "관심 상품",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
      ),
      body: FavoriteController.favoriteController.isLoading
          ? LoadingWidget()
          : snapshot.isEmpty
          ? noList(
              context,
              icons: Icon(Icons.favorite_border, color: subColor, size: 70),
              title: '관심 상품이 없습니다.',
              sub: '마음에 드는 상품에 하트를 눌러보세요.',
            )
          : ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) => card(index),
              separatorBuilder: (context, index) => SizedBox(height: 12),
              itemCount: snapshot.length,
            ),
    );
  }

  Widget card(int index) {
    final model = snapshot[index];
    final double size = 90.0;
    final expected = expectedList.contains(model.id);
    return GestureDetector(
      onTap: () async => topage(context, DetailScreen(id: model.id)),
      child: Opacity(
        opacity: expected ? 0.4 : 1,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: .circular(12),
                    child: Image.network(
                      width: size,
                      height: size,
                      model.albumImage,
                      fit: .cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.white,
                        width: size,
                        height: size,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      spacing: 5,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.albumName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          model.artist,
                          style: TextStyle(
                            color: subColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
                                '${conditionCodes[model.condition]}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            Text(
                              '${genreCodes[model.genre]}',
                              style: TextStyle(
                                color: subColor,
                                fontSize: 11,
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
              crossAxisAlignment: .end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '₩ ${won(model.price)}',
                  style: TextStyle(
                    color: mainColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '${tradeMethodCodes[model.tradeMethod]}',
                  style: TextStyle(
                    color: subColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18, right: 2),
              child: GestureDetector(
                key: ValueKey('heart$index'),
                onTap: () {
                  setState(() {
                    if (expected) {
                      print('object');
                      expectedList.remove(model.id);
                    } else {
                      print('object1');
                      expectedList.add(model.id);
                    }
                  });
                  FavoriteController.favoriteController.set(model.id);
                },
                child: Icon(
                  expected ? Icons.favorite_border : Icons.favorite,
                  color: expected ? Colors.white : Colors.red,
                  size: 25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
