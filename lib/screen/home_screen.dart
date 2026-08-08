import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove/controller/product_controller.dart';
import 'package:vinyl_groove/model/product_model.dart';
import 'package:vinyl_groove/screen/app_screen.dart';
import 'package:vinyl_groove/screen/detail_screen.dart';
import 'package:vinyl_groove/utils/info.dart';
import 'package:vinyl_groove/utils/utils.dart';
import 'package:vinyl_groove/utils/widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ProductController productController = ProductController();
  final List<String> genreIcons = [
    'rock.svg',
    'jazz.svg',
    'pop.svg',
    'hip-hop.svg',
    'electronic.svg',
    'classical.svg',
    'rnb-soul.svg',
    'etc.svg',
  ];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    await productController.loadList(
      sort: sortCode().keys.elementAt(currentIndex),
      limit: 10,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    "assets/simbol/logo_vertical.png",
                    height: 50,
                  ),
                  GestureDetector(
                    onTap: () => showMessage("준비 중입니다."),
                    child: SvgPicture.asset(
                      "assets/icons/notification.svg",
                      color: Colors.white,
                      height: 25,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6),
              Container(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: subColor.withOpacity(0.3),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/search.svg",
                          color: Colors.white,
                          height: 25,
                        ),
                        SizedBox(width: 12),
                        Text(
                          "앨범명, 아티스트 검색",
                          style: TextStyle(
                            color: subColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SvgPicture.asset(
                      "assets/icons/barcode-scan.svg",
                      color: Colors.white,
                      height: 25,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              genresCard(),
              SizedBox(height: 20),
              productCards(),
            ],
          ),
        ),
      ),
    );
  }

  Widget genresCard() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "장르별 둘러보기",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            GestureDetector(
              onTap: () => toPage(context, AppScreen(index: 1)),
              child: Row(
                children: [
                  Text(
                    "전체 보기",
                    style: TextStyle(
                      color: subColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: subColor,
                    size: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(
            8,
            (index) {
              final code = genresCode.keys.elementAt(index);
              final label = genresCode.values.elementAt(index);
              return genreChips(genreIcons[index], label, code);
            },
          ),
        ),
      ],
    );
  }

  Widget genreChips(String icon, String text, String code) {
    return GestureDetector(
      onTap: () => toPage(context, AppScreen(index: 1, genre: code)),
      child: Container(
        width: 85,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: subColor.withOpacity(0.3), width: 1.5),
        ),
        child: Column(
          children: [
            SvgPicture.asset(
              "assets/icons/$icon",
              width: 30,
            ),
            SizedBox(height: 6),
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget productCards() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            tabs(),
            Row(
              children: [
                Text(
                  "전체 보기",
                  style: TextStyle(
                    color: subColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: subColor,
                  size: 10,
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 20),
        productController.isListLoading
            ? loadingWidget()
            : SingleChildScrollView(
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

  Widget tabs() {
    return Row(
      spacing: 16,
      children: List.generate(
        3,
        (index) {
          final code = sortCode().keys.elementAt(index);
          final label = sortCode().values.elementAt(index);
          return tabButton(label, code, index);
        },
      ),
    );
  }

  Widget tabButton(String text, String code, int index) {
    final select = currentIndex == index;
    return GestureDetector(
      onTap: () async {
        setState(() => currentIndex = index);
        await load();
        setState(() {});
      },
      child: Container(
        padding: EdgeInsetsGeometry.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: select
              ? Border(bottom: BorderSide(color: mainColor, width: 1.5))
              : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: select ? Colors.white : subColor,
            fontWeight: select ? FontWeight.w700 : FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget card(ProductModel model) {
    final won = NumberFormat('#,###').format(model.price);

    return GestureDetector(
      onTap: () => toPage(context, DetailScreen(product_id: model.id)),
      child: Container(
        width: 150,
        height: 215,
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
                    width: 150,
                    height: 130,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 150,
                      height: 130,
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
}
