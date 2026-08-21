import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vinyl_groove_test7/controller/auth_controller.dart';
import 'package:vinyl_groove_test7/screen/login_screen.dart';
import 'package:vinyl_groove_test7/utils/info.dart';
import 'package:vinyl_groove_test7/utils/utils.dart';
import 'package:vinyl_groove_test7/utils/widget.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  AuthController authController = AuthController();

  TextEditingController email_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();
  TextEditingController check_password_controller = TextEditingController();
  TextEditingController name_controller = TextEditingController();
  TextEditingController phone1_controller = TextEditingController();
  TextEditingController phone2_controller = TextEditingController();
  TextEditingController phone3_controller = TextEditingController();

  FocusNode phone1 = FocusNode();
  FocusNode phone2 = FocusNode();
  FocusNode phone3 = FocusNode();

  bool obscureText = true;
  bool check_obscureText = true;
  bool check = false;

  @override
  void dispose() {
    email_controller.dispose();
    password_controller.dispose();
    check_password_controller.dispose();
    name_controller.dispose();
    phone1_controller.dispose();
    phone2_controller.dispose();
    phone3_controller.dispose();
    phone1.dispose();
    phone2.dispose();
    phone3.dispose();
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    logo(),
                    inPut(),
                    action_button(),
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
                        SizedBox(height: 40),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget label(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Text(
          text,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        Text(
          ' *',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ],
    ),
  );

  Widget logo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: .center,
      children: [
        SizedBox(width: MediaQuery.widthOf(context)),
        Align(
          alignment: .centerLeft,
          child: Icon(Icons.arrow_back_ios_new, size: 25),
        ),
        SizedBox(height: 20),
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
        SizedBox(height: 30),
      ],
    );
  }

  inPut() {
    return Column(
      crossAxisAlignment: .start,
      children: [
        SizedBox(height: 20),
        Text(
          "회원가입",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24),
        ),
        SizedBox(height: 12),
        Text(
          "회원 정보를 입력하여 계정을 만들어주세요.",
          style: TextStyle(
            color: subColor,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 25),
        label("이메일"),
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
        SizedBox(height: 20),
        label("비밀번호"),
        TextFormField(
          controller: password_controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            fillColor: Color(0xff101113),
            filled: true,
            border: border(subColor.withValues(alpha: 0.5)),
            disabledBorder: border(subColor.withValues(alpha: 0.5)),
            enabledBorder: border(subColor.withValues(alpha: 0.5)),
            focusedBorder: border(subColor.withValues(alpha: 0.5)),
            hint: Text(
              '비밀번호를 입력해주세요.',
              style: TextStyle(color: subColor, fontSize: 16),
            ),
            prefixIcon: Icon(CupertinoIcons.lock, color: subColor, size: 25),
            suffixIcon: GestureDetector(
              onTap: () => setState(() => obscureText = !obscureText),
              child: Icon(
                obscureText ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                color: subColor,
                size: 25,
              ),
            ),
          ),
        ),
        Text('8자 이상, 대소문자, 숫자, 특수문자 포함',style: TextStyle(color: subColor,fontWeight: FontWeight.w500,fontSize: 14),),
        SizedBox(height: 20),
        label("비밀번호 확인"),
        TextFormField(
          controller: check_password_controller,
          obscureText: check_obscureText,
          decoration: InputDecoration(
            fillColor: Color(0xff101113),
            filled: true,
            border: border(subColor.withValues(alpha: 0.5)),
            disabledBorder: border(subColor.withValues(alpha: 0.5)),
            enabledBorder: border(subColor.withValues(alpha: 0.5)),
            focusedBorder: border(subColor.withValues(alpha: 0.5)),
            hint: Text(
              '비밀번호를 다시 입력해주세요.',
              style: TextStyle(color: subColor, fontSize: 16),
            ),
            prefixIcon: Icon(CupertinoIcons.lock, color: subColor, size: 25),
            suffixIcon: GestureDetector(
              onTap: () => setState(() => check_obscureText = !check_obscureText),
              child: Icon(
                obscureText ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                color: subColor,
                size: 25,
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        label("이름"),
        TextFormField(
          controller: name_controller,
          decoration: InputDecoration(
            fillColor: Color(0xff101113),
            filled: true,
            border: border(subColor.withValues(alpha: 0.5)),
            disabledBorder: border(subColor.withValues(alpha: 0.5)),
            enabledBorder: border(subColor.withValues(alpha: 0.5)),
            focusedBorder: border(subColor.withValues(alpha: 0.5)),
            hint: Text(
              '이름을 입력해주세요.',
              style: TextStyle(color: subColor, fontSize: 16),
            ),
            prefixIcon: Icon(Icons.perm_identity, color: subColor, size: 25),
          ),
        ),
        SizedBox(height: 20),
        label("휴대폰 번호"),
        Row(
          spacing: 10,
          children: [
            Flexible(
              flex: 3,
              child: TextFormField(
                textAlign: .center,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: phone1_controller,
                maxLength: 3,
                focusNode: phone1,
                onChanged: (value) => setState(() {
                  if (phone1_controller.text.length == 3) {
                    FocusScope.of(context).requestFocus(phone2);
                  }
                }),
                decoration: InputDecoration(
                  counterText: '',
                  fillColor: Color(0xff101113),
                  filled: true,
                  border: border(subColor.withValues(alpha: 0.5)),
                  disabledBorder: border(subColor.withValues(alpha: 0.5)),
                  enabledBorder: border(subColor.withValues(alpha: 0.5)),
                  focusedBorder: border(subColor.withValues(alpha: 0.5)),
                  hint: Text(
                    textAlign: .center,
                    '010',
                    style: TextStyle(color: subColor, fontSize: 16),
                  ),
                ),
              ),
            ),
            Text(
              '-',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            Flexible(
              flex: 4,
              child: TextFormField(
                textAlign: .center,
                controller: phone2_controller,
                maxLength: 4,
                focusNode: phone2,
                onChanged: (value) => setState(() {
                  if (phone2_controller.text.length == 4) {
                    FocusScope.of(context).requestFocus(phone3);
                  }
                }),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  counterText: '',
                  fillColor: Color(0xff101113),
                  filled: true,
                  border: border(subColor.withValues(alpha: 0.5)),
                  disabledBorder: border(subColor.withValues(alpha: 0.5)),
                  enabledBorder: border(subColor.withValues(alpha: 0.5)),
                  focusedBorder: border(subColor.withValues(alpha: 0.5)),
                  hint: Text(
                    textAlign: .center,
                    '1234',
                    style: TextStyle(color: subColor, fontSize: 16),
                  ),
                ),
              ),
            ),
            Text(
              '-',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),

            Flexible(
              flex: 4,
              child: TextFormField(
                textAlign: .center,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: phone3_controller,
                maxLength: 4,
                focusNode: phone3,
                onChanged: (value) => setState(() {
                  if (phone3_controller.text.length == 4) {
                    FocusNode().unfocus();
                  }
                }),
                decoration: InputDecoration(
                  counterText: '',
                  fillColor: Color(0xff101113),
                  filled: true,
                  border: border(subColor.withValues(alpha: 0.5)),
                  disabledBorder: border(subColor.withValues(alpha: 0.5)),
                  enabledBorder: border(subColor.withValues(alpha: 0.5)),
                  focusedBorder: border(subColor.withValues(alpha: 0.5)),
                  hint: Text(
                    textAlign: .center,
                    '5678',
                    style: TextStyle(color: subColor, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 25),
        Row(
          children: [
            Checkbox(
              value: check,
              onChanged: (value) => setState(() => check = !check),
            ),
            Text(
              '이용약관 및 개인정보처리방침에 동의합니다.',
              style: TextStyle(
                color: subColor,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ],
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
        if (password_controller.text != check_password_controller.text) {
        show_message(text: "비밀번호가 일치하지 않습니다.");
        return;
      }
      if (!check) {
        show_message(text: "이용약관 및 개인정보처리방침에 동의해주세요.");
        return;
      }
        final res = await authController.signup(
          email_text: email_controller.text.trim(),
          password_text: password_controller.text.trim(),
          name_text: name_controller.text.trim(),
          phone_text:
              '${phone1_controller.text.trim()}-${phone2_controller.text.trim()}-${phone3_controller.text.trim()}',
        );

        if (res) toPage(context, LoginScreen());
      },
    );
  }
}
