import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vinyl_groove_test7/controller/auth_controller.dart';
import 'package:vinyl_groove_test7/screen/app/app_screen.dart';
import 'package:vinyl_groove_test7/screen/signup_screen.dart';
import 'package:vinyl_groove_test7/utils/info.dart';
import 'package:vinyl_groove_test7/utils/utils.dart';
import 'package:vinyl_groove_test7/utils/widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthController authController = AuthController();
  TextEditingController email_controller = TextEditingController(text: 'test@example.com');
  TextEditingController password_controller = TextEditingController(text: 'Test1234!');

  bool hide = true;

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
        alignment: .topCenter,
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Image.asset(
              "assets/images/background.png",
              fit: .fitWidth,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 3, sigmaX: 3),
              child: Container(
                color: Colors.black.withValues(alpha: 0.3),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  logo(),
                  inPut(),
                  action_button(),
                  SizedBox(height: 20),
                  Row(
                    spacing: 14,
                    children: [
                      Expanded(child: Divider(color: subColor)),
                      Text(
                        "또는",
                        style: TextStyle(
                          color: subColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 14.5,
                        ),
                      ),
                      Expanded(child: Divider(color: subColor)),
                    ],
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 14,
                    children: [
                      Text(
                        "계정이 없으신가요?",
                        style: TextStyle(
                          color: subColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.5,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => toPage(context, SignupScreen()),
                        child: Text(
                          "회원가입",
                          style: TextStyle(
                            color: mainColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 14.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget logo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: .center,
      children: [
        SizedBox(width: MediaQuery.widthOf(context)),
        SizedBox(height: 40),
        Image.asset("assets/simbol/logo_horizontal.png", width: 220),
        SizedBox(height: 10),
        Text(
          'Vinyl Record Secondhand Marketplace',
          style: TextStyle(
            color: subColor,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
        SizedBox(height: 40),
      ],
    );
  }

  inPut() {
    return Column(
      crossAxisAlignment: .start,
      children: [
        SizedBox(height: 20),
        Text(
          "로그인",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24),
        ),
        SizedBox(height: 12),
        Text(
          "계정으로 로그인하여 다양한 서비스를 이용하세요.",
          style: TextStyle(
            color: subColor,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 25),
        TextFormField(
          controller: email_controller,
          decoration: InputDecoration(
            fillColor: Color(0xff101113),
            filled: true,
            border: border(subColor.withValues(alpha: 0.5)),
            disabledBorder: border(subColor.withValues(alpha: 0.5)),
            enabledBorder: border(subColor.withValues(alpha: 0.5)),
            focusedBorder: border(subColor.withValues(alpha: 0.5)),
            hint: Text(
              '이메일을 입력해주세요.',
              style: TextStyle(color: subColor, fontSize: 16),
            ),
            prefixIcon: Icon(Icons.email_outlined, color: subColor, size: 25),
          ),
        ),
        SizedBox(height: 12),

        TextFormField(
          controller: password_controller,
          obscureText: hide,
          decoration: InputDecoration(
            fillColor: Color(0xff101113),
            filled: true,
            border: border(subColor.withValues(alpha: 0.5)),
            disabledBorder: border(subColor.withValues(alpha: 0.5)),
            enabledBorder: border(subColor.withValues(alpha: 0.5)),
            focusedBorder: border(subColor.withValues(alpha: 0.5)),
            prefixIcon: Icon(CupertinoIcons.lock, color: subColor, size: 25),
            hint: Text(
              '비밀번호를 입력해주세요.',
              style: TextStyle(color: subColor, fontSize: 16),
            ),
            suffixIcon: GestureDetector(
              onTap: () => setState(() => hide = !hide),
              child: Icon(
                !hide ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                color: subColor,
                size: 25,
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        Align(
          alignment: .centerRight,
          child: GestureDetector(
            onTap: () => show_message(),
            child: Text(
              '비밀번호를 잊으셨나요?',
              style: TextStyle(
                color: subColor,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        SizedBox(height: 25),
      ],
    );
  }

  Widget action_button() {
    return button(
      context,
      text: '로그인',
      onTap: () async {
        await authController.login(
          email_text: email_controller.text.trim(),
          password_text: password_controller.text.trim(),
        );

        if (isLogin) toPage(context, AppScreen(index: 0));
      },
    );
  }
}
