
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vinyl_groove2/screen/app/app_screen.dart';
import 'package:vinyl_groove2/urils/info.dart';
import 'package:vinyl_groove2/urils/util.dart';
import 'package:vinyl_groove2/urils/widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> genrePath = [
    'rock.svg',
    'jazz.svg',
    'jazz.svg',
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
          child: Column(
            children: [
              appBar1(),
              SizedBox(height: 4),
              search(),
              SizedBox(height: 20),
              genreSession(),
            ],
          ),
        ),
      ),
    );
  }

  Widget search() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => toPage(context, AppScreen(index: 1)),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: coverColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(CupertinoIcons.search, color: subColor, size: 25),
                SizedBox(width: 8),
                Text(
                  '앨범명, 아티스트 검색',
                  style: TextStyle(
                    color: subColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            Icon(CupertinoIcons.barcode_viewfinder, color: subColor, size: 25),
          ],
        ),
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
            Row(
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

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: coverColor),
                ),
                child: Column(
                  spacing: 4,
                  children: [
                    SvgPicture.asset("assets/icons/${genrePath[index]}"),
                    Text(
                      entry.value == 'Etc' ? '기타' : entry.value,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
