import 'package:flutter/material.dart';
import 'package:vinyl_groove_test6/controller/alarm_controller.dart';
import 'package:vinyl_groove_test6/model/alarm_model.dart';
import 'package:vinyl_groove_test6/screen/detail_screen.dart';
import 'package:vinyl_groove_test6/uitls/info.dart';
import 'package:vinyl_groove_test6/uitls/utils.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  Future<void> load() async {
    await alarmController.load();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: alarmController,
      builder: (context, child) {
        return Scaffold(
          appBar: appbar(),
          body: alarmController.alarm_list.isEmpty
              ? noList()
              : RefreshIndicator(
                  onRefresh: () => alarmController.load(),
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      final model = alarmController.alarm_list[index];
                      return card(model);
                    },
                    separatorBuilder: (context, index) => Divider(
                      color: subColor.withValues(alpha: 0.2),
                    ),
                    itemCount: alarmController.alarm_list.length,
                  ),
                ),
        );
      },
    );
  }

  String timeText(String st) {
    final create = DateTime.parse(st).toLocal();
    final diff = DateTime.now().difference(create);

    if (diff.inMinutes < 1) return '방금 전';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    return '${diff.inDays}일 전';
  }

  Widget card(AlarmModel model) {
    final bool priceUpDown = model.title == '가격 인하';

    return GestureDetector(
      onTap: () async {
        await alarmController.read(model.id);
        final res = await toPage(context, DetailScreen(id: model.productId));

        if (res) load();
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        color: !model.isRead
            ? mainColor.withValues(alpha: 0.1)
            : Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      model.albumImage,
                      width: 65,
                      height: 65,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 65,
                        height: 65,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  priceUpDown
                                      ? Icons.arrow_downward
                                      : Icons.arrow_upward,
                                  color: priceUpDown
                                      ? Colors.green
                                      : Colors.red,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  model.title,
                                  style: TextStyle(
                                    color: priceUpDown
                                        ? Colors.green
                                        : Colors.red,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            Row(
                              spacing: 6,
                              children: [
                                Text(
                                  timeText(model.createdAt),
                                  style: TextStyle(
                                    color: subColor,
                                    fontSize: 12,
                                  ),
                                ),
                                if (!model.isRead)
                                  Container(
                                    decoration: BoxDecoration(
                                      color: mainColor,
                                      shape: BoxShape.circle,
                                    ),
                                    width: 8,
                                    height: 8,
                                  ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          '${model.albumName} - ${model.artist}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 6),
                        Row(
                          spacing: 8,
                          children: [
                            Text(
                              "₩${won(model.previousPrice)}",
                              style: TextStyle(
                                color: subColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: subColor,
                              size: 18,
                            ),
                            Text(
                              "₩${won(model.currentPrice)}",
                              style: TextStyle(
                                color: mainColor,
                                fontSize: 13,
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
          ],
        ),
      ),
    );
  }

  Widget noList() => RefreshIndicator(
    onRefresh: () => load(),
    child: SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        spacing: 6,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: MediaQuery.widthOf(context)),
          Icon(
            Icons.notifications_none,
            color: subColor,
            size: 80,
          ),
          Text(
            '알림이 없습니다.',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: subColor,
            ),
          ),
          Text(
            '관심 상품의 가격이 변경되면 알려드릴게요.',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: subColor.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    ),
  );

  PreferredSizeWidget? appbar() => AppBar(
    backgroundColor: bgColor,
    surfaceTintColor: bgColor,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '알림',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        if (alarmController.alarm_list.isNotEmpty)
          PopupMenuButton<String>(
            color: coverColor,
            onSelected: (value) async {
              if (value == 'read') {
                await alarmController.all_read();
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('알림 전체 삭제'),
                    content: Text('알림을 전체 삭제하시겠습니까?'),
                    actions: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text('취소'),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await alarmController.delete();
                          Navigator.pop(context);
                        },
                        child: Text('삭제'),
                      ),
                    ],
                  ),
                );
              }
            },
            itemBuilder: (context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'read',
                child: const Text(
                  '모두 읽음',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              PopupMenuItem<String>(
                value: 'delete',
                child: Text(
                  '전체 삭제',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            ],
          ),
      ],
    ),
  );
}
