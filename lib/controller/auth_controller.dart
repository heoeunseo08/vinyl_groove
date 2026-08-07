import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vinyl_groove/utils/info.dart';
import 'package:vinyl_groove/utils/utils.dart';

class AuthController {
  String? error;

  Future<void> login({
    required String emailText,
    required String passwordText,
  }) async {
    error = null;

    try {
      final url = Uri.parse("http://$baseUrl/auth/login");
      final res = await http.post(
        url,
        headers: header,
        body: jsonEncode({
          "email": "test@example.com",
          "password": "Test1234!",
          // "email": emailText,
          // "password": passwordText,
        }),
      );
      print(res.statusCode);
      print(res.body);

      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        token = data['data']['token'];

        user_id = data['data']['user']['id'];
        email = data['data']['user']['email'];
        name = data['data']['user']['name'];
        phone = data['data']['user']['phone'];
      } else {
        final errors = data['errors'] as List;
        error = errors.map((e) => e['message']).join('\n');
        showMessage(error!);
      }
    } catch (e) {
      error = '$e';
      showMessage(error!);
    }
  }

  Future<void> sign_up({
    required String emailText,
    required String passwordText,
    required String nameText,
    required String phoneText,
  }) async {
    error = null;

    try {
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

      print(res.statusCode);
      print(res.body);

      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
      } else {
        final errors = data['errors'] as List;
        error = errors.map((e) => e['message']).join('\n');
        showMessage(error!);
      }
    } catch (e) {
      error = '$e';
      showMessage(error!);
    }
  }

  Future<void> logout() async {
    token = '';
    user_id = 0;
    email = '';
    name = '';
    phone = '';
  }
}
