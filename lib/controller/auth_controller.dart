import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vinyl_groove_test6/uitls/info.dart';
import 'package:vinyl_groove_test6/uitls/utils.dart';

class AuthController {
  String? error;

  Future<void> login({
    required String emailText,
    required String passwordText,
  }) async {
    error = null;

    final url = Uri.parse("http://$baseUrl/auth/login/v2");
    final res = await http.post(
      url,
      headers: headers,
      body: jsonEncode({
        "email": emailText,
        "password": passwordText,
      }),
    );

    // print(url);
    // print(res.statusCode);
    // print(res.body);

    final data = jsonDecode(res.body);
    if (res.statusCode == 200) {
      token = data['data']['token'];

      id = data['data']['user']['id'];
      email = data['data']['user']['email'];
      name = data['data']['user']['name'];
    } else {
      error = (data['errors'] as List).toList().first['message'];
      showMessage(text: error!);
    }
  }

  Future<bool> signup({
    required String email_text,
    required String password_text,
    required String name_text,
    required String phone_text,
  }) async {
    error = null;

    final url = Uri.parse("http://$baseUrl/auth/signup");
    final res = await http.post(
      url,
      headers: headers,
      body: jsonEncode({
        "email": email_text,
        "password": password_text,
        "name": name_text,
        "phone": phone_text,
      }),
    );

    // print(url);
    // print(res.statusCode);
    // print(res.body);

    final data = jsonDecode(res.body);
    if (res.statusCode == 200) {
      showMessage(text: "회원가입이 완료되었습니다.");
      return true;
    } else {
      error = (data['errors'] as List).toList().first['message'];
      showMessage(text: error!);
      return false;
    }
  }

  Future<void> logout() async {
    token = '';
    id = 0;
    email = '';
    name = '';
  }
}
