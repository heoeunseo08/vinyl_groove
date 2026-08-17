import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vinyl_groove_test3/controller/auth_controller.dart';
import 'package:vinyl_groove_test3/screen/add_product_screen.dart';
import 'package:vinyl_groove_test3/screen/login_screen.dart';
import 'package:vinyl_groove_test3/screen/my_product_screen.dart';
import 'package:vinyl_groove_test3/utils/info.dart';
import 'package:vinyl_groove_test3/utils/util.dart';

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
        backgroundColor: bgColor,
        surfaceTintColor: bgColor,
        automaticallyImplyLeading: false,
        title: Text(
          "마이페이지",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            infoBox(),
            SizedBox(height: 30),
            menuButton(
              text: '상품 등록',
              icon: Icons.add,
              onTap: () => toPage(context: context,page: AddProductScreen()),
            ),
            SizedBox(height: 23),
            menuButton(
              text: '내 등록 상품',
              icon: Icons.inventory_2_outlined,
              onTap: () => toPage(context: context,page:  MyProductScreen()),
            ),
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Divider(color: subColor.withValues(alpha: 0.1)),
            ),
            menuButton(
              text: '판매 내역',
              icon: Icons.shopping_bag_outlined,
              onTap: () => showMessage('해당 기능은 준비 중입니다.'),
            ),
            SizedBox(height: 23),
            menuButton(
              text: '구매 내역',
              icon: Icons.history,
              onTap: () => showMessage('해당 기능은 준비 중입니다.'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Divider(color: subColor.withValues(alpha: 0.1)),
            ),
            menuButton(
              text: '고객센터',
              icon: Icons.help_outline,
              onTap: () => showMessage('해당 기능은 준비 중입니다.'),
            ),
            SizedBox(height: 23),
            menuButton(
              text: '앱 정보',
              icon: Icons.info_outline,
              onTap: () => showMessage('해당 기능은 준비 중입니다.'),
            ),

            SizedBox(height: 30),
            logoutButton(),
          ],
        ),
      ),
    );
  }

  Widget menuButton({
    required String text,
    required IconData icon,
    required GestureTapCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: subColor, size: 27),
              SizedBox(width: 12),
              Text(
                text,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ],
          ),
          Icon(Icons.arrow_forward_ios_outlined, color: subColor, size: 16),
        ],
      ),
    );
  }

  Widget infoBox() {
    return Container(
      width: MediaQuery.widthOf(context),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: coverColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: mainColor.withValues(alpha: 0.2),
            ),
            width: 65,
            height: 65,
            child: Icon(CupertinoIcons.person, color: mainColor, size: 35),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
              ),
              Text(
                email,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: subColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget logoutButton() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        showDialog(context: context, builder: (context) => AlertDialog(
          title:  Text("로그아웃"),
          content:  Text("정말 로그아웃 하시겠습니까?"),
          actions: [
            GestureDetector(onTap: () {
              Navigator.pop(context);
            }, child: Text('취소')),
            GestureDetector(onTap: () async{
              await authController.logout();
              setState(() {});
              Navigator.pop(context);
              toPage(context: context,page:  LoginScreen());
            }, child: Text('로그아웃')),
          ],
        ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: Colors.red),
        ),
        alignment: Alignment.center,
        child: Text(
          "로그아웃",
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}