import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vinyl_groove_test4/controller/product_controller.dart';
import 'package:vinyl_groove_test4/model/product_model.dart';
import 'package:vinyl_groove_test4/screen/barcode_screen.dart';
import 'package:vinyl_groove_test4/screen/detail_screen.dart';
import 'package:vinyl_groove_test4/utils/info.dart';
import 'package:vinyl_groove_test4/utils/utils.dart';
import 'package:vinyl_groove_test4/utils/widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.genre});

  final String? genre;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  ProductController productController = ProductController();
  ProductController barcodeController = ProductController();
  TextEditingController keyword_controller = TextEditingController();
  String? selectGenre;
  String? selectCondition;
  String? selectTradeMethod;
  RangeValues price = const RangeValues(1000, 1000000);
  String selectSort = 'recent';
  bool filterUpDown = true;
  String? barcode;

  @override
  void initState() {
    super.initState();
    if (widget.genre != null) {
      selectGenre = widget.genre!;
    }
    load();
  }

  Future<void> load({bool reset = true}) async {
    await productController.loadList(
      reset: reset,
      size: 12,
      sort: selectSort,
      keyword: keyword_controller.text.trim(),
      genres: selectGenre,
      conditions: selectCondition,
      tradeMethod: selectTradeMethod,
      minPrice: price.start.round(),
      maxPrice: price.end >= 1000000 ? null : price.end.round(),
      barcode: barcode,
    );
    setState(() {});
  }

  Future<void> loadMore() async {
    if (!productController.hasNext || productController.isListLoading) return;

    load(reset: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent) {
                loadMore();
              }
              return false;
            },
            child: RefreshIndicator(
              onRefresh: () async => load(),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    appbar(context),
                    SizedBox(height: 4),
                    search(),
                    SizedBox(height: 20),
                    filter(),
                    SizedBox(height: 20),
                    cardSession(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget cardSession() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '검색결과 ${productController.total_items}개',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            PopupMenuButton<String>(
              color: coverColor,
              onSelected: (value) async {
                setState(() => selectSort = value);
                await load();
              },
              itemBuilder: (context) {
                return sortCodes().entries
                    .map(
                      (e) => PopupMenuItem<String>(
                        value: e.key,
                        child: Text(
                          e.value,
                          style: TextStyle(color: subColor, fontSize: 12),
                        ),
                      ),
                    )
                    .toList();
              },
              child: Row(
                children: [
                  Text(
                    sortCodes()[selectSort]!,
                    style: TextStyle(color: subColor, fontSize: 12),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: subColor,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            return Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              runAlignment: WrapAlignment.start,
              runSpacing: 10,
              spacing: 10,
              children: List.generate(
                productController.productList.length,
                (index) {
                  final model = productController.productList[index];
                  return card(model, index);
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget card(ProductModel model, int index) {
    return GestureDetector(
      onTap: () => toPage(
        context,
        DetailScreen(product_id: model.id),
      ),
      child: Container(
        width: 119,
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: coverColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    model.albumImage,
                    width: 119,
                    height: 110,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 119,
                      height: 110,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: coverColor,
                    ),
                    child: Text(
                      model.condition,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: favorite_button(id: model.id),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.albumName,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    model.artist,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                      color: subColor,
                    ),
                  ),
                  Text(
                    "₩ ${won(model.price)}",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: mainColor,
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

  Widget search() {
    return TextFormField(
      controller: keyword_controller,
      onChanged: (value) async {
        setState(() {});
        await load();
      },
      decoration: InputDecoration(
        border: border(subColor.withValues(alpha: 0.4)),
        disabledBorder: border(subColor.withValues(alpha: 0.4)),
        enabledBorder: border(subColor.withValues(alpha: 0.4)),
        focusedBorder: border(subColor.withValues(alpha: 0.4)),
        hint: Text(
          "앨범명, 아티스트",
          style: TextStyle(
            color: subColor.withValues(alpha: 0.5),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        prefixIcon: Icon(CupertinoIcons.search, color: subColor, size: 25),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (keyword_controller.text.trim().isNotEmpty)
              GestureDetector(
                onTap: () async {
                  setState(() => keyword_controller.text = '');
                  await load();
                  setState(() {});
                },
                child: Icon(Icons.close, size: 25),
              ),
            GestureDetector(onTap: () async {
              final scannedBarcode = await toPage<String?>(context, BarcodeScreen());
              if (scannedBarcode != null && scannedBarcode.isNotEmpty) {
                await barcodeController.loadList(barcode: scannedBarcode, reset: true);
                if (!mounted) return;

                if (barcodeController.productList.isNotEmpty) {
                  final id = barcodeController.productList.first.id;
                  toPage(context, DetailScreen(product_id: id));
                } else {
                  showMessage("$scannedBarcode에 해당하는 상품을 찾을 수 없습니다");
                }
              }
            },
              child: SvgPicture.asset(
                "assets/icons/barcode-scan.svg",
                color: subColor,
                height: 25,
              ),
            ),
            SizedBox(width: 12),
          ],
        ),
      ),
    );
  }

  Widget filter() {
    return Column(
      children: [
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.tune,
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  "필터",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
              ],
            ),
            GestureDetector(
              onTap: () async {
                setState(() {
                  selectGenre = null;
                  selectCondition = null;
                  selectTradeMethod = null;
                  price = const RangeValues(1000, 1000000);
                });
                await load();
              },
              child: Text(
                "필터 초기화",
                style: TextStyle(
                  color: mainColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        if (filterUpDown)
          Column(
            spacing: 10,
            children: [
              SizedBox(),
              selectChips(
                title: '장르',
                codes: genreCodes,
                selectItem: selectGenre,
                onSelect: (value) => selectGenre = value,
              ),
              selectChips(
                title: '음반 상태',
                codes: conditionCodes,
                selectItem: selectCondition,
                onSelect: (value) => selectCondition = value,
              ),
              selectPrice(),
              selectChips(
                title: '거래 방식',
                codes: tradeMethodCodes,
                selectItem: selectTradeMethod,
                onSelect: (String? value) => selectTradeMethod = value,
              ),
              SizedBox(),
            ],
          ),
        GestureDetector(
          onTap: () => setState(() => filterUpDown = !filterUpDown),
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                filterUpDown ? "접기" : "펼치기",
                style: TextStyle(
                  color: subColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
              SizedBox(width: 4),
              Icon(
                filterUpDown
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: subColor,
                size: 16,
              ),
            ],
          ),
        ),
        Divider(color: subColor.withValues(alpha: 0.2)),
      ],
    );
  }

  Widget selectChips({
    required String title,
    required Map<String, String> codes,
    required String? selectItem,
    required Function(String? value) onSelect,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Text(
            title,
            style: TextStyle(
              color: subColor,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: chipWrap(
              codes: codes,
              select: (String key) => selectItem == key,
              onTap: (String key) async {
                setState(() => onSelect(key));
                await load();
              },
              showAll: true,
              allSelect: () => selectItem == null,
              allTap: () async {
                setState(() => onSelect(null));
                await load();
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget selectPrice() {
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Text(
            '가격 범위',
            style: TextStyle(
              color: subColor,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: coverColor,
            borderRadius: BorderRadius.circular(99),
          ),
          child: Text(
            "₩${won(price.start)}",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          child: RangeSlider(
            values: price,
            min: 1000,
            max: 1000000,
            activeColor: mainColor,
            onChanged: (value) => setState(() => price = value),
            onChangeEnd: (value) async => await load(),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: coverColor,
            borderRadius: BorderRadius.circular(99),
          ),
          child: Text(
            price.end == 1000000 ? "₩1,000,000+" : "₩${won(price.end)}",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
