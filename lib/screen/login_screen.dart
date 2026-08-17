import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vinyl_groove_test4/controller/auth_controller.dart';
import 'package:vinyl_groove_test4/screen/app/app_screen.dart';
import 'package:vinyl_groove_test4/screen/signup_screen.dart';
import 'package:vinyl_groove_test4/utils/info.dart';
import 'package:vinyl_groove_test4/utils/utils.dart';
import 'package:vinyl_groove_test4/utils/widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthController authController = AuthController();

  TextEditingController email_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();

  bool obscureText = false;

  @override
  void dispose() {
    email_controller.dispose();
    password_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: .symmetric(horizontal: 16),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                "assets/images/background.png",
                fit: .fitWidth,
              ),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaY: 3, sigmaX: 3),
                child: Container(color: Colors.black.withValues(alpha: 0.3)),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 50),
                  logo(),
                  SizedBox(height: 50),
                  input(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget logo() {
    return Column(
      children: [
        SizedBox(width: MediaQuery.widthOf(context)),
        Image.asset(
          "assets/simbol/logo_horizontal.png",
          width: 200,
        ),
        SizedBox(height: 12),
        Text(
          "Vinyl Record Secondhand Marketplace",
          style: TextStyle(
            color: subColor,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget input() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "로그인",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24),
        ),
        SizedBox(height: 6),
        Text(
          "계정으로 로그인하여 다양한 서비스를 이용하세요.",
          style: TextStyle(
            color: subColor,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 22),
        TextFormField(
          controller: email_controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xff101113),
            border: border(subColor.withValues(alpha: 0.4)),
            disabledBorder: border(subColor.withValues(alpha: 0.4)),
            enabledBorder: border(subColor.withValues(alpha: 0.4)),
            focusedBorder: border(subColor.withValues(alpha: 0.4)),
            focusedErrorBorder: border(Colors.red),
            errorBorder: border(Colors.red),
            hint: Text(
              "이메일을 입력해주세요.",
              style: TextStyle(
                color: subColor.withValues(alpha: 0.5),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            prefixIcon: Icon(Icons.email_outlined, color: subColor, size: 25),
          ),
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: password_controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xff101113),
            border: border(subColor.withValues(alpha: 0.4)),
            disabledBorder: border(subColor.withValues(alpha: 0.4)),
            enabledBorder: border(subColor.withValues(alpha: 0.4)),
            focusedBorder: border(subColor.withValues(alpha: 0.4)),
            focusedErrorBorder: border(Colors.red),
            errorBorder: border(Colors.red),
            hint: Text(
              "비밀번호를 입력해주세요.",
              style: TextStyle(
                color: subColor.withValues(alpha: 0.5),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            prefixIcon: Icon(CupertinoIcons.lock, color: subColor, size: 25),
            suffixIcon: GestureDetector(
              onTap: () => setState(() => obscureText = !obscureText),
              child: Icon(
                obscureText ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                color: subColor,
                size: 25,
              ),
            ),
          ),
        ),
        SizedBox(height: 30),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () => showMessage("해당 기능은 아직 준비 중입니다."),
            child: Text(
              "비밀번호를 잊으셨나요?",
              style: TextStyle(
                color: subColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(height: 30),
        button(
          context: context,
          text: "로그인",
          onTap: () async {
            await authController.login(
              email_text: email_controller.text.trim(),
              password_text: password_controller.text.trim(),
            );
            if (isLogin) toPage(context, AppScreen());
          },
        ),
        SizedBox(height: 25),
        Row(
          spacing: 12,
          children: [
            Expanded(child: Divider(color: subColor)),
            Text(
              '또는',
              style: TextStyle(
                color: subColor,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
            Expanded(child: Divider(color: subColor)),
          ],
        ),
        SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 12,
          children: [
            Text('계정이 없으신가요?',style: TextStyle(color: subColor,fontSize: 14,fontWeight: FontWeight.w400)),
            GestureDetector(
                onTap: () => toPage(context, SignupScreen()),
                child: Text('회원가입',style: TextStyle(color: mainColor,fontSize: 14,fontWeight: FontWeight.w700),)),
          ],
        ),
      ],
    );
  }
}
