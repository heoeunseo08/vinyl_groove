import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vinyl_groove_test4/screen/app/home_screen.dart';
import 'package:vinyl_groove_test4/screen/app/my_screen.dart';
import 'package:vinyl_groove_test4/screen/app/search_screen.dart';
import 'package:vinyl_groove_test4/utils/info.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key, this.index = 0, this.genre});

  final int index;
  final String? genre;

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  int currentIndex = 0;

  List<Widget> get page => [
    HomeScreen(),
    SearchScreen(genre: widget.genre),
    MyScreen(),
  ];

  List<String> label = ['홈', '탐색', '마이페이지'];
  List<IconData> icons = [
    Icons.home_outlined,
    CupertinoIcons.search,
    Icons.person_outline_outlined,
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: page[currentIndex],
      bottomNavigationBar: bottomBar(),
    );
  }

  Widget bottomBar() {
    return Container(
      height: 90,
      decoration: BoxDecoration(color: coverColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: item(0)),
          Expanded(child: item(1)),
          Expanded(child: item(2)),
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
        spacing: 3,
        children: [
          SizedBox(height: 8),
          Icon(icons[index], color: select ? mainColor : subColor, size: 25),
          Text(
            label[index],
            style: TextStyle(
              color: select ? mainColor : subColor,
            ),
          ),
        ],
      ),
    );
  }
}
