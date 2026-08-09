import 'dart:math';

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

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  ProductController productController = ProductController();
  ProductController recommentController = ProductController();

  late AnimationController discController;
  late AnimationController snapController;
  late Animation<double> snapAnimation;

  double toneAng = startAng;
  static const double startAng = -0.35;
  static const double playAng = 0.05;

  final ScrollController scrollController = ScrollController();
  bool isDragTonearm = false;

  late List<ProductModel> recommentModelList = [];
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
  int recommentIndex = 0;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    recommentLoad();
    load();

    discController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    snapController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  void setPlaying(bool playing) {
    setState(() => isPlaying = playing);
    if (playing) {
      discController.repeat();
    } else {
      discController.stop();
    }
  }

  Future<void> load() async {
    await productController.loadList(
      sort: sortCode().keys.elementAt(currentIndex),
      limit: 10,
    );
    setState(() {});
  }

  Future<void> recommentLoad() async {
    await recommentController.loadList(sort: 'popular', limit: 5);
    setState(() => recommentModelList = recommentController.productList);
  }

  @override
  void dispose() {
    discController.dispose();
    snapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
          child: SingleChildScrollView(
            controller: scrollController,
            physics: isDragTonearm
                ? NeverScrollableScrollPhysics()
                : AlwaysScrollableScrollPhysics(),
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
                      color: subColor.withValues(alpha: 0.3),
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
                recommentCard(),
                SizedBox(height: 20),
                genresCard(),
                SizedBox(height: 20),
                productCards(),
                SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget recommentCard() {
    return Container(
      width: MediaQuery.widthOf(context),
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: coverColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: mainColor),
            ),
            child: Text(
              "오늘의 추천 바이닐",
              style: TextStyle(
                color: mainColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 12),
          Text(
            textAlign: TextAlign.center,
            '오늘, 이 바이닐은\n어떠세요?',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
          ),
          Text(
            '매일 새롭게 선별한 특별한 한장 ',
            style: TextStyle(
              color: subColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            height: isPlaying ? 400 : 320,
            child: PageView.builder(
              itemCount: recommentModelList.length,
              onPageChanged: (value) => setState(() => recommentIndex = value),
              itemBuilder: (context, index) {
                final model = recommentController.productList[index];
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 35),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset('assets/images/turntable.png'),
                          Positioned(
                            top: 45,
                            left: 44,
                            child: AnimatedBuilder(
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle: discController.value * 2 * pi,
                                  child: child,
                                );
                              },
                              animation: discController,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/vinyl.png',
                                    width: 220,
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(99),
                                    child: Image.network(
                                      model.albumImage,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                                width: 80,
                                                height: 80,
                                                color: Colors.white,
                                              ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 15,
                            left: 135,
                            child: Listener(
                              onPointerDown: (_) =>
                                  setState(() => isDragTonearm = true),
                              onPointerUp: (_) {
                                setState(() => isDragTonearm = false);

                                final play = (toneAng - playAng).abs();
                                final start = (toneAng - startAng).abs();
                                final snap = play <= start;
                                final target = snap ? playAng : startAng;

                                snapAnimation =
                                    Tween<double>(
                                        begin: toneAng,
                                        end: target,
                                      ).animate(
                                        CurvedAnimation(
                                          parent: snapController,
                                          curve: Curves.easeOut,
                                        ),
                                      )
                                      ..addListener(
                                        () => setState(
                                          () => toneAng = snapAnimation.value,
                                        ),
                                      );

                                snapController
                                    .forward(from: 0)
                                    .then((value) => setPlaying(snap));
                              },
                              child: GestureDetector(
                                onPanUpdate: (details) => setState(() {
                                  toneAng += details.delta.dy * 0.005;
                                  toneAng = toneAng.clamp(
                                    startAng,
                                    playAng + 0.15,
                                  );
                                }),
                                child: Transform.rotate(
                                  angle: -toneAng,
                                  alignment: Alignment(0.64, -0.05),
                                  child: Image.asset(
                                    'assets/images/tonearm.png',
                                    width: 180,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isPlaying)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => toPage(
                            context,
                            DetailScreen(product_id: model.id),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      model.albumImage,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                                width: 60,
                                                height: 60,
                                                color: Colors.white,
                                              ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        model.albumName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        model.artist,
                                        style: TextStyle(
                                          color: mainColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        '${genresCode[model.genre]} ${model.condition}',
                                        style: TextStyle(
                                          color: subColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.white,
                                size: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          Row(
            spacing: 6,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              recommentModelList.length,
              (index) {
                final current = index == recommentIndex;
                return AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: current ? mainColor : subColor,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  width: current ? 16 : 6,
                  height: 6,
                );
              },
            ),
          ),
        ],
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
                Positioned(
                  top: 8,
                  right: 8,
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
