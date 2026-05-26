import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('ru');

  Locale get locale => _locale;

  LanguageProvider() {
    _loadLanguage();
  }

  void setLanguage(String code) {
    _locale = Locale(code);
    _saveLanguage(code);
    notifyListeners();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('language') ?? 'ru';
    _locale = Locale(code);
    notifyListeners();
  }

  Future<void> _saveLanguage(String code) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('language', code);
  }
}
