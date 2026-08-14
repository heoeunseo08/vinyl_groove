import 'dart:convert';
import 'dart:developer';

import 'package:vinyl_groove2/urils/info.dart';
import 'package:http/http.dart' as http;
import 'package:vinyl_groove2/urils/util.dart';

class AuthController {
  String? error;

  Future<void> login({
    required String emailText,
    required String passwordText,
  }) async {
    error = null;

    final uri = Uri.parse("http://$baseUrl/auth/login");
    final res = await http.post(
      uri,
      headers: header,
      body: jsonEncode({"email": emailText, "password": passwordText}),
    );

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
      log(error!);
      await showMessage(error!);
    }
  }

  Future<void> sign_up({
    required String emailText,
    required String passwordText,
    required String nameText,
    required String phoneText,
  }) async {
    error = null;

    final uri = Uri.parse("http://$baseUrl/auth/signup");
    final res = await http.post(
      uri,
      headers: header,
      body: jsonEncode({
        "email": emailText,
        "password": passwordText,
        "name": nameText,
        "phone": phoneText,
      }),
    );

    print(res.statusCode);
    print(res.body);

    final data = jsonDecode(res.body);
    if (res.statusCode == 200) {
    } else {
      error = (data['errors'] as List).first['message'];
      log(error!);
      await showMessage(error!);
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
