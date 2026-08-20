import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vinyl_groove_test6/controller/auth_controller.dart';
import 'package:vinyl_groove_test6/screen/login_screen.dart';
import 'package:vinyl_groove_test6/uitls/info.dart';
import 'package:vinyl_groove_test6/uitls/utils.dart';
import 'package:vinyl_groove_test6/uitls/widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
  bool agree = false;

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
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: 12,
                    vertical: 20,
                  ),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        logo(),
                        SizedBox(height: 10),
                        input(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget label(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          Text(
            " *",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w700,
              fontSize: 14,
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
          width: 160,
        ),
        SizedBox(height: 6),
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

  Widget input() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '회원가입',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24),
          ),
          SizedBox(height: 12),
          Text(
            '회원 접보를 입력하여 계정을 만들어주세요.',
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
          label("비밀번호"),
          TextFormField(
            controller: password_controller,
            obscureText: obscureText,
            decoration: InputDecoration(
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
          SizedBox(height: 8),
          Text(
            "8자 이상, 대소문자, 숫자, 특수문자 포함",
            style: TextStyle(color: subColor, fontSize: 12),
          ),
          SizedBox(height: 16),
          label("비밀번호 확인"),
          TextFormField(
            controller: password_check_controller,
            obscureText: checkObscureText,
            decoration: InputDecoration(
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
                onTap: () =>
                    setState(() => checkObscureText = !checkObscureText),
                child: Icon(
                  checkObscureText
                      ? CupertinoIcons.eye_slash
                      : CupertinoIcons.eye,
                  color: subColor,
                ),
              ),
              hint: Text(
                "비밀번호를 다시 입력해주세요.",
                style: TextStyle(
                  color: subColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          label("이름"),
          TextFormField(
            controller: name_controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: coverColor,
              border: border(coverColor),
              disabledBorder: border(coverColor),
              focusedBorder: border(coverColor),
              enabledBorder: border(coverColor),
              errorBorder: border(Colors.red),
              focusedErrorBorder: border(Colors.red),
              prefixIcon: Icon(
                Icons.person_outline,
                color: subColor,
              ),
              hint: Text(
                "이름을 입력해주세요.",
                style: TextStyle(
                  color: subColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          label("휴대폰 번호"),
          Row(
            spacing: 8,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 3,
                child: TextFormField(
                  focusNode: phone1,
                  controller: phone1_controller,
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: coverColor,
                    border: border(coverColor),
                    disabledBorder: border(coverColor),
                    focusedBorder: border(coverColor),
                    enabledBorder: border(coverColor),
                    errorBorder: border(Colors.red),
                    focusedErrorBorder: border(Colors.red),
                    hint: Text(
                      textAlign: TextAlign.center,
                      "010",
                      style: TextStyle(
                        color: subColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  maxLength: 3,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    if (phone1_controller.text.length == 3) {
                      FocusScope.of(context).requestFocus(phone2);
                    }
                  },
                  textAlign: TextAlign.center,
                ),
              ),
              Text(
                '-',
                style: TextStyle(color: subColor, fontSize: 14),
              ),
              Flexible(
                flex: 4,
                child: TextFormField(
                  focusNode: phone2,
                  controller: phone2_controller,
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: coverColor,
                    border: border(coverColor),
                    disabledBorder: border(coverColor),
                    focusedBorder: border(coverColor),
                    enabledBorder: border(coverColor),
                    errorBorder: border(Colors.red),
                    focusedErrorBorder: border(Colors.red),
                    hint: Text(
                      textAlign: TextAlign.center,
                      "1234",
                      style: TextStyle(
                        color: subColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  textAlign: TextAlign.center,
                  maxLength: 4,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    if (phone2_controller.text.length == 4) {
                      FocusScope.of(context).requestFocus(phone3);
                    }
                  },
                ),
              ),
              Text(
                '-',
                style: TextStyle(color: subColor, fontSize: 14),
              ),
              Flexible(
                flex: 4,
                child: TextFormField(
                  focusNode: phone3,
                  controller: phone3_controller,
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: coverColor,
                    border: border(coverColor),
                    disabledBorder: border(coverColor),
                    focusedBorder: border(coverColor),
                    enabledBorder: border(coverColor),
                    errorBorder: border(Colors.red),
                    focusedErrorBorder: border(Colors.red),
                    hint: Text(
                      textAlign: TextAlign.center,
                      "5678",
                      style: TextStyle(
                        color: subColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  textAlign: TextAlign.center,
                  maxLength: 4,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    if (phone3_controller.text.length == 4) {
                      phone3.unfocus();
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(
            children: [
              Checkbox(
                onChanged: (value) => setState(() => agree = !agree),
                value: agree,
              ),
              Text(
                "이용약관 및 개인전보처리방침에 동의합니다.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
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
              if (password_controller.text != password_check_controller.text) {
                showMessage(text: "비밀번호가 일치하지 않습니다.");
                return;
              }
              if (!agree) {
                showMessage(text: "이용약관 및 개인정보처리방침에 동의해주세요.");
                return;
              }
              await authController.signup(
                email_text: email_controller.text.trim(),
                password_text: password_controller.text.trim(),
                name_text: name_controller.text.trim(),
                phone_text:
                    "${phone1_controller.text.trim()}-${phone2_controller.text.trim()}-${phone3_controller.text.trim()}",
              );
              if (authController.error == null) {
                showMessage(text: "회원가입이 완료되었습니다.");
                Navigator.pop(context);
              }
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
                onTap: () => toPage(context, LoginScreen()),
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
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
