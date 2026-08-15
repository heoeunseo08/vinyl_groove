import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vinyl_groove2/controller/product_controller.dart';
import 'package:vinyl_groove2/model/product_model.dart';
import 'package:vinyl_groove2/screen/app/app_screen.dart';
import 'package:vinyl_groove2/screen/detail_screen.dart';
import 'package:vinyl_groove2/urils/info.dart';
import 'package:vinyl_groove2/urils/util.dart';
import 'package:vinyl_groove2/urils/widget.dart';

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
    await productController.listLoad(limit: 10, sort: sortCode);
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
          child: Column(
            children: [
              appBar1(),
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
    );
  }

  Widget search() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => toPage(context, AppScreen(index: 1)),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: coverColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(CupertinoIcons.search, color: subColor, size: 25),
                SizedBox(width: 8),
                Text(
                  '앨범명, 아티스트 검색',
                  style: TextStyle(
                    color: subColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            Icon(CupertinoIcons.barcode_viewfinder, color: subColor, size: 25),
          ],
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
            Row(
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
              productController.model_list.length,
              (index) {
                final model = productController.model_list[index];

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
      onTap: () => toPage(context, DetailScreen(index: model.id)),
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
}
