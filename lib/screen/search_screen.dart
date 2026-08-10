import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove/controller/notif_controller.dart';
import 'package:vinyl_groove/controller/product_controller.dart';
import 'package:vinyl_groove/model/product_model.dart';
import 'package:vinyl_groove/screen/alarm_screen.dart';
import 'package:vinyl_groove/screen/detail_screen.dart';
import 'package:vinyl_groove/utils/info.dart';
import 'package:vinyl_groove/utils/utils.dart';
import 'package:vinyl_groove/utils/widget.dart';

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
  bool filterUpDown = false;

  @override
  void initState() {
    super.initState();
    if (widget.genre != null) {
      selectGenre.add(widget.genre!);
    }
    load();
  }

  Future<void> load({bool reset = true}) async {
    await productController.loadList(
      reset: reset,
      sort: selectSort,
      keyword: keyword_controller.text.trim(),
      genres: selectGenre.isEmpty ? null : selectGenre.toList(),
      conditions: selectCondition.isEmpty ? null : selectCondition.toList(),
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
              if(notification.metrics.pixels >= notification.metrics.maxScrollExtent - 300){
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
                  productController.isListLoading
                      ? loadingWidget()
                      : cardSession(),
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
          onTap: () => toPage(context, AlarmScreen()),
          child: ListenableBuilder(
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/icons/notification.svg",
                    color: Colors.white,
                    height: 28,
                  ),
                  if (notifController.unreadCount != 0)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        alignment: Alignment.center,
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          textAlign: TextAlign.center,
                          notifController.unreadCount > 9
                              ? '9+'
                              : '${notifController.unreadCount}',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    ),
                ],
              );
            },
            listenable: notifController,
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
          onChanged: (value) => setState(() {}),
          onFieldSubmitted: (value) async {
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
                  onTap: () => showMessage("준비 중입니다."),
                  child: SvgPicture.asset(
                    "assets/icons/barcode-scan.svg",
                    color: Colors.white,
                    height: 25,
                  ),
                ),
              ],
            ),
            hint: Text(
              "앨범명, 아티스트 검색",
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
                codes: genresCode,
                selectItem: selectGenre,
              ),
              selectChips(
                title: '음반 상태',
                codes: conditionCode,
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
            child: Row(
              spacing: 8,
              children: [
                chip(
                  text: "전체",
                  select: selectItem.isEmpty,
                  onTap: () async {
                    setState(() => selectItem.clear());
                    await load();
                  },
                ),
                ...codes.entries.map(
                  (e) => chip(
                    text: e.value,
                    select: selectItem.contains(e.key),
                    onTap: () async {
                      setState(
                        () => selectItem.contains(e.key)
                            ? selectItem.remove(e.key)
                            : selectItem.add(e.key),
                      );
                      await load();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget chip({
    required String text,
    required bool select,
    required GestureTapCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: select ? mainColor : coverColor,
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: select ? Colors.black : Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
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
            ...tradeMethodCode.entries.map(
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
        Wrap(
          runSpacing: 10,
          spacing: 10,
          children: List.generate(
            productController.productList.length,
            (index) {
              final model = productController.productList[index];
              return card(model);
            },
          ),
        ),
      ],
    );
  }

  Widget card(ProductModel model) {
    final won = NumberFormat('#,###').format(model.price);

    return GestureDetector(
      onTap: () => toPage(context, DetailScreen(product_id: model.id)),
      child: Container(
        width: 120,
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
                    width: 120,
                    height: 110,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 120,
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
                  child: favoriteWidget(id: model.id),
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
        return sortCode(search: true).entries
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
            sortCode(search: true)[selectSort]!,
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
