import 'package:http/http.dart' as http;

class ApiHealth {
  static Future<bool> checkSupabase() async {
    try {
      final r = await http.get(Uri.parse(
        'https://pvsgicpokquefcinmume.supabase.co'
      )).timeout(const Duration(seconds: 3));
      return r.statusCode == 200 || r.statusCode == 404;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> checkFirestore() async {
    try {
      final r = await http.get(Uri.parse(
        'https://firestore.googleapis.com'
      )).timeout(const Duration(seconds: 3));
      return r.statusCode == 200 || r.statusCode == 404;
    } catch (_) {
      return false;
    }
  }
}
