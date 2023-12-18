import 'dart:convert';
import 'package:dotenv/dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Authentication {
  DotEnv env = DotEnv(includePlatformEnvironment: true)..load();

  Future<bool> getToken({required String username, required String password}) async {
    Uri url = Uri.parse(
        env['AUTH_URL']!,);
    http.Response response = await http.post(url,
        headers: <String, String>{'content_type': 'application/x-www-form-urlencoded'},
        encoding: Encoding.getByName('utf-8'),
        body: <String, String>{
          'grant_type': 'password',
          'username': username,
          'password': password,
          'client_id': env['CLIENT_ID']!,
          'client_secret': env['CLIENT_SECRET']!,
        },);

    if (response.statusCode == 200 || response.statusCode == 204 || response.statusCode == 201) {
      String json = response.body;
      dynamic token = jsonDecode(json)['access_token'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      return true;
    } else {
      return false;
    }
  }
}
