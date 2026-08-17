import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vinyl_groove_test3/controller/alarm_controller.dart';
import 'package:vinyl_groove_test3/screen/add_product_screen.dart';
import 'package:vinyl_groove_test3/screen/app/favorite_screen.dart';
import 'package:vinyl_groove_test3/screen/app/home_screen.dart';
import 'package:vinyl_groove_test3/screen/app/my_screen.dart';
import 'package:vinyl_groove_test3/screen/app/search_screen.dart';
import 'package:vinyl_groove_test3/utils/info.dart';
import 'package:vinyl_groove_test3/utils/util.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key, this.index = 0, this.genre});

  final int index;
  final String? genre;

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  int currentIndex = 0;
  Timer? timer;

  late List<Widget> pages = [
    HomeScreen(),
    SearchScreen(genre: widget.genre),
    FavoriteScreen(),
    MyScreen(),
  ];

  List<String> labels = ['홈', "탐색", '관심상품', '마이페이지'];
  List<IconData> icons = [
    Icons.home_outlined,
    CupertinoIcons.search,
    Icons.favorite_border,
    CupertinoIcons.person,
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;

    timer = Timer.periodic(
      Duration(seconds: 30),
      (timer) => alarmController.load(),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: bottonBar(),
    );
  }

  Widget bottonBar() {
    return Container(
      height: 90,
      color: coverColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: item(0)),
          Expanded(child: item(1)),
          Expanded(child: GestureDetector(
            key: ValueKey('add'),
            onTap: () => toPage(context: context, page: AddProductScreen()),
            child: Container(
              margin: EdgeInsets.only(bottom: 40),
              width: 50,
              height: 50,
              decoration: BoxDecoration(shape: BoxShape.circle,color: mainColor),
              child: Icon(CupertinoIcons.add,size: 25,color: Colors.black,),
            ),
          )),
          Expanded(child: item(2)),
          Expanded(child: item(3)),
        ],
      ),
    );
  }

  Widget item(int index) {
    final select = currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => currentIndex = index),
        behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Column(
          children: [
            Icon(icons[index], color: select ? mainColor : subColor),
            Text(
              labels[index],
              style: TextStyle(color: select ? mainColor : subColor),
            ),
          ],
        ),
      ),
    );
  }
}
