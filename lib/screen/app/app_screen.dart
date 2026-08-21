import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vinyl_groove_test7/screen/app/home_screen.dart';
import 'package:vinyl_groove_test7/screen/app/my_screen.dart';
import 'package:vinyl_groove_test7/screen/app/search_screen.dart';
import 'package:vinyl_groove_test7/utils/info.dart';
import 'package:vinyl_groove_test7/utils/info.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key, required this.index, this.genre});

  final int index;
  final String? genre;

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  int selectIndex = 0;
  late List<Widget> pages = [HomeScreen(), SearchScreen(genre: widget.genre), MyScreen()];

  List<String> label = ['홈', '탐색', '마이페이지'];
  List<IconData> icons = [
    CupertinoIcons.home,
    CupertinoIcons.search,
    Icons.perm_identity,
  ];

  @override
  void initState() {
    super.initState();
    selectIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: pages[selectIndex],
        bottomNavigationBar: bottombar(),
      ),
    );
  }

  Widget? bottombar() {
    return Container(
      height: 70,
      color: coverColor,
      alignment: .center,
      child: Row(
        children: [
          Expanded(child: item(0)),
          Expanded(child: item(1)),
          Expanded(child: item(2)),
        ],
      ),
    );
  }

  Widget item(int index) {
    bool select = index == selectIndex;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => selectIndex = index),
      child: Column(
        spacing: 6,
        mainAxisAlignment: .start,
        children: [
          SizedBox(),
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
    );
  }
}
