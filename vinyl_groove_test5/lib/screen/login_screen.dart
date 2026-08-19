import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vinyl_groove_test5/controller/auth_controller.dart';
import 'package:vinyl_groove_test5/screen/app/app_screen.dart';
import 'package:vinyl_groove_test5/screen/signup_screen.dart';
import 'package:vinyl_groove_test5/utils/info.dart';
import 'package:vinyl_groove_test5/utils/utils.dart';
import 'package:vinyl_groove_test5/utils/widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthController authController = AuthController();
  TextEditingController email_controller = TextEditingController(
    text: 'test@example.com'
  );
  TextEditingController password_controller = TextEditingController(
    text: 'Test1234!'
  );

  bool obscureText = true;

  String? emaill_error;
  String? password_error;

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
            child: Image.asset("assets/images/background.png", fit: .fitWidth),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                color: Colors.black.withValues(alpha: 0.3),
              ),
            ),
          ),
          mainWidget(),
        ],
      ),
    );
  }

  String? email_confirm() {
    final text = email_controller.text.trim();

    if (text.isEmpty) return '이메일을 입력해주세요.';
    if (!text.contains('@')) return '이메일에 "@"을 포함해주세요.';
    if (!text.contains('.')) return '이메일에 "."을 포함해주세요.';
    if (text.indexOf('@') > 0 && text[text.indexOf('@') - 1] == '.')
      return '”@“앞에 ”.“은 사용 할 수 없습니다.';

    return null;
  }

  String? password_confirm() {
    final text = password_controller.text.trim();

    if (text.isEmpty) return '비밀번호를 입력해주세요.';
    if (text.length < 6) return '비밀번호는 6자 이상이어야 합니다.';
    if (!text.contains(RegExp(r'[a-z]'))) return '비밀번호는 소문자를 1자 이상 포함해야 합니다.';
    if (!text.contains(RegExp(r'[A-Z]'))) return '비밀번호는 대문자를 1자 이상 포함해야 합니다.';

    return null;
  }

  Widget mainWidget() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Column(
              crossAxisAlignment: .center,
              children: [
                Image.asset(
                  "assets/simbol/logo_horizontal.png",
                  width: 220,
                ),
                Align(
                  alignment: .center,
                  child: Text(
                    'Vinyl Record Secondhand Marketplace',
                    style: TextStyle(
                      color: subColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            Text(
              "로그인",
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24),
            ),
            SizedBox(height: 8),
            Text(
              "계정으로 로그인하여 다양한 서비스를 이용하세요.",
              style: TextStyle(
                color: subColor,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 30),
            TextFormField(
              controller: email_controller,
              decoration: InputDecoration(
                errorText: emaill_error,
                counterText: '',
                filled: true,
                fillColor: Color(0xff101113),
                border: border(subColor.withValues(alpha: 0.3)),
                focusedBorder: border(mainColor),
                focusedErrorBorder: border(mainColor),
                enabledBorder: border(subColor.withValues(alpha: 0.3)),
                disabledBorder: border(subColor.withValues(alpha: 0.3)),
                errorBorder: border(Colors.red),
                hint: Text(
                  '이메일을 입력해주세요.',
                  style: TextStyle(
                    color: subColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: subColor,
                ),
              ),
              maxLines: 1,
              minLines: 1,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: password_controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                errorText: password_error,
                counterText: '',
                filled: true,
                fillColor: Color(0xff101113),
                border: border(subColor.withValues(alpha: 0.3)),
                focusedBorder: border(mainColor),
                focusedErrorBorder: border(mainColor),
                enabledBorder: border(subColor.withValues(alpha: 0.3)),
                disabledBorder: border(subColor.withValues(alpha: 0.3)),
                errorBorder: border(Colors.red),
                hint: Text(
                  '비밀번호를 입력해주세요.',
                  style: TextStyle(
                    color: subColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                prefixIcon: Icon(CupertinoIcons.lock, color: subColor),
                suffixIcon: GestureDetector(
                  onTap: () => setState(() => obscureText = !obscureText),
                  child: Icon(
                    obscureText ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                    color: subColor,
                  ),
                ),
              ),
              maxLines: 1,
              minLines: 1,
            ),
            SizedBox(height: 20),
            Align(
              alignment: .centerRight,
              child: GestureDetector(
                onTap: () => showMessage("해당 기능은 준비 중입니다."),
                child: Text(
                  '비밀번호를 잊으셨나요?',
                  style: TextStyle(
                    color: subColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            button(
              context: context,
              text: '로그인',
              onTap: () async {
                setState(()  {
                  emaill_error = email_confirm();
                  password_error = password_confirm();
                });

                if(emaill_error != null || password_error != null) return;

                await authController.login(
                  emailText: email_controller.text.trim(),
                  passwordText: password_controller.text.trim(),
                );

                if (isLogin) topage(context, AppScreen());
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 12,
              children: [
                Expanded(child: Divider(color: subColor)),
                Text(
                  '또는',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
                Expanded(child: Divider(color: subColor)),
              ],
            ),
            SizedBox(height: 35),
            Row(
              spacing: 12,
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
                GestureDetector(
                  onTap: () => topage(context, SignupScreen()),
                  child: Text(
                    "회원가입",
                    style: TextStyle(
                      color: mainColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
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
