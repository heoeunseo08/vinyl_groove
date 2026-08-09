import 'package:flutter/material.dart';
import 'package:vinyl_groove/utils/info.dart';
import 'package:vinyl_groove/utils/utils.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        surfaceTintColor: bgColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "관심 상품",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            PopupMenuButton<String>(
              color: coverColor,

              itemBuilder: (context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  child: GestureDetector(
                    onTap: () {
                      showMessage('모두 읽음');
                    },
                    child: const Text(
                      '모두 읽음',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  child: GestureDetector(
                    onTap: () {
                      showMessage('전체 삭제');
                    },
                    child: Text(
                      '전체 삭제',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
