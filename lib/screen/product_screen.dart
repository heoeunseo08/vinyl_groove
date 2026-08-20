import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vinyl_groove_test6/controller/product_controller.dart';
import 'package:vinyl_groove_test6/screen/add_screen.dart';
import 'package:vinyl_groove_test6/screen/detail_screen.dart';
import 'package:vinyl_groove_test6/uitls/info.dart';
import 'package:vinyl_groove_test6/uitls/utils.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  ProductController productController = ProductController();

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    await productController.load_myList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: RefreshIndicator(
          onRefresh: () => load(),
          child: productController.myProductList.isEmpty
              ? SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 350),
                      Center(
                        child: Text(
                          "등록된 상품이 없습니다.",
                          style: TextStyle(
                            color: subColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  itemBuilder: (context, index) {
                    return card(index);
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 14),
                  itemCount: productController.myProductList.length,
                ),
        ),
      ),
    );
  }

  Widget card(int index) {
    final model = productController.myProductList[index];
    final double size = 80.0;
    return GestureDetector(
      onTap: () async {
        toPage(context, DetailScreen(id: model.id));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 18),
        decoration: BoxDecoration(
          color: coverColor,
          borderRadius: BorderRadius.circular(12),
        ),
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
                  Column(
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
                              model.condition,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          Text(
                            '₩ ${won(model.price)}',
                            style: TextStyle(
                              color: mainColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Column(
              spacing: 12,
              children: [
                GestureDetector(
                  onTap: () {
                    showMessage(text: '수정 기능은 준비 중입니다.');
                  },
                  child: SvgPicture.asset(
                    "assets/icons/edit.svg",
                    height: 25,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  key: ValueKey('remove$index'),
                  onTap: () async {
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("내 등록 상품 삭제"),
                        content: Text("${model.albumName}을(를) 삭제하시겠습니까?"),
                        actions: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Text('최소'),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final res = await productController.delete(
                                model.id,
                              );
                              Navigator.pop(context);
                              if (res) load();
                            },
                            child: Text(
                              '삭제',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      "assets/icons/delete.svg",
                      width: 30,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  AppBar appbar() {
    return AppBar(
      leading: GestureDetector(
        key: ValueKey('back_1'),
        onTap: () => Navigator.pop(context),
        child: Icon(Icons.arrow_back,size: 30,),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "내 등록 상품",
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
          ),
          GestureDetector(
            onTap: () async {
              final res = await toPage(context, AddScreen());
              if (res) {
                load();
              }
            },
            child: Icon(
              Icons.add,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}
