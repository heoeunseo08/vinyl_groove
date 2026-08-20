import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_test6/controller/alarm_controller.dart';
import 'package:vinyl_groove_test6/controller/favorite_controller.dart';
import 'package:vinyl_groove_test6/controller/product_controller.dart';
import 'package:vinyl_groove_test6/model/product_model.dart';
import 'package:vinyl_groove_test6/screen/alarm_screen.dart';
import 'package:vinyl_groove_test6/screen/app/app_screen.dart';
import 'package:vinyl_groove_test6/screen/barcode_screen.dart';
import 'package:vinyl_groove_test6/screen/detail_screen.dart';
import 'package:vinyl_groove_test6/uitls/info.dart';
import 'package:vinyl_groove_test6/uitls/utils.dart';
import 'package:vinyl_groove_test6/uitls/widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  ProductController productController = ProductController();
  ProductController recommentController = ProductController();
  final List<String> genreIcons = [
    'assets/icons/genre/rock.svg',
    'assets/icons/genre/jazz.svg',
    'assets/icons/genre/pop.svg',
    'assets/icons/genre/hip-hop.svg',
    'assets/icons/genre/electronic.svg',
    'assets/icons/genre/classical.svg',
    'assets/icons/genre/rnb-soul.svg',
    'assets/icons/genre/etc.svg',
  ];
  int currentIndex = 0;
  int recommentIndex = 0;

  late AnimationController disc_controller;
  late AnimationController snap_controller;

  static const double startAng = -0.35;
  static const double endAng = -0.05;
  double toneAng = startAng;
  double snapFrom = startAng;
  double snapTO = startAng;
  bool isPlaying = false;
  bool isDrag = false;

  @override
  void initState() {
    super.initState();
    load();

    disc_controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );

    snap_controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300))
          ..addListener(() {
            final t = Curves.easeOut.transform(snap_controller.value);
            setState(() => toneAng = snapFrom + (snapTO - snapFrom) * t);
          });
  }

  Future<void> load() async {
    await Future.wait([
      productController.loadList(
        sort: sortCodes(home: true).keys.elementAt(currentIndex),
        limit: 10,
      ),

      recommentController.loadList(sort: 'popular', limit: 5),
    ]);
    recommentIndex = 0;
    setState(() {});
  }

  @override
  void dispose() {
    disc_controller.dispose();
    snap_controller.dispose();

    super.dispose();
  }

  void setPlaying(bool Playing) {
    setState(() => isPlaying = Playing);
    if (Playing) {
      disc_controller.repeat();
    } else {
      disc_controller.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
          child: RefreshIndicator(
            onRefresh: () => load(),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
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
                        onTap: () => toPage(context, AlarmScreen()),
                        child: Stack(
                          alignment: .center,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/notification.svg",
                              color: Colors.white,
                              height: 28,
                            ),
                            ValueListenableBuilder(
                              valueListenable: alarmController.unreadCount,
                              builder: (context, value, child) {
                                return ListenableBuilder(
                                  listenable: alarmController,
                                  builder: (context, child) {
                                    if (value == 0)
                                      return const SizedBox.shrink();
                                    return Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        alignment: .center,
                                        width: 15,
                                        height: 15,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          textAlign: .center,
                                          '${alarmController.unreadCount.value > 9 ? '9+' : alarmController.unreadCount.value}',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => toPage(context,AppScreen(index: 1)),
                    child: Container(
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
                          GestureDetector(
                            onTap: () async {
                              final barcode = await toPage<String>(
                                context,
                                BarcodeScreen(),
                              );
                              if (barcode == null) return;

                              final barcode_controller = ProductController();
                              await barcode_controller.loadList(barcode: barcode);
                              if (barcode_controller.productList.isNotEmpty) {
                                toPage(
                                  context,
                                  DetailScreen(
                                    id: barcode_controller.productList.first.id,
                                  ),
                                );
                              } else {
                                showMessage(
                                  text: '바코드 "$barcode"에 해당하는 상품을 찾을 수 없습니다',
                                );
                              }
                            },
                            child: SvgPicture.asset(
                              "assets/icons/barcode-scan.svg",
                              color: subColor,
                              height: 25,
                            ),
                          ),
                        ],
                      ),
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
      ),
    );
  }

  Widget recommentCard() {
    final list = recommentController.productList;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 1),
      decoration: BoxDecoration(
        color: coverColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: .center,
        children: [
          title(),
          SizedBox(height: 20),
          if (recommentController.isListLoading)
            loadingWidget()
          else
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: isPlaying ? 410 : 350,
              child: PageView.builder(
                physics: isDrag
                    ? NeverScrollableScrollPhysics()
                    : PageScrollPhysics(),
                itemCount: list.length,
                onPageChanged: (value) {
                  setState(() {
                    recommentIndex = value;
                    toneAng = startAng;
                  });
                  if (isPlaying) setPlaying(false);
                },
                itemBuilder: (context, index) {
                  final model = list[index];
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
                                animation: disc_controller,
                                builder: (context, child) => Transform.rotate(
                                  angle: disc_controller.value * 2 * pi,
                                  child: child,
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/vinyl.png',
                                      width: 210,
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
                                    setState(() => isDrag = true),
                                onPointerUp: (_) {
                                  setState(() => isDrag = false);

                                  final toEnd = (toneAng - endAng).abs();
                                  final toStart = (toneAng - startAng).abs();
                                  final snap = toEnd <= toStart;

                                  snapFrom = toneAng;
                                  snapTO = snap ? endAng : startAng;

                                  snap_controller.forward(from: 0).then((_) {
                                    if (!mounted) return;
                                    setPlaying(snap);
                                  });
                                },
                                child: GestureDetector(
                                  onVerticalDragUpdate: (details) =>
                                      setState(() {
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
                      AnimatedSize(
                        alignment: .topCenter,
                        curve: Curves.easeOut,
                        duration: Duration(milliseconds: 400),
                        child: isPlaying ? info(model) : SizedBox.shrink(),
                      ),
                      SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: .center,
                        spacing: 8,
                        children: List.generate(
                          5,
                          (index) {
                            final select = recommentIndex == index;
                            return AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              width: select ? 16 : 6,
                              height: 6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(99),
                                color: select
                                    ? mainColor
                                    : subColor.withValues(alpha: 0.5),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 14),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget info(ProductModel model) {
    final double size = 65;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => toPage(context, DetailScreen(id: model.id)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: .circular(8),
                  child: Image.network(
                    model.albumImage,
                    width: size,
                    height: size,
                    fit: .cover,
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.albumName,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
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
                      '${genreCodes()[model.genre]} · ${model.condition}',
                      style: TextStyle(
                        color: subColor.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Icon(
              Icons.arrow_forward_ios_outlined,
              size: 15,
              color: subColor.withValues(alpha: 0.8),
            ),
          ],
        ),
      ),
    );
  }

  Widget title() => Column(
    crossAxisAlignment: .center,
    spacing: 6,
    children: [
      SizedBox(width: MediaQuery.widthOf(context)),
      SizedBox(),
      Container(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: mainColor),
        ),
        child: Text(
          "오늘의 추천 바이닐",
          style: TextStyle(
            color: mainColor,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      Text(
        textAlign: .center,
        "오늘, 이 바이닐은\n어떠세요?",
        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
      ),
      Text(
        textAlign: .center,
        "매일 새롭게 선별한 특별한 한 장",
        style: TextStyle(
          color: subColor.withValues(alpha: 0.6),
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    ],
  );

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
              final code = genreCodes(home: true).keys.elementAt(index);
              final label = genreCodes(home: true).values.elementAt(index);
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
              icon,
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
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget card(ProductModel model) {
    final won = NumberFormat('#,###').format(model.price);

    return GestureDetector(
      onTap: () => toPage(context, DetailScreen(id: model.id)),
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
                  child: FavoriteButton(id: model.id),
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
