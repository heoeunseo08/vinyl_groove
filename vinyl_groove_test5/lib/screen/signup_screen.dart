import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vinyl_groove_test5/controller/auth_controller.dart';
import 'package:vinyl_groove_test5/screen/login_screen.dart';

import '../utils/info.dart';
import '../utils/utils.dart';
import '../utils/widget.dart';

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

  Widget mainWidget() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back_ios_new,size: 28)),
              SizedBox(height: 30),
              Align(
                alignment: .center,
                child: Column(
                  crossAxisAlignment: .center,
                  children: [
                    Image.asset(
                      "assets/simbol/logo_horizontal.png",
                      width: 160,
                    ),
                    Text(
                      'Vinyl Record Secondhand Marketplace',
                      style: TextStyle(
                        color: subColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              Text(
                '회원가입',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24),
              ),
              SizedBox(height: 8),
              Text(
                "회원 정보를 입력하여 계정을 만들어주세요.",
                style: TextStyle(
                  color: subColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 30),
              field(
                controller: email_controller,
                text: "이메일",
                hint: '이메일을 입력해주세요.',
                icons: Icons.email_outlined,
              ),
              SizedBox(height: 16),
              passwordField(
                controller: password_controller,
                text: '비밀번호',
                hint: '비밀번호를 입력해주세요.',
                icons: CupertinoIcons.lock,
                obs: obscureText,
                onTap: () => setState(() => obscureText = !obscureText),
              ),
              Text(
                '8자 이상, 대소문자, 숫자, 특수문자 포함',
                style: TextStyle(
                  color: subColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 16),
              passwordField(
                controller: check_password_controller,
                text: '비밀번호 확인',
                hint: '비밀번호를 다시 입력해주세요.',
                icons: CupertinoIcons.lock,
                obs: check_obscureText,
                onTap: () =>
                    setState(() => check_obscureText = !check_obscureText),
              ),
              SizedBox(height: 16),
              field(
                controller: name_controller,
                text: "이름",
                hint: '이름을 입력해주세요.',
                icons: CupertinoIcons.person,
              ),
              SizedBox(height: 16),
              phone_field(),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: check,
                    onChanged: (value) => setState(() => check = !check),
                  ),
                  Text(
                    "이용약관 및 개인정보처리방침에 동의합니다.",
                    style: TextStyle(
                      color: subColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              button(
                context: context,
                text: '회원가입',
                onTap: () async {
                  final error = await confirm();
                  if(error != null) {
                     showMessage(error);
                     return;
                  }

                  final res = await authController.signup(
                    email_text: email_controller.text.trim(),
                    password_text: password_controller.text.trim(),
                    name_text: name_controller.text.trim(),
                    phone_text:
                        '${phone1_controller.text.trim()}-${phone2_controller.text.trim()}-${phone3_controller.text.trim()}',
                  );

                  if (res) topage(context, LoginScreen());
                },
              ),
              SizedBox(height: 35),
              Row(
                spacing: 12,
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
                  GestureDetector(
                    onTap: () => topage(context, LoginScreen()),
                    child: Text(
                      "로그인",
                      style: TextStyle(
                        color: mainColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> confirm() async {
    final password = password_controller.text.trim();
    final check_password = check_password_controller.text.trim();

    if (password != check_password) return '비밀번호와 비밀번호 확인이 일치하지 않습니다.';
    if (!check) return '이용약관 및 개인정보처리방침에 동의해주세요';

    return null;
  }

  Widget field({
    required TextEditingController? controller,
    required String text,
    required String hint,
    required IconData? icons,
  }) {
    return Column(
      spacing: 6,
      children: [
        Row(
          children: [
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
            Text(
              ' *',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
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
              hint,
              style: TextStyle(
                color: subColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            prefixIcon: Icon(
              icons,
              color: subColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget passwordField({
    required TextEditingController? controller,
    required String text,
    required String hint,
    required IconData? icons,
    required bool obs,
    required GestureTapCallback? onTap,
  }) {
    return Column(
      spacing: 6,
      children: [
        Row(
          children: [
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
            Text(
              ' *',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
        TextFormField(
          controller: controller,
          obscureText: obs,
          decoration: InputDecoration(
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
              hint,
              style: TextStyle(
                color: subColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            prefixIcon: Icon(
              icons,
              color: subColor,
            ),
            suffixIcon: GestureDetector(
              onTap: onTap,
              child: Icon(
                obs ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                color: subColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget phone_field() {
    return Column(
      spacing: 6,
      children: [
        Row(
          children: [
            Text(
              "휴대폰 번호",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
            Text(
              ' *',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
        Row(
          spacing: 8,
          children: [
            Flexible(
              flex: 3,
              child: TextFormField(
                controller: phone1_controller,
                focusNode: phone1,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  if (phone1_controller.text.length == 3) {
                    FocusScope.of(context).requestFocus(phone2);
                  }
                },
                textAlign: .center,
                maxLength: 3,
                decoration: InputDecoration(
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
                    "010",
                    textAlign: .center,
                    style: TextStyle(
                      color: subColor,
                      fontWeight: FontWeight.w600,
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
                controller: phone2_controller,
                focusNode: phone2,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  if (phone2_controller.text.length == 4) {
                    FocusScope.of(context).requestFocus(phone3);
                  }
                },
                maxLength: 4,
                textAlign: .center,
                decoration: InputDecoration(
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
                    "1234",
                    textAlign: .center,
                    style: TextStyle(
                      color: subColor,
                      fontWeight: FontWeight.w600,
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
                controller: phone3_controller,
                focusNode: phone3,
                onChanged: (value) {
                  if (phone3_controller.text.length == 4) {
                    phone3.unfocus();
                  }
                },
                textAlign: .center,
                maxLength: 4,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
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
                    "5678",
                    textAlign: .center,
                    style: TextStyle(
                      color: subColor,
                      fontWeight: FontWeight.w600,
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
}
