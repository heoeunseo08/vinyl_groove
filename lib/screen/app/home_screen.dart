import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vinyl_groove_test4/controller/product_controller.dart';
import 'package:vinyl_groove_test4/model/product_model.dart';
import 'package:vinyl_groove_test4/screen/app/app_screen.dart';
import 'package:vinyl_groove_test4/screen/detail_screen.dart';
import 'package:vinyl_groove_test4/utils/info.dart';
import 'package:vinyl_groove_test4/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ProductController productController = ProductController();
  int selectSortIndex = 0;

  String? get sortCode => sortCodes(home: true).keys.elementAt(selectSortIndex);

  @override
  void initState() {
    super.initState();
    load();
  }

  load() async {
    await productController.loadList(limit: 10, sort: sortCode);
    setState(() {});
  }

  List<String> genrePath = [
    'rock.svg',
    'jazz.svg',
    'jazz.svg',
    'hip-hop.svg',
    'electronic.svg',
    'classical.svg',
    'rnb-soul.svg',
    'etc.svg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: RefreshIndicator(
            onRefresh: () async=> load(),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  appbar(),
                  SizedBox(height: 4),
                  search(),
                  SizedBox(height: 20),
                  genreSession(),
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

  Widget genreSession() {
    final genres = genreCodes.entries.toList();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "장르별 둘러보기",
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
            ),
            GestureDetector(
              onTap: () => toPage(context, AppScreen(index: 1)),
              behavior: HitTestBehavior.opaque,
              child: Row(
                spacing: 6,
                children: [
                  Text(
                    "전체 보기",
                    style: TextStyle(
                      color: subColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: subColor,
                    size: 15,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(
            genres.length,
            (index) {
              final entry = genres[index];

              return GestureDetector(
                onTap: () {
                  print(entry.key);
                  toPage(context, AppScreen(index: 1, genre: entry.key));
                },
                child: Container(
                  width: 87,
                  padding: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: coverColor),
                  ),
                  child: Column(
                    children: [
                      SvgPicture.asset("assets/icons/${genrePath[index]}"),
                      Text(
                        entry.value == 'Etc' ? '기타' : entry.value,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget cardSession() {
    final List<String> texts = sortCodes(home: true).values.toList();
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                spacing: 12,
                children: List.generate(
                  texts.length,
                  (index) {
                    final text = texts[index];
                    final select = index == selectSortIndex;

                    return GestureDetector(
                      onTap: () async {
                        selectSortIndex = index;
                        await load();
                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          border: select
                              ? Border(
                                  bottom: BorderSide(
                                    color: mainColor,
                                    width: 1.5,
                                  ),
                                )
                              : null,
                        ),
                        child: Text(
                          text,
                          style: TextStyle(
                            color: select ? Colors.white : subColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  "전체 보기",
                  style: TextStyle(color: subColor),
                ),
                Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: subColor,
                  size: 15,
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 12,
            children: List.generate(
              productController.productList.length,
              (index) {
                final model = productController.productList[index];

                return card(model);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget card(ProductModel model) {
    return GestureDetector(
      onTap: () => toPage(context, DetailScreen(product_id: model.id)),
      child: Container(
        width: 140,
        height: 220,
        decoration: BoxDecoration(
          color: coverColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 140,
              width: 140,
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

  Widget appbar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset("assets/simbol/logo_vertical.png", height: 60),
        GestureDetector(
          onTap: () => showMessage("해당 기능은 준비 중입니다."),
          child: SvgPicture.asset(
            "assets/icons/notification.svg",
            height: 25,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget search() {
    return GestureDetector(
      onTap: () => toPage(context, AppScreen(index: 1)),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: subColor.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 8,
              children: [
                Icon(
                  CupertinoIcons.search,
                  color: subColor,
                  size: 25,
                ),
                Text(
                  "앨범명, 아티스트 검색",
                  style: TextStyle(
                    color: subColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Icon(
              CupertinoIcons.barcode_viewfinder,
              color: subColor,
              size: 30
            ),
          ],
        ),
      ),
    );
  }

}
