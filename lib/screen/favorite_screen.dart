import 'package:flutter/material.dart';
import 'package:vinyl_groove/controller/favorite_controller.dart';
import 'package:vinyl_groove/model/product_model.dart';
import 'package:vinyl_groove/screen/detail_screen.dart';
import 'package:vinyl_groove/utils/info.dart';
import 'package:vinyl_groove/utils/utils.dart';
import 'package:vinyl_groove/utils/widget.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();
    FavoriteController.instance.addListener(load);
    load();
  }

  Future<void> load() async {
    await FavoriteController.instance.model_load();
    setState(() {});
  }

  @override
  void dispose() {
    FavoriteController.instance.removeListener(load);
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
      body: FavoriteController.instance.ids.isEmpty
          ? noList()
          : FavoriteController.instance.isLoading
          ? loadingWidget()
          : ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final model = FavoriteController.instance.favoriteList[index];
                return card(model);
              },
              separatorBuilder: (context, index) => SizedBox(height: 16),
              itemCount: FavoriteController.instance.favoriteList.length,
            ),
    );
  }

  Widget card(ProductDetailModel model) {
    return Dismissible(
      key: ValueKey(model.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) => confirmPopup(model),
      onDismissed: (direction) => delete(model),
      background: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red,
      ),
      child: GestureDetector(
        onTap: () => toPage(context, DetailScreen(product_id: model.id)),
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
                      errorBuilder: (context, error, stackTrace) => Container(
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
                              genresCode[model.genre]!,
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
                  tradeMethodCode[model.tradeMethod]!,
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
    );
  }

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

  Future<bool> confirmPopup(ProductDetailModel model) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('관심 상품 삭제'),
        content: Text('${model.albumName} 을(를) 관심 목록에서 삭제하시겠습니까?'),
        actions: [
          GestureDetector(
            onTap: () => Navigator.pop(context, false),
            child: Text('취소'),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context, true),
            child: Text('삭제'),
          ),
        ],
      ),
    );

    return confirm ?? false;
  }

  Future<void> delete(ProductDetailModel model) async {
    await FavoriteController.instance.set(model.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${model.albumName} 을(를) 관심 목록에서 삭제했습니다.'),
        duration: Duration(seconds: 2),
        action: SnackBarAction(
          label: '실행취소',
          onPressed: () async {
            await FavoriteController.instance.set(model.id);
            setState(() {});
          },
        ),
      ),
    );
  }
}
