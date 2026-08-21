import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vinyl_groove_test7/controller/product_controller.dart';
import 'package:vinyl_groove_test7/screen/app/app_screen.dart';
import 'package:vinyl_groove_test7/screen/detail_screen.dart';
import 'package:vinyl_groove_test7/utils/info.dart';
import 'package:vinyl_groove_test7/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ProductController productController = ProductController();
  String select_sort = sort_codes(home: true).keys.first;

  List<String> icons = [
    'assets/icons/genre/electronic.svg',
    'assets/icons/genre/electronic.svg',
    'assets/icons/genre/etc.svg',
    'assets/icons/genre/hip-hop.svg',
    'assets/icons/genre/jazz.svg',
    'assets/icons/genre/pop.svg',
    'assets/icons/genre/rnb-soul.svg',
    'assets/icons/genre/rock.svg',
  ];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    await productController.load(limit: 10, sort: select_sort);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: appbar(),
      ),
      body: RefreshIndicator(
        onRefresh: () => load(),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SizedBox(height: 12),
                search(),
                SizedBox(height: 25),
                genre_session(),
                SizedBox(height: 40),
                card_sesssion(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget card(int index) {
    final model = productController.product_list[index];
    final double size = 140;
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
      children: [
        Row(
          mainAxisAlignment: .spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              spacing: 12,
              children: List.generate(
                3,
                (index) {
                  final select =
                      sort_codes(home: true).keys.elementAt(index) ==
                      select_sort;
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async{
                      setState(
                        () {
                          select_sort = sort_codes(
                            home: true,
                          ).keys.elementAt(index);
                        },
                      );
                      await load();
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: select ? mainColor : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        sort_codes(home: true).values.elementAt(index),
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Text(
                  "전체 보기",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: subColor,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 15,
                  color: subColor,
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 18),
        SizedBox(
          height: 240,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 14,
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

  Widget genre_session() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: .spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "장르별 둘러보기",
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
            GestureDetector(
              onTap: () => toPage(context, AppScreen(index: 1)),
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  Text(
                    "전체 보기",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: subColor,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 15,
                    color: subColor,
                  ),
                ],
              ),
            ),
          ],
        ),
        Wrap(
          runSpacing: 8,
          spacing: 8,
          children: List.generate(
            8,
            (index) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => toPage(
                  context,
                  AppScreen(
                    index: 1,
                    genre: genre_codes(home: true).keys.elementAt(index),
                  ),
                ),

                child: Container(
                  width: 88,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: subColor.withValues(alpha: 0.6)),
                  ),
                  child: Column(
                    spacing: 3,
                    children: [
                      SvgPicture.asset(icons[index], height: 35),
                      Text(
                        genre_codes(home: true).values.elementAt(index),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
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

  Widget search() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => toPage(context, AppScreen(index: 1)),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: subColor.withValues(alpha: 0.4)),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(CupertinoIcons.search, color: subColor, size: 28),
                Text(
                  "앨범명, 아티스트 검색",
                  style: TextStyle(
                    color: subColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
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
}

Widget appbar() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Image.asset("assets/simbol/logo_vertical.png", height: 55),
      GestureDetector(
        onTap: () => show_message(),
        child: SvgPicture.asset(
          "assets/icons/notification.svg",
          height: 28,
          color: Colors.white,
        ),
      ),
    ],
  );
}
