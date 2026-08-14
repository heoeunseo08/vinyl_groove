import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vinyl_groove2/controller/auth_controller.dart';
import 'package:vinyl_groove2/screen/app/app_screen.dart';
import 'package:vinyl_groove2/screen/signup_screen.dart';
import 'package:vinyl_groove2/urils/info.dart';
import 'package:vinyl_groove2/urils/util.dart';
import 'package:vinyl_groove2/urils/widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthController authController = AuthController();
  TextEditingController email_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();

  bool obscureText = true;

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
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Image.asset(
              "assets/images/background.png",
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(color: Colors.black.withValues(alpha: 0.3)),
            ),
          ),
          Positioned.fill(
            child: Column(
              children: [logoSession(), input()],
            ),
          ),
        ],
      ),
    );
  }

  Widget logoSession() {
    return Column(
      crossAxisAlignment: .center,
      children: [
        SizedBox(height: 80),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 100),
          child: Image.asset("assets/simbol/logo_horizontal.png"),
        ),
        SizedBox(height: 5),
        Text(
          "Vinyl Record Secondhand Marketplace",
          style: TextStyle(
            color: subColor,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 80),
      ],
    );
  }

  Widget input() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          SizedBox(width: MediaQuery.widthOf(context)),
          Text(
            "로그인",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 24,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "계정으로 로그인하여 다양한 서비스를 이용하세요.",
            style: TextStyle(
              color: subColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 30),
          TextFormField(
            controller: email_controller,
            decoration: InputDecoration(
              fillColor: Color(0xff101113),
              filled: true,
              border: border(subColor.withValues(alpha: 0.3)),
              focusedBorder: border(subColor.withValues(alpha: 0.3)),
              enabledBorder: border(subColor.withValues(alpha: 0.3)),
              disabledBorder: border(subColor.withValues(alpha: 0.3)),
              hint: Text(
                "이메일을 입력해주세요.",
                style: TextStyle(
                  color: subColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              prefixIcon: Icon(Icons.email_outlined, color: subColor, size: 25),
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: password_controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              fillColor: Color(0xff101113),
              filled: true,
              border: border(subColor.withValues(alpha: 0.3)),
              focusedBorder: border(subColor.withValues(alpha: 0.3)),
              enabledBorder: border(subColor.withValues(alpha: 0.3)),
              disabledBorder: border(subColor.withValues(alpha: 0.3)),
              hint: Text(
                "비밀번호를 입력해주세요.",
                style: TextStyle(
                  color: subColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              prefixIcon: Icon(CupertinoIcons.lock, color: subColor, size: 25),
              suffixIcon: GestureDetector(
                onTap: () => setState(() => obscureText = !obscureText),
                child: Icon(
                  obscureText ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                  size: 25,
                  color: subColor,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Align(
            alignment: .centerRight,
            child: GestureDetector(
              onTap: () => showMessage("이 기능은 준비 중입니다."),
              child: Text(
                "비밀번호를 잊으셨나요?",
                style: TextStyle(
                  color: subColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          SizedBox(height: 35),
          button(
            context: context,
            text: "로그인",
            onTap: () async {
              await authController.login(
                emailText: email_controller.text.trim(),
                passwordText: password_controller.text.trim(),
              );
              if (authController.error == null) {
                toPage(context, AppScreen(index: 0));
              } else {
                showMessage(authController.error!);
                return;
              }
            },
          ),
          SizedBox(height: 30),
          Row(
            spacing: 12,
            mainAxisAlignment: .center,
            children: [
              Expanded(child: Divider(color: subColor)),
              Text(
                "또는",
                style: TextStyle(
                  color: subColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(child: Divider(color: subColor)),
            ],
          ),
          SizedBox(height: 40),
          Row(
            spacing: 12,
            mainAxisAlignment: .center,
            children: [
              Text(
                "계정이 없으신가요?",
                style: TextStyle(
                  color: subColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () => toPage(context, SignupScreen()),
                child: Text(
                  "회원가입",
                  style: TextStyle(
                    color: mainColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
