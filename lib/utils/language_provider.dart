import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/utils/app_strings.dart';

class LanguageProvider extends ChangeNotifier {
  String _currentLanguage = 'ru';

  String get currentLanguage => _currentLanguage;

  // Геттер для MaterialApp (возвращает Locale)
  Locale get locale => Locale(_currentLanguage);

  LanguageProvider() {
    _loadLanguage();
  }

  // Загрузка языка из SharedPreferences
  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString('language') ?? 'ru';
    
    // Обновляем AppStrings
    AppStrings.setLanguage(_currentLanguage);
    
    notifyListeners();
  }

  // Установка нового языка
  Future<void> setLanguage(String language) async {
    if (language != 'ru' && language != 'en') return;

    _currentLanguage = language;
    
    // Обновляем AppStrings
    AppStrings.setLanguage(language);

    // Сохраняем в SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);

    // Уведомляем все виджеты об изменении
    notifyListeners();
  }
}