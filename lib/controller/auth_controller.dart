import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vinyl_groove_test3/utils/info.dart';
import 'package:vinyl_groove_test3/utils/util.dart';

class AuthController {
  String? error;

  Future<void> login({
    required String emailText,
    required String passwordText,
  }) async {
    final url = Uri.parse("http://$baseUrl/auth/login/v2");
    final res = await http.post(
      url,
      headers: header,
      body: jsonEncode({"email": emailText, "password": passwordText}),
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
    }
  }

  Future<bool> signup({
    required String emailText,
    required String passwordText,
    required String nameText,
    required String phoneText,
  }) async {
    final url = Uri.parse("http://$baseUrl/auth/signup");
    final res = await http.post(
      url,
      headers: header,
      body: jsonEncode({
        "email": emailText,
        "password": passwordText,
        "name": nameText,
        "phone": phoneText,
      }),
    );

    // print(url);
    // print(res.statusCode);
    // print(res.body);

    final data = jsonDecode(res.body);
    if (res.statusCode == 200) {
      showMessage("회원가입이 완료되었습니다.");
      return true;
    } else {
      error = (data['errors'] as List).first['message'];
      showMessage(error!);
      return false;
    }
  }

  Future<void> logout() async {
    token = '';
    userId = 0;
    email = '';
    name = '';
  }
}
