import 'package:flutter/material.dart';
import 'package:vinyl_groove/controller/product_controller.dart';
import 'package:vinyl_groove/model/product_model.dart';
import 'package:vinyl_groove/screen/add_product_screen.dart';
import 'package:vinyl_groove/screen/detail_screen.dart';
import 'package:vinyl_groove/utils/info.dart';
import 'package:vinyl_groove/utils/utils.dart';
import 'package:vinyl_groove/utils/widget.dart';

class MyProductScreen extends StatefulWidget {
  const MyProductScreen({super.key});

  @override
  State<MyProductScreen> createState() => _MyProductScreenState();
}

class _MyProductScreenState extends State<MyProductScreen> {
  ProductController productController = ProductController();

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    await productController.loadMyList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(),
      body: RefreshIndicator(
        onRefresh: () => load(),
        child: productController.isMyLoading
            ? loadingWidget()
            : productController.myProductList.isEmpty
            ? ListView(
                children: [
                  SizedBox(height: 200),
                  noList(),
                ],
              )
            : ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 12),
                itemBuilder: (context, index) {
                  final model = productController.myProductList[index];
                  return card(model);
                },
                separatorBuilder: (context, index) => SizedBox(height: 14),
                itemCount: productController.myProductList.length,
              ),
      ),
    );
  }

  Widget card(MyProductModel model) {
    return GestureDetector(
      onTap: () => toPage(context, DetailScreen(product_id: model.id)),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: coverColor,
        ),
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
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 70,
                        height: 70,
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
                                  color: subColor.withValues(alpha: 0.7),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Text(
                              "₩ ${won(model.price)}",
                              style: TextStyle(
                                color: mainColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
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
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => showMessage("해당 기능은 준비 중입니다."),
                  child: Icon(Icons.edit_outlined, color: subColor, size: 25),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("내 등록 상품 삭제"),
                        content: Text("${model.albumName}을(를) 삭제하시겠습니까?"),
                        actions: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text("취소"),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final res = await productController.removeProduct(
                                model.id,
                              );
                              Navigator.pop(context);
                              if (res) load();
                            },
                            child: Text("삭제"),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Icon(
                    Icons.delete_outline_outlined,
                    color: Colors.red,
                    size: 25,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget noList() => Center(
    child: Text(
      '등록된 상품이 없습니다.',
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 22,
      ),
    ),
  );

  PreferredSizeWidget? appbar() => AppBar(
    backgroundColor: bgColor,
    surfaceTintColor: bgColor,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "내 등록 상품",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
        ),
        GestureDetector(
          onTap: () async{
            final res = await toPage<bool>(context, AddProductScreen());
            if(res == true)load();
          },
          child: Icon(Icons.add, color: Colors.white, size: 25),
        ),
      ],
    ),
  );
}
