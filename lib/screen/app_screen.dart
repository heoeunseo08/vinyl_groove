import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vinyl_groove/screen/favorite_screen.dart';
import 'package:vinyl_groove/screen/home_screen.dart';
import 'package:vinyl_groove/screen/my_screen.dart';
import 'package:vinyl_groove/screen/search_screen.dart';
import 'package:vinyl_groove/utils/info.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key, this.index = 0, this.genre});

  final int index;
  final String? genre;

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  int currentIndex = 0;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: bottomBar(),
    );
  }

  Widget bottomBar() {
    return Container(
      height: 80,
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(color: coverColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: item(index: 0, label: labels[0], icon: icons[0]),
          ),
          Expanded(
            child: item(index: 1, label: labels[1], icon: icons[1]),
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
