import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vinyl_groove_test4/controller/product_controller.dart';
import 'package:vinyl_groove_test4/model/product_model.dart';
import 'package:vinyl_groove_test4/screen/app/app_screen.dart';
import 'package:vinyl_groove_test4/screen/barcode_screen.dart';
import 'package:vinyl_groove_test4/screen/detail_screen.dart';
import 'package:vinyl_groove_test4/utils/info.dart';
import 'package:vinyl_groove_test4/utils/utils.dart';
import 'package:vinyl_groove_test4/utils/widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  ProductController productController = ProductController();
  ProductController recommendController = ProductController();
  ProductController barcodeController = ProductController();

  List<ProductModel> recommendList = [];

  late final AnimationController discController;
  late final AnimationController snapController;
  late final Tween<double> snapTween;
  late final Animation<double> snapAnimation;

  double toneAng = startAng;
  static const double startAng = -0.35;
  static const double endAng = -0.05;

  final ScrollController scrollController = ScrollController();
  bool isDragTonearm = false;

  int selectSortIndex = 0;

  int currentIndex = 0;
  int recommendIndex = 0;
  bool isPlaying = false;

  final GlobalKey _pageContentKey = GlobalKey();
  double _pageHeight = 400;

  String? get sortCode => sortCodes(home: true).keys.elementAt(selectSortIndex);

  void _syncPageHeight() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final size = _pageContentKey.currentContext?.size;
      if (size == null) return;
      if ((size.height - _pageHeight).abs() > 0.5) {
        setState(() => _pageHeight = size.height);
      }
    });
  }

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
    snapTween = Tween<double>(begin: startAng, end: endAng);
    snapAnimation =
        snapTween.animate(CurvedAnimation(parent: snapController, curve: Curves.easeOut))
          ..addListener(() => setState(() => toneAng = snapAnimation.value));
  }

  void _snapTonearm() {
    setState(() => isDragTonearm = false);

    final snapToPlay = (toneAng - endAng).abs() <= (toneAng - startAng).abs();
    snapTween
      ..begin = toneAng
      ..end = snapToPlay ? endAng : startAng;

    snapController.forward(from: 0).then((_) => setPlaying(snapToPlay));
  }

  load() async {
    await productController.loadList(limit: 10, sort: sortCode);
    await loadRecommend();
    setState(() {});
  }

  loadRecommend() async {
    await recommendController.loadList(limit: 5, sort: 'popular');
    recommendList = recommendController.productList;
    setState(() {});
  }

  @override
  void dispose() {
    discController.dispose();
    snapController.dispose();
    super.dispose();
  }

  void setPlaying(bool playing) {
    setState(() => isPlaying = playing);

    if (playing) {
      discController.repeat();
    } else {
      discController.stop();
    }
  }

  List<String> genrePath = [
    'rock.svg',
    'jazz.svg',
    'pop.svg',
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
            onRefresh: () async => load(),
            child: SingleChildScrollView(
              controller: scrollController,
              physics: isDragTonearm
                  ? NeverScrollableScrollPhysics()
                  : AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  appbar(context),
                  SizedBox(height: 4),
                  search(),
                  SizedBox(height: 20),
                  recommendCard(),
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

  Widget recommendCard() {
    return Container(
      width: MediaQuery.widthOf(context),
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: coverColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        spacing: 20,
        children: [tag(), vinyl(), tab()],
      ),
    );
  }

  Widget tag() => Column(
    spacing: 6,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: mainColor),
        ),
        child: Text(
          '오능의 추천 바이닐',
          style: TextStyle(
            color: mainColor,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
      Text(
        "오늘, 이 바이닐은\n어떠세요?",
        textAlign: .center,
        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 23),
      ),
      Text(
        "매일 새롭게 선별한 특별한 한 장",
        style: TextStyle(
          color: subColor,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    ],
  );

  Widget turntableSection(ProductModel model) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 35),
      child: Stack(
        alignment: .center,
        children: [
          Image.asset(
            'assets/images/turntable.png',
            width: 300,
          ),
          Positioned(
            top: 41,
            left: 39,
            child: RotationTransition(
              turns: discController,
              child: Stack(
                alignment: .center,
                children: [
                  Image.asset(
                    "assets/images/vinyl.png",
                    width: 210,
                  ),
                  ClipRRect(
                    borderRadius: .circular(99),
                    child: Image.network(
                      width: 80,
                      height: 80,
                      model.albumImage,
                      fit: .cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: .circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 0,
            child: GestureDetector(
              onPanStart: (_) => setState(() => isDragTonearm = true),
              onPanUpdate: (details) => setState(() {
                toneAng = (toneAng + details.delta.dy * 0.05)
                    .clamp(startAng, endAng + 0.15);
              }),
              onPanEnd: (_) => _snapTonearm(),
              child: Transform.rotate(
                angle: -toneAng,
                alignment: Alignment(0.64, -0.05),
                child: Image.asset(
                  "assets/images/tonearm.png",
                  width: 180,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget vinylPageContent(ProductModel model) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        turntableSection(model),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 800),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            final slide = Tween<Offset>(
              begin: Offset(0, -0.2),
              end: Offset.zero,
            ).animate(animation);
            return ClipRect(
              child: SlideTransition(
                position: slide,
                child: FadeTransition(opacity: animation, child: child),
              ),
            );
          },
          child: isPlaying
              ? KeyedSubtree(
            key: const ValueKey('vinylCard'),
            child: vinylCard(model),
          )
              : const SizedBox.shrink(key: ValueKey('vinylCardEmpty')),
        ),
      ],
    );
  }

  Widget vinyl() {
    if (recommendList.isEmpty) {
      return const SizedBox(height: 400);
    }

    _syncPageHeight();

    return AnimatedContainer(
      duration: Duration(milliseconds: 800),
      curve: Curves.easeOut,
      height: _pageHeight,
      child: PageView.builder(
        itemCount: recommendList.length,
        onPageChanged: (value) => setState(() => recommendIndex = value),
        itemBuilder: (context, index) {
          final model = recommendList[index];
          final isCurrent = index == recommendIndex;

          return Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: KeyedSubtree(
                key: isCurrent ? _pageContentKey : null,
                child: vinylPageContent(model),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget vinylCard(ProductModel model) {
    final double imageSize = 65;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => toPage(context, DetailScreen(product_id: model.id)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: .spaceBetween,
          children: [
            Row(
              spacing: 12,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    model.albumImage,
                    width: imageSize,
                    height: imageSize,
                    fit: .cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: imageSize,
                        height: imageSize,
                        decoration: BoxDecoration(color: Colors.white),
                      );
                    },
                  ),
                ),
                Column(
                  spacing: 4,
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      model.albumName,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      model.artist,
                      style: TextStyle(
                        color: mainColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      "${genreCodes[model.genre]} · ${model.condition}",
                      style: TextStyle(
                        color: subColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios_outlined,
              size: 15,
            ),
          ],
        ),
      ),
    );
  }

  Widget tab() {
    return Row(
      spacing: 6,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        recommendList.length,
            (index) {
          final current = recommendIndex == index;
          return AnimatedContainer(
            duration: Duration(milliseconds: 400),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(99),
              color: current ? mainColor : subColor,
            ),
            width: current ? 16 : 6,
            height: 6,
          );
        },
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
                onTap: () => toPage(context, AppScreen(index: 1, genre: entry.key)),
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
                  Positioned(
                    top: 8,
                    right: 8,
                    child: favorite_button(id: model.id),
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
            GestureDetector(onTap: () async {
              final scannedBarcode = await toPage<String?>(context, BarcodeScreen());
              if (scannedBarcode != null && scannedBarcode.isNotEmpty) {
                await barcodeController.loadList(barcode: scannedBarcode, reset: true);
                if (!mounted) return;

                if (barcodeController.productList.isNotEmpty) {
                  final id = barcodeController.productList.first.id;
                  toPage(context, DetailScreen(product_id: id));
                } else {
                  showMessage("$scannedBarcode에 해당하는 상품을 찾을 수 없습니다");
                }
              }
            },
              child: SvgPicture.asset(
                "assets/icons/barcode-scan.svg",
                colorFilter: ColorFilter.mode(subColor, BlendMode.srcIn),
                height: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}