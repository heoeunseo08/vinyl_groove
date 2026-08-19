import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vinyl_groove_test5/controller/product_controller.dart';
import 'package:vinyl_groove_test5/screen/app/app_screen.dart';
import 'package:vinyl_groove_test5/screen/detail_screen.dart';
import 'package:vinyl_groove_test5/utils/info.dart';
import 'package:vinyl_groove_test5/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ProductController productController = ProductController();

  String select_sort = 'popular';

  int select_tab = 0;

  List<String> genres = [
    "assets/icons/genre/rock.svg",
    "assets/icons/genre/jazz.svg",
    "assets/icons/genre/pop.svg",
    "assets/icons/genre/hip-hop.svg",
    "assets/icons/genre/electronic.svg",
    "assets/icons/genre/classical.svg",
    "assets/icons/genre/rnb-soul.svg",
    "assets/icons/genre/etc.svg",
  ];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    await productController.loadList(limit: 10, sort: select_sort);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(),
      body: RefreshIndicator(
        onRefresh: () => load(),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                search(),
                SizedBox(height: 25),
                genre(),
                SizedBox(height: 25),
                tabs(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget tabs() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 14,
              children: sortCodes(home: true).entries.map(
                (e) {
                  bool select = select_sort == e.key;

                  return GestureDetector(
                    onTap: () async{
                      setState(() => select_sort = e.key);
                      await load();
                    },
                    child: AnimatedContainer(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      duration: Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: select ? mainColor : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        e.value,
                        style: TextStyle(
                          fontWeight: select ? FontWeight.w800 : FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
            Row(
              spacing: 6,
              children: [
                Text(
                  '전체 보기',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: subColor,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 12,
                  color: subColor,
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 25),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 12,
            children: List.generate(
              productController.productList.length,
              (index) => card(index),
            ),
          ),
        ),
      ],
    );
  }

  Widget card(int index) {
    final model = productController.productList[index];
    final double width = 140;
    return GestureDetector(
      onTap: () => topage(context, DetailScreen(id: model.id)),
      child: Container(
        decoration: BoxDecoration(
          color: coverColor,
          borderRadius: BorderRadius.circular(12),
        ),
        width: width,
        height: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: .center,
              children: [
                ClipRRect(
                  borderRadius: .vertical(top: Radius.circular(12)),
                  child: Image.network(
                    width: width,
                    height: width,
                    model.albumImage,
                    fit: .cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: width,
                      width: width,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.black,
                    ),
                    child: Text(
                      model.condition,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: .symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 6,
                children: [
                  SizedBox(),
                  Text(
                    model.albumName,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,overflow: .ellipsis),
                  ),
                  Text(
                    model.artist,
                    style: TextStyle(
                      color: subColor.withValues(alpha: 0.5),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '₩ ${won(model.price)}',
                    style: TextStyle(
                      color: mainColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
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

  Widget genre() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              "장르별 둘러보기",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
            GestureDetector(
              onTap: () => topage(context, AppScreen(index: 1)),
              child: Row(
                spacing: 6,
                children: [
                  Text(
                    '전체 보기',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: subColor,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 12,
                    color: subColor,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.start,
          children: List.generate(
            8,
            (index) => GestureDetector(
              onTap: () {
                topage(
                  context,
                  AppScreen(index: 1, genre: genreCodes.keys.elementAt(index)),
                );
              },
              child: Container(
                width: 88,
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: subColor.withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      genres[index],
                      height: 30,
                      color: mainColor,
                    ),
                    Text(
                      genreCodes.values.elementAt(index) == 'Etc'
                          ? '기타'
                          : genreCodes.values.elementAt(index),
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget search() {
    return GestureDetector(
      onTap: () => topage(context, AppScreen(index: 1)),
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.only(top: 12),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: subColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 4,
              children: [
                Icon(CupertinoIcons.search, color: subColor, size: 28),
                Text(
                  "앨범명, 아티스트 검색",
                  style: TextStyle(
                    color: subColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Icon(CupertinoIcons.barcode_viewfinder, color: subColor, size: 28),
          ],
        ),
      ),
    );
  }

  AppBar appbar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            "assets/simbol/logo_vertical.png",
            height: 60,
          ),
          GestureDetector(
            onTap: () => showMessage("해당 기능은 현재 준비중입니다."),
            child: SvgPicture.asset(
              "assets/icons/notification.svg",
              height: 28,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
