import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vinyl_groove_test4/utils/info.dart';
import 'package:vinyl_groove_test4/utils/utils.dart';

class AuthController {
  String? error;

  Future<void> login({
    required String email_text,
    required String password_text,
  }) async {
    error = null;

    try {
      final url = Uri.parse("http://${baseUrl}/auth/login");
      final res = await http.post(
        url,
        headers: header,
        body: jsonEncode({"email": email_text, "password": password_text}),
      );

      print(url);
      print(res.statusCode);
      print(res.body);

      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        token = data['data']['token'];
        userId = data['data']['user']['id'];
        email = data['data']['user']['email'];
        name = data['data']['user']['name'];
        phone = data['data']['user']['phone'];
      } else {
        error = (data['errors'] as List).first['message'];
        showMessage(error!);
      }
    } catch (e) {
      error = '$e';
      showMessage(error!);
    }
  }

  Future<void> signup({
    required String email_text,
    required String password_text,
    required String name_text,
    required String phone_text,
  }) async {
    error = null;

    try {
      final url = Uri.parse("http://${baseUrl}/auth/signup");
      final res = await http.post(
        url,
        headers: header,
        body: jsonEncode({
          "email": email_text,
          "password": password_text,
          "name": name_text,
          "phone": phone_text,
        }),
      );

      print(url);
      print(res.statusCode);
      print(res.body);

      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        showMessage('회원가입이 완료되었습니다.');
      } else {
        error = (data['errors'] as List).first['message'];
        showMessage(error!);
      }
    } catch (e) {
      error = '$e';
      showMessage(error!);
    }
  }

  Future<void> logout() async {
    token = '';
    userId = 0;
    email = '';
    name = '';
    phone = '';
  }
}
