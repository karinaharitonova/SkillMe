import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalCache {
  static const _key = 'cached_videos';

  static Future<void> saveVideos(List<Map<String, dynamic>> videos) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, jsonEncode(videos));
  }

  static Future<List<Map<String, dynamic>>> loadVideos() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(data));
  }
}
