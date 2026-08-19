import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vinyl_groove_test5/controller/alarm_controller.dart';
import 'package:vinyl_groove_test5/screen/detail_screen.dart';
import 'package:vinyl_groove_test5/utils/info.dart';
import 'package:vinyl_groove_test5/utils/utils.dart';
import 'package:vinyl_groove_test5/utils/widget.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    await alarmController.load();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(),
      body: RefreshIndicator(
        onRefresh: () => load(),
        child: ListenableBuilder(
          listenable: alarmController,
          builder: (context, value) {
            return alarmController.alarm_list.isEmpty
                ? LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: Center(
                            child: noList(
                              context,
                              icons: SvgPicture.asset(
                                "assets/icons/notification.svg",
                                color: subColor,
                                height: 80,
                              ),
                              title: '알림이 없습니다.',
                              sub: '관심 상품의 가격이 변경되면 알려드릴게요.',
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : ListView.separated(
                    itemCount: alarmController.alarm_list.length,
                    itemBuilder: (context, index) => card(index),
                    separatorBuilder: (context, index) => Container(
                      padding: EdgeInsets.symmetric(vertical: 1),
                      width: MediaQuery.widthOf(context),
                      color: subColor.withValues(alpha: 0.2),
                    ),
                  );
          },
        ),
      ),
    );
  }

  String timeText(String createdAt) {
    final create = DateTime.parse(createdAt).toLocal();
    final diff = DateTime.now().difference(create);

    if (diff.inMinutes < 1) return '방금전';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    return '${diff.inDays}일 전';
  }

  Widget card(int index) {
    final model = alarmController.alarm_list[index];
    final down = model.title == '가격인하';
    final double size = 70.0;
    return GestureDetector(
      onTap: () async {
        await alarmController.read(model.id);
        setState(() {});
        topage(context, DetailScreen(id: model.productId));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: model.isRead
              ? Colors.transparent
              : mainColor.withValues(alpha: 0.2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  ClipRRect(
                    child: Image.network(
                      width: size,
                      height: size,
                      model.albumImage,
                      fit: .cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.white,
                        width: size,
                        height: size,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      spacing: 5,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          spacing: 4,
                          children: [
                            Icon(
                              down ? Icons.arrow_downward : Icons.arrow_upward,
                              color: down ? Colors.green : Colors.red,
                              size: 20,
                            ),
                            Text(
                              model.title,
                              style: TextStyle(
                                color: down ? Colors.green : Colors.red,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${model.albumName} - ${model.artist}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          spacing: 8,
                          children: [
                            Text(
                              '₩ ${won(model.previousPrice)}',
                              style: TextStyle(
                                color: subColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: subColor,
                              size: 20,
                            ),
                            Text(
                              '₩${won(model.currentPrice)}',
                              style: TextStyle(
                                color: mainColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              spacing: 4,
              children: [
                Text(
                  timeText(model.createdAt),
                  style: TextStyle(
                    color: subColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (!model.isRead)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: mainColor,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  AppBar appbar() => AppBar(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "알림",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        if (alarmController.alarm_list.isNotEmpty)
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'a') {
                await alarmController.all_read();
                setState(() {});
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("알림 전체 삭제"), content: Text("알림을 전체 삭제하시겠습니까?"),
                    actions: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text('취소'),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await alarmController.all_delete();
                          setState(() {});
                          Navigator.pop(context);
                        },
                        child: Text('삭제'),
                      ),
                    ],
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'a',
                child: Text(
                  '모두 읽음',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
              ),
              PopupMenuItem<String>(
                value: 'b',
                child: Text(
                  '전체 삭제',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
      ],
    ),
  );
}
