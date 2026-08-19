import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vinyl_groove_test5/controller/alarm_controller.dart';
import 'package:vinyl_groove_test5/controller/product_controller.dart';
import 'package:vinyl_groove_test5/screen/alarm_screen.dart';
import 'package:vinyl_groove_test5/screen/barcode_screen.dart';
import 'package:vinyl_groove_test5/screen/detail_screen.dart';
import 'package:vinyl_groove_test5/utils/info.dart';
import 'package:vinyl_groove_test5/utils/utils.dart';
import 'package:vinyl_groove_test5/utils/widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.genre});

  final String? genre;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  ProductController productController = ProductController();
  TextEditingController keyword_controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  String select_sort = 'recent';

  Set<String> select_genre ={};
  Set<String> select_condition ={};
  RangeValues price = RangeValues(1000, 1000000);
  String? select_tradeMethod;

  bool isFilter = true;

  bool get loading => productController.isListLoading;

  @override
  void initState() {
    super.initState();
    if (widget.genre != null) select_genre = {widget.genre!};
    scrollController.addListener(more_load);
    load();
  }

  Future<void> load({bool reset = true}) async {
    await productController.loadList(
      reset: reset,
      size: 12,
      sort: select_sort,
      genres: select_genre.toList().join(','),
      conditions: select_condition.toList().join(','),
      tradeMethod: select_tradeMethod,
      minPrice: price.start.round(),
      maxPrice: price.end.round(),
      keyword: keyword_controller.text.trim(),
    );
    setState(() {});
  }

  Future<void> more_load() async {
    if (!productController.hasNext || productController.isListLoading) return;
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent) {
      await load(reset: false);
      setState(() {});
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(more_load);
    scrollController.dispose();
    keyword_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                appbar(),
                SizedBox(height: 20),
                field(),
                SizedBox(height: 20),
                filter(),
                SizedBox(height: 30),
                result(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget field() {
    return TextFormField(
      controller: keyword_controller,
      onChanged: (value) {
        load();
        setState(() {});
      },
      decoration: InputDecoration(
        border: border(subColor.withValues(alpha: 0.3)),
        focusedBorder: border(mainColor),
        focusedErrorBorder: border(mainColor),
        enabledBorder: border(subColor.withValues(alpha: 0.3)),
        disabledBorder: border(subColor.withValues(alpha: 0.3)),
        hint: Text(
          '앨범명, 아티스트',
          style: TextStyle(
            color: subColor,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        prefixIcon: Icon(
          CupertinoIcons.search,
          color: subColor,
          size: 28,
        ),
        suffixIcon: Row(
          mainAxisSize: .min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (keyword_controller.text.isNotEmpty)
              GestureDetector(
                onTap: () {
                  setState(() => keyword_controller.text = '');
                  load();
                },
                child: Icon(
                  Icons.close,
                  color: subColor,
                  size: 28,
                ),
              ),
            GestureDetector(
              onTap: () async {
                final barcode = await topage<String>(
                  context,
                  BarcodeScreen(),
                );
                if (barcode == null) return;
                final barcode_controller = ProductController();
                await barcode_controller.loadList(barcode: barcode);
                if (barcode_controller.productList.isNotEmpty) {
                  topage(
                    context,
                    DetailScreen(
                      id: barcode_controller.productList.first.id,
                    ),
                  );
                } else {
                  showMessage("바코드 $barcode에 해당하는 상품을 찾을 수 없습니다");
                }
              },
              child: SvgPicture.asset(
                "assets/icons/barcode-scan.svg",
                color: subColor,
                width: 28,
              ),
            ),
            SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

  Widget filter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 8,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 6,
              children: [
                Icon(
                  Icons.tune,
                  color: subColor,
                  size: 20,
                ),
                Text(
                  '필터',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            GestureDetector(
              onTap: () async {
                setState(() {
                  keyword_controller.text = '';
                  select_genre = {};
                  select_condition = {};
                  price = RangeValues(1000, 1000000);
                  select_tradeMethod = null;
                });
                await load();
                setState(() {});
              },
              child: Text(
                '필터 초기화',
                style: TextStyle(
                  color: mainColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        if (isFilter)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [
              items(
                text: '장르',
                item: chipWrap(
                  codes: genreCodes,
                  select: (key) => select_genre.contains(key),
                  onTap: (key) async {
                    select_genre.add(key);
                    await load();
                    setState(() {});
                  },
                  showAll: true,
                  AllSelect: () => select_genre.isEmpty,
                  AllOnTap: () async {
                    select_genre.clear();
                    await load();
                    setState(() {});
                  },
                ),
              ),
              items(
                text: '음반 상태',
                item: chipWrap(
                  codes: conditionCodes,
                  select: (key) => select_condition.contains(key),
                  onTap: (key) async {
                    select_condition.add(key);
                    await load();
                    setState(() {});
                  },
                  showAll: true,
                  AllSelect: () => select_condition.isEmpty,
                  AllOnTap: () async {
                    select_condition.clear();
                    await load();
                    setState(() {});
                  },
                ),
              ),
              select_price(),
              items(
                text: '거래 방식',
                item: chipWrap(
                  codes: tradeMethodCodes,
                  select: (key) => select_tradeMethod == key,
                  onTap: (key) async {
                    select_tradeMethod = key;
                    await load();
                    setState(() {});
                  },
                  showAll: true,
                  AllSelect: () => select_tradeMethod == null,
                  AllOnTap: () async {
                    select_tradeMethod = null;
                    await load();
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        GestureDetector(
          onTap: () => setState(() => isFilter = !isFilter),
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisAlignment: .center,
            children: [
              Text(
                isFilter ? '접기' : '펼치기',
                style: TextStyle(color: subColor, fontSize: 12),
              ),
              Icon(
                isFilter
                    ? Icons.keyboard_arrow_up_outlined
                    : Icons.keyboard_arrow_down,
                color: subColor,
                size: 20,
              ),
            ],
          ),
        ),
        Divider(color: subColor.withValues(alpha: 0.1)),
      ],
    );
  }

  Widget items({required String text, required Widget item}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
            width: 60,
            child: Text(
              text,
              style: TextStyle(
                color: subColor,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
          item,
        ],
      ),
    );
  }

  Widget select_price() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 30,
          width: 60,
          child: Text(
            '가격 범위',
            style: TextStyle(
              color: subColor,
              fontWeight: FontWeight.w500,
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

  Widget result() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "검색 결과 ${productController.total_items} 개",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            PopupMenuButton<String>(
              onSelected: (value) async {
                select_sort = value;
                await load();
                setState(() {});
              },
              child: Row(
                children: [
                  Text(
                    sortCodes()[select_sort]!,
                    style: TextStyle(color: subColor, fontSize: 13),
                  ),
                  Icon(Icons.arrow_drop_down, color: subColor, size: 20),
                ],
              ),
              itemBuilder: (context) => sortCodes().entries
                  .map(
                    (e) => PopupMenuItem<String>(
                      value: e.key,
                      child: Text(
                        e.value,
                        style: TextStyle(color: subColor),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
        SizedBox(height: 20),
        if (loading) LoadingWidget(),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          spacing: 8,
          runSpacing: 10,
          runAlignment: WrapAlignment.start,
          children: List.generate(
            productController.productList.length,
            (index) => card(index),
          ),
        ),
      ],
    );
  }

  Widget card(int index) {
    final model = productController.productList[index];
    final double wid = 120;

    return GestureDetector(
      key: ValueKey('item$index'),
      onTap: () => topage(context, DetailScreen(id: model.id)),
      child: Container(
        width: wid,
        height: 200,
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
                    width: wid,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: wid,
                      height: 120,
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
                  top: 0,
                  right: 0,
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

  Widget appbar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          "assets/simbol/logo_vertical.png",
          height: 50,
        ),
        GestureDetector(
          onTap: () => topage(context, AlarmScreen()),
          child: Stack(
            alignment: .center,
            children: [
              SvgPicture.asset(
                "assets/icons/notification.svg",
                color: Colors.white,
                height: 25,
              ),
              if (alarmController.unreadCount.value > 0)
                Positioned(
                  top: -2,
                  right: 0,
                  child: Container(
                    alignment: .center,
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: ValueListenableBuilder(
                      valueListenable: alarmController.unreadCount,
                      builder: (context, value, child) {
                        String text = alarmController.unreadCount.value > 9
                            ? '9+'
                            : '${alarmController.unreadCount.value}';
                        return Text(
                          textAlign: .center,
                          text,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
