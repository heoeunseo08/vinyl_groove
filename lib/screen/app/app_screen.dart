import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vinyl_groove_test6/controller/alarm_controller.dart';
import 'package:vinyl_groove_test6/controller/favorite_controller.dart';
import 'package:vinyl_groove_test6/screen/add_screen.dart';
import 'package:vinyl_groove_test6/screen/app/favorite_screen.dart';
import 'package:vinyl_groove_test6/screen/app/home_screen.dart';
import 'package:vinyl_groove_test6/screen/app/my_screen.dart';
import 'package:vinyl_groove_test6/screen/app/search_screen.dart';
import 'package:vinyl_groove_test6/uitls/info.dart';
import 'package:vinyl_groove_test6/uitls/utils.dart';

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

  late List<Widget> page = [
    HomeScreen(),
    SearchScreen(genre: widget.genre),
    FavoriteScreen(),
    MyScreen(),
  ];

  List<String> label = [
    '홈',
    '탐색',
    '관심상품',
    '마이페이지',
  ];
  List<IconData> icons = [
    CupertinoIcons.home,
    CupertinoIcons.search,
    Icons.favorite_border,
    Icons.perm_identity,
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
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: page[currentIndex],
      bottomNavigationBar: bottonBar(),
    );
  }

  Widget bottonBar() {
    return Container(
      decoration: BoxDecoration(color: coverColor),
      alignment: .center,
      height: 90,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          item(0),
          item(1),
          Expanded(
            child: GestureDetector(
              key: ValueKey('add'),
              onTap: () => toPage(context, AddScreen()),
              child: Container(
                alignment: .center,
                decoration: BoxDecoration(
                  color: mainColor,
                  shape: BoxShape.circle,
                ),
                width: 50,
                height: 50,
                child: Icon(
                  CupertinoIcons.add,
                  color: Colors.black,
                  size: 25,
                ),
              ),
            ),
          ),
          item(2),
          item(3),
        ],
      ),
    );
  }

  Widget item(int index) {
    final select = currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => currentIndex = index),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 4,
          children: [
            SizedBox(
              height: 8,
            ),
            Icon(
              icons[index],
              color: select ? mainColor : subColor,
            ),
            Text(
              label[index],
              style: TextStyle(color: select ? mainColor : subColor),
            ),
          ],
        ),
      ),
    );
  }
}
