import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_test4/controller/alarm_controller.dart';
import 'package:vinyl_groove_test4/model/alarm_model.dart';
import 'package:vinyl_groove_test4/screen/detail_screen.dart';
import 'package:vinyl_groove_test4/utils/info.dart';
import 'package:vinyl_groove_test4/utils/utils.dart';

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
    await AlarmController.alarmController.load();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(),
      body: ListenableBuilder(
        listenable: AlarmController.alarmController,
        builder: (context, child) {
          return AlarmController.alarmController.alarmList.isEmpty
              ? noList(
                  icon: SvgPicture.asset(
                    "assets/icons/notification.svg",
                    color: subColor.withValues(alpha: 0.4),
                    height: 80,
                    width: 80,
                  ),
                  title: '알림이 없습니다.',
                  sub: "관심 상품의 가격이 변경되면 알려드릴게요.",
                  context: context,
                )
              : RefreshIndicator(
                  onRefresh: () => load(),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            final model = AlarmController
                                .alarmController
                                .alarmList[index];
                            return card(model);
                          },
                          separatorBuilder: (context, index) => Divider(
                            color: subColor.withValues(alpha: 0.5),
                          ),
                          itemCount:
                              AlarmController.alarmController.alarmList.length,
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }

  String won(dynamic value) => NumberFormat('#,###').format(value);

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
        await AlarmController.alarmController.read(model.id);
        setState(() {});
        toPage(context, DetailScreen(product_id: model.productId));
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

  Widget conditionTag(String condition) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadiusGeometry.circular(4),
        color: Colors.black,
      ),
      child: Text(
        condition,
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }

  AppBar appbar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "알림",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
          if (AlarmController.alarmController.alarmList.isNotEmpty)
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'readAll') {
                  await AlarmController.alarmController.readAll();
                  if (!mounted) return;
                  setState(() {});
                } else if (value == 'deleteAll') {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('알림 전체 삭제'),
                      content: Text('모든 알림을 삭제하시겠습니까?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text('취소'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text('삭제'),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await AlarmController.alarmController.removeAll();
                    if (!mounted) return;
                    setState(() {});
                  }
                }
              },
              itemBuilder: (context) {
                return [
                  PopupMenuItem(value: 'readAll', child: Text("모두 읽음")),
                  PopupMenuItem(
                    value: 'deleteAll',
                    child: Text("전체 삭제", style: TextStyle(color: Colors.red)),
                  ),
                ];
              },
            ),
        ],
      ),
    );
  }

  Widget noList({
    required SvgPicture icon,
    required String title,
    required String sub,
    required BuildContext context,
  }) {
    return Column(
      spacing: 6,
      crossAxisAlignment: .center,
      mainAxisAlignment: .center,
      children: [
        SizedBox(width: MediaQuery.widthOf(context)),
        icon,
        Text(
          title,
          style: TextStyle(color: subColor, fontSize: 16),
        ),
        Text(
          sub,
          style: TextStyle(
            color: subColor.withValues(alpha: 0.6),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
