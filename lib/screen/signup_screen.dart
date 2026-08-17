import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vinyl_groove_test4/controller/auth_controller.dart';
import 'package:vinyl_groove_test4/screen/login_screen.dart';
import 'package:vinyl_groove_test4/utils/info.dart';
import 'package:vinyl_groove_test4/utils/utils.dart';
import 'package:vinyl_groove_test4/utils/widget.dart';

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

  bool obscureText = true;
  bool checkObscureText = true;
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
              child: Container(color: Colors.black.withValues(alpha: 0.3)),
            ),
          ),
          Positioned.fill(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 0, top: 60),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 25,
                      weight: 5,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        logoSession(),
                        input(),
                        SizedBox(height: 55),
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

  Widget logoSession() {
    return Column(
      crossAxisAlignment: .center,
      children: [
        SizedBox(height: 40),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 130),
          child: Image.asset("assets/simbol/logo_horizontal.png"),
        ),
        SizedBox(height: 5),
        Text(
          "Vinyl Record Secondhand Marketplaces",
          style: TextStyle(
            color: subColor,
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 43),
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
            "회원가입",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 24,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "회원 정보를 입력하여 계정을 만들어주세요.",
            style: TextStyle(
              color: subColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 30),
          field(
            text: '이메일',
            controller: email_controller,
            hintText: '이메일을 입력해주세요.',
            icon: Icons.email_outlined,
          ),
          SizedBox(height: 20),
          field(
            text: "비밀번호",
            controller: password_controller,
            hintText: '비밀번호를 입력해주세요.',
            icon: CupertinoIcons.lock,
            hide: obscureText,
            onTap: () => setState(() => obscureText = !obscureText),
          ),
          SizedBox(height: 5),
          Text(
            "*8자 이상, 대소문자, 숫자, 특수문자 포함",
            style: TextStyle(
              color: subColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20),
          field(
            text: "비밀번호 확인",
            controller: password_check_controller,
            hintText: '비밀번호를 다시 입력해주세요.',
            icon: CupertinoIcons.lock,
            hide: checkObscureText,
            onTap: () => setState(() => checkObscureText = !checkObscureText),
          ),
          SizedBox(height: 20),
          field(
            controller: name_controller,
            text: "이름",
            icon: CupertinoIcons.person,
            hintText: '이름을 입력해주세요.',
          ),
          SizedBox(height: 20),
          field(
            text: '휴대폰 번호',
            controller: phone1_controller,
            icon: CupertinoIcons.phone,
            hintText: '',
            phone: true,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                value: check,
                onChanged: (value) => setState(() {
                  check = !check;
                }),
              ),
              Text(
                "이용약관 및 개인정보처리방침에 동의합니다.",
                style: TextStyle(
                  color: subColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          button(
            context: context,
            text: "회원가입",
            onTap: () async {
              if (password_controller.text.trim() !=
                  password_check_controller.text.trim()) {
                showMessage("비밀번호가 일치하지 않습니다.");
                return;
              }
              if (!check) {
                showMessage("이용약관에 동의해주세요.");
                return;
              }

              await authController.signup(
                email_text: email_controller.text.trim(),
                password_text: password_controller.text.trim(),
                name_text: name_controller.text.trim(),
                phone_text:
                    '${phone1_controller.text.trim()}-${phone2_controller.text.trim()}-${phone3_controller.text.trim()}',
              );
              if (authController.error == null) {
                showMessage("회원가입이 완료되었습니다.");
                toPage(context, LoginScreen());
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
              Text(
                "이미 계정이 있으신가요?",
                style: TextStyle(
                  color: subColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(
                  "로그인",
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

  Widget field({
    required String text,
    required TextEditingController? controller,
    required String hintText,
    required IconData icon,
    bool phone = false,
    bool hide = false,
    GestureTapCallback? onTap,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
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
        SizedBox(height: 10),
        if (phone)
          Row(
            spacing: 8,
            children: [
              Flexible(
                flex: 3,
                child: TextFormField(
                  maxLength: 3,
                  textAlign: .center,
                  controller: phone1_controller,
                  focusNode: phone1,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    if (value.length == 3) {
                      FocusScope.of(context).requestFocus(phone2);
                    }
                  },
                  decoration: InputDecoration(
                    counterText: '',
                    fillColor: Color(0xff101113),
                    filled: true,
                    border: border(subColor.withValues(alpha: 0.3)),
                    focusedBorder: border(subColor.withValues(alpha: 0.3)),
                    enabledBorder: border(subColor.withValues(alpha: 0.3)),
                    disabledBorder: border(subColor.withValues(alpha: 0.3)),
                    hint: Text(
                      textAlign: .center,
                      "010",
                      style: TextStyle(
                        color: subColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                "-",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Flexible(
                flex: 4,
                child: TextFormField(
                  maxLength: 4,
                  textAlign: .center,
                  controller: phone2_controller,
                  focusNode: phone2,
                  onChanged: (value) {
                    if (value.length == 4) {
                      FocusScope.of(context).requestFocus(phone3);
                    }
                  },
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    counterText: '',
                    fillColor: Color(0xff101113),
                    filled: true,
                    border: border(subColor.withValues(alpha: 0.3)),
                    focusedBorder: border(subColor.withValues(alpha: 0.3)),
                    enabledBorder: border(subColor.withValues(alpha: 0.3)),
                    disabledBorder: border(subColor.withValues(alpha: 0.3)),
                    hint: Text(
                      textAlign: .center,
                      "1234",
                      style: TextStyle(
                        color: subColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                "-",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Flexible(
                flex: 4,
                child: TextFormField(
                  maxLength: 4,
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
                    counterText: '',
                    fillColor: Color(0xff101113),
                    filled: true,
                    border: border(subColor.withValues(alpha: 0.3)),
                    focusedBorder: border(subColor.withValues(alpha: 0.3)),
                    enabledBorder: border(subColor.withValues(alpha: 0.3)),
                    disabledBorder: border(subColor.withValues(alpha: 0.3)),
                    hint: Text(
                      textAlign: .center,
                      "5678",
                      style: TextStyle(
                        color: subColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        else
          TextFormField(
            controller: controller,
            obscureText: hide,
            decoration: InputDecoration(
              fillColor: Color(0xff101113),
              filled: true,
              border: border(subColor.withValues(alpha: 0.3)),
              focusedBorder: border(subColor.withValues(alpha: 0.3)),
              enabledBorder: border(subColor.withValues(alpha: 0.3)),
              disabledBorder: border(subColor.withValues(alpha: 0.3)),
              hint: Text(
                hintText,
                style: TextStyle(
                  color: subColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              prefixIcon: Icon(icon, color: subColor, size: 25),
              suffixIcon: onTap == null
                  ? null
                  : GestureDetector(
                      onTap: onTap,
                      child: Icon(
                        hide ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                        size: 25,
                        color: subColor,
                      ),
                    ),
            ),
          ),
      ],
    );
  }
}
