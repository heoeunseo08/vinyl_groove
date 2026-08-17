import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vinyl_groove_test3/controller/auth_controller.dart';
import 'package:vinyl_groove_test3/screen/app/app_screen.dart';
import 'package:vinyl_groove_test3/screen/login_screen.dart';
import 'package:vinyl_groove_test3/utils/info.dart';
import 'package:vinyl_groove_test3/utils/util.dart';
import 'package:vinyl_groove_test3/utils/widget.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  AuthController authController = AuthController();
  TextEditingController email_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();
  TextEditingController password_check_controller = TextEditingController();
  TextEditingController name_controller = TextEditingController();
  TextEditingController phone1_controller = TextEditingController();
  TextEditingController phone2_controller = TextEditingController();
  TextEditingController phone3_controller = TextEditingController();

  FocusNode phone1 = FocusNode();
  FocusNode phone2 = FocusNode();
  FocusNode phone3 = FocusNode();

  bool obscureText = false;
  bool checkObscureText = false;
  bool check = false;

  @override
  void dispose() {
    email_controller.dispose();
    password_controller.dispose();
    password_check_controller.dispose();
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
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 27,
                    ),
                  ),
                ),
                SizedBox(height: 50),
                logo(),
                SizedBox(height: 30),
                Expanded(child: input()),
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
          width: 170,
        ),
        SizedBox(height: 12),
        Text(
          "Vinyl Record Secondhand Marketplace",
          style: TextStyle(
            color: subColor,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget input() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '회원가입',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24),
            ),
            SizedBox(height: 12),
            Text(
              '회원 정보를 입력하여 계정을 만들어주세요.',
              style: TextStyle(
                color: subColor,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 25),
            field(
              controller: email_controller,
              text: '이메일',
              icon: Icons.email_outlined,
              hintText: '이메일을 입력해주세요.',
            ),
            SizedBox(height: 16),
            passwordField(
              controller: password_controller,
              obl: obscureText,
              oblTap: () => setState(() => obscureText = !obscureText),
              text: '비밀번호',
              icon: CupertinoIcons.lock,
              hintText: '비밀번호를 입력해주세요.',
            ),
            SizedBox(height: 3),
            Text(
              "8자 이상, 대소문자, 숫자, 특수문자 포함",
              style: TextStyle(color: subColor,fontWeight: FontWeight.w600, fontSize: 12),
            ),
            SizedBox(height: 16),
            passwordField(
              controller: password_check_controller,
              obl: checkObscureText,
              oblTap: () =>
                  setState(() => checkObscureText = !checkObscureText),
              text: '비밀번호 확인',
              icon: CupertinoIcons.lock,
              hintText: '비밀번호를 다시 입력해주세요.',
            ),
            SizedBox(height: 16),
            field(
              controller: name_controller,
              text: '이름',
              icon: CupertinoIcons.person,
              hintText: '이름을 입력해주세요.',
            ),
            SizedBox(height: 16),
            phoneField(),
            SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: check,
                  onChanged: (value) => setState(() {
                    check = !check;
                  }),
                ),
                Text(
                  '이용약관 및 개인정보처리방침에 동의합니다.',
                  style: TextStyle(
                    color: subColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            button(
              context: context,
              text: "회원가입",
              onTap: () async {
                if (!check) {
                  showMessage(" 이용약관에 동의해 주세요.");
                  return;
                }
                if (password_controller.text !=
                    password_check_controller.text) {
                  showMessage("비밀번호가 일치하지 않습니다.");
                  return;
                }

                final res = await authController.signup(
                  emailText: email_controller.text.trim(),
                  passwordText: password_controller.text.trim(),
                  nameText: name_controller.text.trim(),
                  phoneText:
                      '${phone1_controller.text.trim()}-${phone2_controller.text.trim()}-${phone3_controller.text.trim()}',
                );

                if (res) toPage(context: context, page: LoginScreen());
              },
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "이미 계정이 있으신가요?",
                  style: TextStyle(
                    color: subColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 12),
                GestureDetector(
                  onTap: () => toPage(context: context, page: LoginScreen()),
                  child: Text(
                    "로그인",
                    style: TextStyle(
                      color: mainColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 14.5,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget field({
    required TextEditingController? controller,
    required String text,
    required IconData? icon,
    required String hintText,
  }) {
    return Column(
      spacing: 4,
      children: [
        Row(
          children: [
            Text(
              text,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            Text(
              ' *',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: coverColor,
            border: border(coverColor),
            disabledBorder: border(coverColor),
            focusedBorder: border(coverColor),
            enabledBorder: border(coverColor),
            errorBorder: border(Colors.red),
            focusedErrorBorder: border(Colors.red),
            prefixIcon: Icon(icon, color: subColor),
            hint: Text(
              hintText,
              style: TextStyle(
                color: subColor,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget phoneField() {
    return Column(
      spacing: 4,
      children: [
        Row(
          children: [
            Text(
              "휴대폰 번호",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            Text(
              ' *',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
        Row(
          spacing: 4,
          children: [
            Flexible(
              flex: 3,
              child: TextFormField(
                textAlign: .center,
                controller: phone1_controller,
                focusNode: phone1,
                onChanged: (value) {
                  if (phone1_controller.text.length == 3) {
                    FocusScope.of(context).requestFocus(phone2);
                  }
                },
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  filled: true,
                  fillColor: coverColor,
                  border: border(coverColor),
                  disabledBorder: border(coverColor),
                  focusedBorder: border(coverColor),
                  enabledBorder: border(coverColor),
                  errorBorder: border(Colors.red),
                  focusedErrorBorder: border(Colors.red),
                  hint: Text(
                    textAlign: .center,
                    '010',
                    style: TextStyle(
                      color: subColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            Text('-'),
            Flexible(
              flex: 4,
              child: TextFormField(
                textAlign: .center,
                controller: phone2_controller,
                focusNode: phone2,
                onChanged: (value) {
                  if (phone2_controller.text.length == 4) {
                    FocusScope.of(context).requestFocus(phone3);
                  }
                },
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  filled: true,
                  fillColor: coverColor,
                  border: border(coverColor),
                  disabledBorder: border(coverColor),
                  focusedBorder: border(coverColor),
                  enabledBorder: border(coverColor),
                  errorBorder: border(Colors.red),
                  focusedErrorBorder: border(Colors.red),
                  hint: Text(
                    textAlign: .center,
                    '1234',
                    style: TextStyle(
                      color: subColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            Text('-'),
            Flexible(
              flex: 4,
              child: TextFormField(
                textAlign: .center,
                controller: phone3_controller,
                focusNode: phone3,
                onChanged: (value) {
                  if (value.length == 4) {
                    phone3.unfocus();
                  }
                },
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  filled: true,
                  fillColor: coverColor,
                  border: border(coverColor),
                  disabledBorder: border(coverColor),
                  focusedBorder: border(coverColor),
                  enabledBorder: border(coverColor),
                  errorBorder: border(Colors.red),
                  focusedErrorBorder: border(Colors.red),
                  hint: Text(
                    textAlign: .center,
                    '5678',
                    style: TextStyle(
                      color: subColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget passwordField({
    required TextEditingController? controller,
    required bool obl,
    required GestureTapCallback? oblTap,
    required String text,
    required IconData? icon,
    required String hintText,
  }) {
    return Column(
      spacing: 4,
      children: [
        Row(
          children: [
            Text(
              text,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            Text(
              ' *',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
        TextFormField(
          controller: controller,
          obscureText: obl,
          decoration: InputDecoration(
            filled: true,
            fillColor: coverColor,
            border: border(coverColor),
            disabledBorder: border(coverColor),
            focusedBorder: border(coverColor),
            enabledBorder: border(coverColor),
            errorBorder: border(Colors.red),
            focusedErrorBorder: border(Colors.red),
            prefixIcon: Icon(icon, color: subColor),
            suffixIcon: GestureDetector(
              onTap: oblTap,
              child: Icon(
                obl ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                color: subColor,
              ),
            ),
            hint: Text(
              hintText,
              style: TextStyle(
                color: subColor,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
