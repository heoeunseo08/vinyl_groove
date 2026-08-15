import 'package:flutter/material.dart';
import 'package:vinyl_groove2/controller/product_controller.dart';
import 'package:vinyl_groove2/model/product_model.dart';
import 'package:vinyl_groove2/screen/detail_screen.dart';
import 'package:vinyl_groove2/urils/info.dart';
import 'package:vinyl_groove2/urils/util.dart';
import 'package:vinyl_groove2/urils/widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.genre});

  final String? genre;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  ProductController productController = ProductController();
  TextEditingController keyword_controller = TextEditingController();

  String? selectGenre;
  String? selectCondition;
  String? selectTradeMethod;
  RangeValues price = RangeValues(1000, 1000000);
  String selectSort = 'recent';

  @override
  void initState() {
    super.initState();
    if (widget.genre != null) selectGenre = widget.genre!;

    load();
  }

  load({bool reset = true}) async {
    await productController.listLoad(
      reset: reset,
      sort: selectSort,
      keyword: keyword_controller.text.trim(),
      genres: selectGenre,
      conditions: selectCondition,
      tradeMethod: selectTradeMethod,
      minPrice: price.start.toInt(),
      maxPrice: price.end.toInt(),
    );
    setState(() {});
  }

  Future<void> loadMore() async {
    if (!productController.hasNext) return;
    await load(reset: false);
  }

  @override
  void dispose() {
    keyword_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent - 300)
                loadMore();
              return false;
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  appBar1(),
                  SizedBox(height: 4),
                  filter(),
                  SizedBox(height: 20),
                  cardSession(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget filter() {
    return Column(
      children: [],
    );
  }

  Widget cardSession() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              "검색 결과 ${productController.totalCount}개",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            PopupMenuButton<String>(
              onSelected: (value) async {
                setState(() => selectSort = value);
                load();
              },
              itemBuilder: (context) {
                return sortCodes().entries.map(
                  (e) {
                    return PopupMenuItem<String>(
                      value: e.key,
                      child: Text(
                        e.value,
                        style: TextStyle(
                          color: subColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    );
                  },
                ).toList();
              },
              child: Row(
                children: [
                  Text(
                    sortCodes()[selectSort]!,
                    style: TextStyle(
                      color: subColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: subColor,
                    size: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        if (productController.isListLoading) loadingWidget(),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(
            productController.model_list.length,
            (index) {
              final model = productController.model_list[index];

              return card(model);
            },
          ),
        ),
        if (productController.isListLoading) loadingWidget(),
      ],
    );
  }

  Widget card(ProductModel model) {
    return GestureDetector(
      onTap: () => toPage(context, DetailScreen(index: model.id)),
      child: Container(
        width: 120,
        height: 200,
        decoration: BoxDecoration(
          color: coverColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 120,
              width: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Image.network(model.albumImage, fit: BoxFit.fill),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                      decoration: BoxDecoration(
                        color: coverColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        model.condition,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.albumName,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    model.artist,
                    style: TextStyle(
                      color: subColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    won(model.price),
                    style: TextStyle(
                      color: mainColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
