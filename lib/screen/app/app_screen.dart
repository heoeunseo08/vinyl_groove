import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vinyl_groove/controller/notif_controller.dart';
import 'package:vinyl_groove/screen/add_product_screen.dart';
import 'package:vinyl_groove/screen/app/favorite_screen.dart';
import 'package:vinyl_groove/screen/app/home_screen.dart';
import 'package:vinyl_groove/screen/app/my_screen.dart';
import 'package:vinyl_groove/screen/app/search_screen.dart';
import 'package:vinyl_groove/utils/info.dart';
import 'package:vinyl_groove/utils/utils.dart';

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

  List<String> labels = ['홈', '탐색', '관심상품', '마이페이지'];

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

    notifController.load();
    timer = Timer.periodic(
      Duration(seconds: 30),
      (timer) => notifController.load(),
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
      bottomNavigationBar: bottomBar(),
    );
  }

  Widget bottomBar() {
    return Container(
      height: 80,
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(color: coverColor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: item(index: 0, label: labels[0], icon: icons[0]),
          ),
          Expanded(
            child: item(index: 1, label: labels[1], icon: icons[1]),
          ),
          Expanded(
            child: GestureDetector(
              key: ValueKey('add'),
              onTap: () => toPage(context, AddProductScreen()),
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
          Expanded(
            child: item(index: 2, label: labels[2], icon: icons[2]),
          ),
          Expanded(
            child: item(index: 3, label: labels[3], icon: icons[3]),
          ),
        ],
      ),
    );
  }

  Widget item({
    required int index,
    required String label,
    required IconData icon,
  }) {
    bool select = currentIndex == index;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => currentIndex = index),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 4),
          Icon(icon, color: select ? mainColor : subColor, size: 23),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: select ? mainColor : subColor,
            ),
          ),
        ],
      ),
    );
  }
}
