import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vinyl_groove2/screen/app/home_screen.dart';
import 'package:vinyl_groove2/screen/app/my_screen.dart';
import 'package:vinyl_groove2/screen/app/search_screen.dart';
import 'package:vinyl_groove2/urils/info.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key, this.index = 0, this.genre});

  final int index;
  final String? genre;

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  late List<Widget> pages = [
    HomeScreen(),
    SearchScreen(genre: widget.genre),
    MyScreen(),
  ];
  List<String> label = ['홈', '탐색', '마이페이지'];
  List<IconData> icons = [
    CupertinoIcons.home,
    CupertinoIcons.search,
    Icons.person_outline_outlined,
  ];

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
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
      alignment: Alignment.center,
      height: 90,
      color: coverColor,
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
