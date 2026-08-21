import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vinyl_groove_test7/controller/product_controller.dart';
import 'package:vinyl_groove_test7/screen/app/home_screen.dart';
import 'package:vinyl_groove_test7/screen/detail_screen.dart';
import 'package:vinyl_groove_test7/utils/info.dart';
import 'package:vinyl_groove_test7/utils/utils.dart';
import 'package:vinyl_groove_test7/utils/widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.genre});

  final String? genre;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>{
  TextEditingController keyword_controller = TextEditingController();
  ProductController productController = ProductController();
  final ScrollController scrollController = ScrollController();

  String select_sort = 'popular';

  String? select_genre;
  String? select_conditions;
  String? select_tradeMethod;
  RangeValues price = RangeValues(1000, 1000000);

  bool up = true;

  @override
  void initState() {
    super.initState();
    if (widget.genre != null) select_genre = widget.genre!;
    scrollController.addListener(more);
    load();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.removeListener(more);
    keyword_controller.dispose();
    scrollController.dispose();
  }

  Future<void> load({bool reset = true}) async {
    await productController.load(
      sort: select_sort,
      keyword: keyword_controller.text.trim(),
      genre: select_genre,
      condition: select_conditions,
      tradeMethod: select_tradeMethod,
      minPrice: price.start.round(),
      maxPrice: price.end.round(),
      size: 12,
      reset: reset,
    );
    setState(() {});
  }

  Future<void> more() async {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent)
      await load(reset: false);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: appbar(),
      ),
      body: Padding(
        padding: .symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(height: 14),
            field(),
            SizedBox(height: 14),
            filter(),
            SizedBox(height: 14),
            Expanded(child: card_sesssion()),
          ],
        ),
      ),
    );
  }

  Widget filter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Row(
              spacing: 8,
              children: [
                Icon(Icons.tune, color: subColor, size: 18),
                Text(
                  '펄터',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () async {
                setState(() {
                  select_genre = '';
                  select_conditions = '';
                  select_tradeMethod = '';
                  price = RangeValues(1000, 1000000);
                });
                await load();
              },
              child: Text(
                '펄터 초기화',
                style: TextStyle(
                  color: mainColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 14),
        if (up)
          Column(
            spacing: 8,
            children: [
              filter_chips(
                text: '장르',
                codes: genre_codes(),
                select: select_genre,
                onTap: (value) => select_genre = value,
              ),
              filter_chips(
                text: '음반 상태',
                codes: condition_codes(),
                select: select_conditions,
                onTap: (value) => select_conditions = value,
              ),
              filter_price(),
              filter_chips(
                text: '거래 방식',
                codes: tradeMethod_codes(),
                select: select_tradeMethod,
                onTap: (value) => select_tradeMethod = value,
              ),
            ],
          ),
        SizedBox(height: 14),
        GestureDetector(
          onTap: () => setState(() => up = !up),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                up ? '졉기' : '펼치기',
                style: TextStyle(color: subColor),
              ),
              Icon(
                up
                    ? Icons.keyboard_arrow_up_outlined
                    : Icons.keyboard_arrow_down_outlined,
                size: 15,
                color: subColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget filter_chips({
    required String text,
    required Map<String, String> codes,
    required String? select,
    required void Function(String? value) onTap,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Text(text),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: chips(
              codes: codes,
              select: (key) => select == key,
              onTap: (key) async {
                onTap(key);
                await load();
                setState(() {});
              },
              all: true,
              all_select: () => select == null,
              all_onTap: () async {
                onTap(null);
                await load();
                setState(() {});
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget filter_price() {
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Text('가격 범위'),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(99),
            color: coverColor,
          ),
          child: Text(
            '₩ ${won(price.start)}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: RangeSlider(
            values: price,
            min: 1000,
            max: 1000000,

            onChanged: (value) => setState(() => price = value),
            onChangeEnd: (value) async {
              await load();
              setState(() {});
            },
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(99),
            color: coverColor,
          ),
          child: Text(
            price.end >= 1000000 ? '₩${won(price.end)}+' : '₩${won(price.end)}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget field() {
    return TextFormField(
      controller: keyword_controller,
      onChanged: (value) async {
        setState(() {});
        await load();
      },
      decoration: InputDecoration(
        border: border(subColor.withValues(alpha: 0.5)),
        disabledBorder: border(subColor.withValues(alpha: 0.5)),
        enabledBorder: border(subColor.withValues(alpha: 0.5)),
        focusedBorder: border(subColor.withValues(alpha: 0.5)),
        hint: Text(
          '앨범명, 아티스트',
          style: TextStyle(color: subColor, fontSize: 16),
        ),
        prefixIcon: Icon(CupertinoIcons.search, color: subColor, size: 25),
        suffixIcon: Row(
          mainAxisSize: .min,
          children: [
            if (keyword_controller.text.isNotEmpty)
              GestureDetector(
                onTap: () => setState(() => keyword_controller.text = ''),
                child: Icon(Icons.close, color: subColor, size: 25),
              ),
            GestureDetector(
              onTap: () => show_message(),
              child: Icon(
                CupertinoIcons.barcode_viewfinder,
                color: subColor,
                size: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget card(int index) {
    final model = productController.product_list[index];
    final double size = 120;
    return GestureDetector(
      onTap: () => toPage(context, DetailScreen(id: model.id)),
      child: Container(
        width: size,
        height: size + 80,
        decoration: BoxDecoration(
          color: coverColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            SizedBox(
              width: size,
              height: size,
              child: Stack(
                alignment: .topCenter,
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    child: ClipRRect(
                      borderRadius: .vertical(top: Radius.circular(12)),
                      child: Image.network(
                        model.albumImage,
                        width: size,
                        height: size,
                        alignment: .topCenter,
                        fit: .cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: size,
                          height: size,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: coverColor,
                      ),
                      child: Text(
                        model.condition,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    model.albumName,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
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
                    '₩ ${won(model.price)}',
                    style: TextStyle(
                      color: mainColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
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

  Widget card_sesssion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: .spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '검색 결과 ${productController.totalCount}개',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            PopupMenuButton(
              child: Row(
                children: [
                  Text(
                    sort_codes()[select_sort]!,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: subColor,
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    size: 15,
                    color: subColor,
                  ),
                ],
              ),
              onSelected: (value) async{
                setState(() {
                  select_sort = value;
                });
                await load();
              },
              itemBuilder: (context) {
                return List.generate(
                  sort_codes().length,
                  (index) => PopupMenuItem(
                    value: sort_codes().keys.elementAt(index),
                    child: Text(
                      sort_codes().values.elementAt(index),
                      style: TextStyle(color: subColor, fontSize: 14),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        SizedBox(height: 18),
        Expanded(
          child: SingleChildScrollView(
            controller: scrollController,

            child: Wrap(
              spacing: 8,
              runSpacing: 12,
              children: List.generate(
                productController.product_list.length,
                (index) {
                  return card(index);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
