import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_test3/controller/alarm_controller.dart';
import 'package:vinyl_groove_test3/controller/product_controller.dart';
import 'package:vinyl_groove_test3/model/product_model.dart';
import 'package:vinyl_groove_test3/screen/alarm_screen.dart';
import 'package:vinyl_groove_test3/screen/barcode_screen.dart';
import 'package:vinyl_groove_test3/screen/detail_screen.dart';
import 'package:vinyl_groove_test3/utils/info.dart';
import 'package:vinyl_groove_test3/utils/util.dart';
import 'package:vinyl_groove_test3/utils/widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.genre});

  final String? genre;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  ProductController productController = ProductController();
  TextEditingController keyword_controller = TextEditingController();
  Set<String> selectGenre = {};
  Set<String> selectCondition = {};
  String? selectTradeMethod;
  RangeValues price = const RangeValues(1000, 1000000);
  String selectSort = 'recent';
  bool filterUpDown = true;

  @override
  void initState() {
    super.initState();
    if (widget.genre != null) {
      selectGenre = {widget.genre!};
    }
    load();
  }

  Future<void> load({bool reset = true}) async {
    await productController.loadList(
      reset: reset,
      size: 12,
      sort: selectSort,
      keyword: keyword_controller.text.trim(),
      genres: selectGenre.isEmpty ? null : selectGenre.toList().join(','),
      conditions: selectCondition.isEmpty
          ? null
          : selectCondition.toList().join(','),
      tradeMethod: selectTradeMethod,
      minPrice: price.start.round(),
      maxPrice: price.end >= 1000000 ? null : price.end.round(),
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
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent) {
                loadMore();
              }
              return false;
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  appbar(),
                  SizedBox(height: 12),
                  input(),
                  SizedBox(height: 12),
                  cardSession(),
                  if (productController.isListLoading) loadingWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget appbar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          "assets/simbol/logo_vertical.png",
          height: 50,
        ),
        GestureDetector(
          onTap: () => toPage(context: context, page: AlarmScreen()),
          child: SizedBox(
            width: 30,
            height: 30,
            child: Stack(
              alignment: .center,
              children: [
                SvgPicture.asset(
                  "assets/icons/notification.svg",
                  color: Colors.white,
                  height: 25,
                ),
                if (alarmController.unreadCount != 0)
                  Positioned(
                    top: 2,
                    right: 0,
                    child: Container(
                      alignment: Alignment.center,
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        textAlign: .center,
                        alarmController.unreadCount > 8
                            ? '9+'
                            : '${alarmController.unreadCount}',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget input() {
    return Column(
      children: [
        TextFormField(
          controller: keyword_controller,
          onChanged: (value) async {
            setState(() {});
            await load();
          },
          decoration: InputDecoration(
            border: border(coverColor),
            disabledBorder: border(coverColor),
            focusedBorder: border(coverColor),
            enabledBorder: border(coverColor),
            prefixIcon: Icon(CupertinoIcons.search, color: subColor),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (keyword_controller.text.trim().isNotEmpty)
                  GestureDetector(
                    onTap: () async {
                      setState(() => keyword_controller.text = '');
                      await load();
                    },
                    child: Icon(
                      Icons.clear,
                      color: subColor,
                    ),
                  ),
                GestureDetector(
                  onTap: () async {
                    final barcode = await toPage<String>(
                      context: context,
                      page: BarcodeScreen(),
                    );
                    if (barcode == null) return;
                    final barcode_controller = ProductController();
                    await barcode_controller.loadList(barcode: barcode);
                    if (barcode_controller.productList.isNotEmpty) {
                      toPage(
                        context: context,
                        page: DetailScreen(
                          product_id: barcode_controller.productList.first.id,
                        ),
                      );
                    } else {
                      showMessage("바코드 $barcode에 해당하는 상품을 찾을 수 없습니다");
                    }
                  },
                  child: SvgPicture.asset(
                    svgPath('barcode-scan.svg'),
                    color: subColor,
                    height: 30,
                    width: 30,
                  ),
                ),
              ],
            ),
            hint: Text(
              "앨범명, 아티스트",
              style: TextStyle(
                color: subColor,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          ),
        ),
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
                  selectGenre = {};
                  selectCondition = {};
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
              ),
              selectChips(
                title: '음반 상태',
                codes: conditionCodes,
                selectItem: selectCondition,
              ),
              selectPrice(),
              selectTradeMethods(),
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
        Divider(color: subColor.withOpacity(0.2)),
      ],
    );
  }

  Widget selectChips({
    required String title,
    required Map<String, String> codes,
    required Set<String> selectItem,
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
              select: (String key) => selectItem.contains(key),
              onTap: (String key) async {
                setState(
                  () => selectItem.contains(key)
                      ? selectItem.remove(key)
                      : selectItem.add(key),
                );
                await load();
              },
              showAll: true,
              allSelect: () => selectItem.isEmpty,
              onAllTap: () async{
                setState(() => selectItem.clear());
                await load();
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget selectPrice() {
    String min = NumberFormat('#,###').format(price.start);
    String max = NumberFormat('#,###').format(price.end);

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
            "₩$min",
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
            price.end == 1000000 ? "₩1,000,000+" : "₩$max",
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

  Widget selectTradeMethods() {
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Text(
            '거래 방식',
            style: TextStyle(
              color: subColor,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
        Row(
          spacing: 8,
          children: [
            chip(
              text: "전체",
              select: selectTradeMethod == null,
              onTap: () async {
                setState(() => selectTradeMethod = null);
                await load();
              },
            ),
            ...tradeMethodCodes.entries.map(
              (e) => chip(
                text: e.value,
                select: selectTradeMethod == e.key,
                onTap: () async {
                  setState(() => selectTradeMethod = e.key);
                  await load();
                },
              ),
            ),
          ],
        ),
      ],
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
            sortButton(),
          ],
        ),
        SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final double width = (constraints.maxWidth - 10 * 2) / 3;
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
                  return card(model, width,index);
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget card(ProductModel model, double width,int index) {
    final won = NumberFormat('#,###').format(model.price);

    return GestureDetector(
      key: ValueKey('item$index'),
      onTap: () => toPage(
        context: context,
        page: DetailScreen(product_id: model.id),
      ),
      child: Container(
        width: width,
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
                    width: width,
                    height: 110,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: width,
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
                  child: favoriteButton(id: model.id),
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
                    "₩ $won",
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

  Widget sortButton() {
    return PopupMenuButton<String>(
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
    );
  }
}
