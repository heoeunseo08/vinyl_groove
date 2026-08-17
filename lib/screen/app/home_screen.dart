import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_test3/controller/alarm_controller.dart';
import 'package:vinyl_groove_test3/controller/product_controller.dart';
import 'package:vinyl_groove_test3/model/product_model.dart';
import 'package:vinyl_groove_test3/screen/alarm_screen.dart';
import 'package:vinyl_groove_test3/screen/app/app_screen.dart';
import 'package:vinyl_groove_test3/screen/barcode_screen.dart';
import 'package:vinyl_groove_test3/screen/detail_screen.dart';
import 'package:vinyl_groove_test3/utils/info.dart';
import 'package:vinyl_groove_test3/utils/util.dart';
import 'package:vinyl_groove_test3/utils/widget.dart';

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
  static const double endAng = -0.05;

  final ScrollController scrollController = ScrollController();
  bool isDragToneArm = false;

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
    load();

    discController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );
    snapController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    setState(() {

    });
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
      sort: sortCodes(home: true).keys.elementAt(currentIndex),
      limit: 10,
    );
    await recomment_load();
    setState(() {});
  }

  Future<void> recomment_load() async {
    await recommentController.loadList(
      sort: 'popular',
      limit: 5,
    );
    setState(() {
      recommentModelList = recommentController.productList;
    });
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
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: RefreshIndicator(
            onRefresh: () => load(),
            child: SingleChildScrollView(
              controller: scrollController,
              physics: isDragToneArm
                  ? NeverScrollableScrollPhysics()
                  : AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  appbar(),
                  SizedBox(height: 6),
                  search(),
                  SizedBox(height: 20),
                  recommentCard(),
                  SizedBox(height: 20),
                  genreSession(),
                  SizedBox(height: 20),
                  productCards(),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget recommentCard() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      width: MediaQuery.widthOf(context),
      decoration: BoxDecoration(
        color: coverColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: .center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: mainColor),
            ),
            child: Text(
              "오늘의 추천 바이닐",
              style: TextStyle(
                color: mainColor,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            textAlign: .center,
            "오늘, 이 바이닐은\n어떠세요?",
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
          ),
          Text(
            "매일 새롭게 선별한 특별한 한 장",
            style: TextStyle(
              color: subColor,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 16),
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
                            top: 10,
                            left: 130,
                            child: Listener(
                              onPointerDown: (_) =>
                                  setState(() => isDragToneArm = true),
                              onPointerUp: (_) {
                                setState(() => isDragToneArm = false);

                                final play = (toneAng - endAng).abs();
                                final start = (toneAng - startAng).abs();
                                final snap = play <= start;
                                final target = snap ? endAng : startAng;

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
                                    endAng + 0.15,
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
                            context: context,
                            page: DetailScreen(product_id: model.id),
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
                                        '${genreCodes[model.genre]} ${model.condition}',
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
                if (alarmController.unreadCount  != 0)
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

  Widget search() {
    return GestureDetector(
      onTap: () => toPage(context: context, page: AppScreen(index: 1)),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: subColor.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 8,
              children: [
                Icon(CupertinoIcons.search, color: subColor),
                Text(
                  "앨범명, 아티스트 검색",
                  style: TextStyle(
                    color: subColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ],
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
      ),
    );
  }

  Widget genreSession() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              "장르별 둘러보기",
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            Row(
              children: [
                Text(
                  "전체 보기",
                  style: TextStyle(
                    color: subColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
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
          runSpacing: 8,
          spacing: 8,
          children: List.generate(8, (index) {
            final key = genreCodes.keys.elementAt(index);
            final value = genreCodes.values.elementAt(index);
            return GestureDetector(
              onTap: () => toPage(
                context: context,
                page: AppScreen(
                  index: 1,
                  genre: key,
                ),
              ),
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4),
                width: 85,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: subColor.withValues(alpha: 0.5)),
                ),
                child: Column(
                  children: [
                    SvgPicture.asset(
                      svgPath(genreIcons[index]),
                      color: mainColor,
                    ),
                    Text(
                      value == 'Etc' ? '기타' : value,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
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
          final code = sortCodes(home: true).keys.elementAt(index);
          final label = sortCodes(home: true).values.elementAt(index);
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
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget card(ProductModel model) {
    final won = NumberFormat('#,###').format(model.price);

    return GestureDetector(
      onTap: () => toPage(
        context: context,
        page: DetailScreen(product_id: model.id),
      ),
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
}
