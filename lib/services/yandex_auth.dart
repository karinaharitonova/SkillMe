import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class YandexAuth {
  static Future<String?> signIn() async {
    final clientId = "ВАШ_CLIENT_ID_ОТ_ЯНДЕКСА";
    final redirectUri = "myapp://auth";

    final url =
        "https://oauth.yandex.ru/authorize?response_type=token&client_id=$clientId&redirect_uri=$redirectUri";

    final result = await FlutterWebAuth2.authenticate(
      url: url,
      callbackUrlScheme: "myapp",
    );

    final token = Uri.parse(result).fragment
        .split("&")
        .firstWhere((e) => e.startsWith("access_token"))
        .split("=")[1];

    return token;
  }
}