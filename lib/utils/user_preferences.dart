import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/profile.dart';

class UserPreferences {
  static Future<void> setNotificationsEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
  }

  static Future<bool> getNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('notifications_enabled') ?? false;
  }
  static const _keyUser = "user_profile";

  // Текущий пользователь (загружается при старте)
  static late Profile myUser;

  // Загрузка пользователя
  static Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyUser);

    if (jsonString == null) {
      // Если данных нет — создаём пустой профиль
      myUser = const Profile(
        imagePath: "",
        name: "",
        email: "",
        about: "",
        isDarkMode: false,
        nickname: "",
      );
      return;
    }

    final jsonMap = jsonDecode(jsonString);

    myUser = Profile(
      imagePath: jsonMap["imagePath"] ?? "",
      name: jsonMap["name"] ?? "",
      email: jsonMap["email"] ?? "",
      about: jsonMap["about"] ?? "",
      isDarkMode: jsonMap["isDarkMode"] ?? false,
      nickname: jsonMap["nickname"] ?? "",
    );
  }

  // Сохранение пользователя
  static Future<void> setUser(Profile user) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonMap = {
      "imagePath": user.imagePath,
      "name": user.name,
      "email": user.email,
      "about": user.about,
      "isDarkMode": user.isDarkMode,
      "nickname": user.nickname,
    };

    await prefs.setString(_keyUser, jsonEncode(jsonMap));
    myUser = user;
  }
}
