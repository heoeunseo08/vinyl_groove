import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vinyl_groove/controller/auth_controller.dart';
import 'package:vinyl_groove/screen/app_screen.dart';
import 'package:vinyl_groove/screen/sign_up_screen.dart';
import 'package:vinyl_groove/utils/info.dart';
import 'package:vinyl_groove/utils/utils.dart';
import 'package:vinyl_groove/utils/widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthController authController = AuthController();
  TextEditingController email_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();
  String? email_error;
  String? password_error;

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
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50),
                logo(),
                SizedBox(height: 30),
                input(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget logo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
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
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  String? email_confirm(String email) {
    if (email.isEmpty) return '이메일을 입력해주세요.';
    if (!email.contains('@')) return '이메일에 "@"를 포함해주세요.';
    if (!email.contains('.')) return '이메일에 "."를 포함해주세요.';
    if (email.indexOf('@') > 0 && email[email.indexOf('@') - 1] == '.')
      return '"@" 앞에 "."을 사용할 수 없습니다.';

    return null;
  }

  String? password_confirm(String password) {
    if (password.isEmpty) return '비밀번호를 입력해주세요.';
    if (password.length < 6) return '비밀번호는 6자 이상입니다.';
    if (!password.contains(RegExp(r'[A-Z]'))) return '대문자를 1자 이상 포함해주세요.';
    if (!password.contains(RegExp(r'[a-z]'))) return '소문자를 1자 이상 포함해주세요.';

    return null;
  }

  Widget input() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '로그인',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24),
          ),
          SizedBox(height: 12),
          Text(
            '계정으로 로그인하여 다양한 서비스를 이용하세요.',
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
              errorText: email_error,
              filled: true,
              fillColor: coverColor,
              border: border(coverColor),
              disabledBorder: border(coverColor),
              focusedBorder: border(coverColor),
              enabledBorder: border(coverColor),
              errorBorder: border(Colors.red),
              focusedErrorBorder: border(Colors.red),
              prefixIcon: Icon(
                Icons.email_outlined,
                color: subColor,
              ),
              hint: Text(
                "이메일을 입력해주세요.",
                style: TextStyle(
                  color: subColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: password_controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              errorText: password_error,
              filled: true,
              fillColor: coverColor,
              border: border(coverColor),
              disabledBorder: border(coverColor),
              focusedBorder: border(coverColor),
              enabledBorder: border(coverColor),
              errorBorder: border(Colors.red),
              focusedErrorBorder: border(Colors.red),
              prefixIcon: Icon(CupertinoIcons.lock, color: subColor),
              suffixIcon: GestureDetector(
                onTap: () => setState(() => obscureText = !obscureText),
                child: Icon(
                  obscureText ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                  color: subColor,
                ),
              ),
              hint: Text(
                "비밀번호를 입력해주세요.",
                style: TextStyle(
                  color: subColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          SizedBox(height: 25),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => showMessage("아직 준비중입니다."),
              child: Text(
                '비밀번호를 잊으셨나요?',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(height: 40),
          button(
            context: context,
            text: "로그인",
            onTap: () async {
              setState(() {
                email_error = email_confirm(email_controller.text.trim());
                password_error = password_confirm(
                  password_controller.text.trim(),
                );
              });

              if (email_error != null || password_error != null) return;

              await authController.login(
                emailText: email_controller.text.trim(),
                passwordText: password_controller.text.trim(),
              );

              if (isLogin) toPage(context, AppScreen());
            },
          ),
          SizedBox(height: 20),
          Row(
            spacing: 12,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Divider(color: subColor, height: 1)),
              Text(
                "또는",
                style: TextStyle(
                  color: subColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              Expanded(child: Divider(color: subColor, height: 1)),
            ],
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "계정이 없으신가요?",
                style: TextStyle(
                  color: subColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              SizedBox(width: 12),
              GestureDetector(
                onTap: () => toPage(context, SignUpScreen()),
                child: Text(
                  "회원가입",
                  style: TextStyle(
                    color: mainColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 14.5,
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
