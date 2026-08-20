import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vinyl_groove_test6/controller/auth_controller.dart';
import 'package:vinyl_groove_test6/screen/add_screen.dart';
import 'package:vinyl_groove_test6/screen/login_screen.dart';
import 'package:vinyl_groove_test6/screen/product_screen.dart';
import 'package:vinyl_groove_test6/uitls/info.dart';
import 'package:vinyl_groove_test6/uitls/utils.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  AuthController authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "마이페이지",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            infoCard(),
            SizedBox(height: 30),
            button(
              onTap: () => toPage(context, AddScreen()),
              text: '상품 등록',
              icons: Icons.add,
            ),
            SizedBox(height: 16),
            button(
              onTap: () => toPage(context, ProductScreen()),
              text: '내 등록 상품',
              icons: Icons.inventory_2_outlined,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Divider(color: subColor.withValues(alpha: 0.2)),
            ),

            add(),
            SizedBox(height: 35),
            logout(),
          ],
        ),
      ),
    );
  }

  Widget button({
    required GestureTapCallback onTap,
    required String text,
    required IconData icons,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 12,
              children: [
                Icon(icons, size: 25),
                Text(
                  text,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),

            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15,
            ),
          ],
        ),
      ),
    );
  }

  Widget add() {
    return Column(
      spacing: 16,
      children: [
        button(
          onTap: () => showMessage(text: "판매 내역 기능은 아직 준비 중입니다."),
          text: '판매 내역',
          icons: Icons.shopping_bag_outlined,
        ),
        button(
          onTap: () => showMessage(text: "구매 내역 기능은 아직 준비 중입니다."),
          text: '구매 내역',
          icons: Icons.history,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Divider(color: subColor.withValues(alpha: 0.2)),
        ),
        button(
          onTap: () => showMessage(text: "고객센터 기능은 아직 준비 중입니다."),
          text: '고객센터',
          icons: CupertinoIcons.question_circle,
        ),
        button(
          onTap: () => showMessage(text: "앱 정보 기능은 아직 준비 중입니다."),
          text: '앱 정보',
          icons: CupertinoIcons.info,
        ),
      ],
    );
  }

  Widget infoCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: coverColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: mainColor.withOpacity(0.3),
            ),
            child: Icon(
              Icons.person,
              color: mainColor,
              size: 40,
            ),
          ),
          SizedBox(width: 10),
          Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              Text(
                email,
                style: TextStyle(
                  color: subColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget logout() {
    return GestureDetector(
      onTap: () async {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("로그아웃"),
            content: Text("정말 로그아웃 하시겠습니까?"),
            actions: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text('최소'),
              ),
              GestureDetector(
                onTap: () async {
                  await authController.logout();
                  Navigator.pop(context);
                },
                child: Text(
                  '로그아웃',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );

        if (!isLogin) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      },
      child: Container(
        alignment: .center,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text(
          '로그아웃',
          style: TextStyle(
            color: Colors.red,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}