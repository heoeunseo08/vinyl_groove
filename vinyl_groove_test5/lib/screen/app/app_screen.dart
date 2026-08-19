import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vinyl_groove_test5/controller/alarm_controller.dart';
import 'package:vinyl_groove_test5/screen/add_product_screen.dart';
import 'package:vinyl_groove_test5/screen/app/favorite_screen.dart';
import 'package:vinyl_groove_test5/screen/app/home_screen.dart';
import 'package:vinyl_groove_test5/screen/app/my_screen.dart';
import 'package:vinyl_groove_test5/screen/app/search_screen.dart';
import 'package:vinyl_groove_test5/utils/info.dart';
import 'package:vinyl_groove_test5/utils/utils.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key, this.index = 0, this.genre});

  final int index;
  final String? genre;

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  Timer? timer;
  int currentIndex = 0;
  late List<Widget> pages = [
    HomeScreen(),
    SearchScreen(genre: widget.genre),
    FavoriteScreen(),
    MyScreen(),
  ];

  List<String> label = ['홈', '탐색', '관심상품', '마이페이지'];

  List<IconData> icons = [
    CupertinoIcons.home,
    CupertinoIcons.search,
    Icons.favorite_border,
    CupertinoIcons.person,
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;

    load();
    timer = Timer.periodic(Duration(seconds: 30), (timer) => load());
  }

  Future<void> load() async {
    await alarmController.load();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: bottomBar(),
    );
  }

  Widget bottomBar() {
    return Container(
      height: 90,
      color: coverColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: item(0)),
          Expanded(child: item(1)),Expanded(
            child: GestureDetector(
              key: ValueKey('add'),
              onTap: () => topage(context, AddProductScreen()),
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: mainColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(CupertinoIcons.add, color: Colors.black),
              ),
            ),
          ),
          Expanded(child: item(2)),
          Expanded(child: item(3)),
        ],
      ),
    );
  }

  Widget item(int index) {
    final select = currentIndex == index;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => currentIndex = index),
      child: Column(
        spacing: 6,
        children: [
          SizedBox(),
          Icon(icons[index], color: select ? mainColor : subColor),
          Text(
            label[index],
            style: TextStyle(color: select ? mainColor : subColor),
          ),
        ],
      ),
    );
  }
}
