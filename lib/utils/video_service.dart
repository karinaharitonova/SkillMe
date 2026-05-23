import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

class VideoService {
  final supabase = Supabase.instance.client;

  Future<String> uploadVideoFromUrl(String url, String fileName) async {
    // 1. Скачиваем видео
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Не удалось скачать видео');
    }

    final bytes = response.bodyBytes;
    final storagePath = 'videos/$fileName';

    // 2. Загружаем в Supabase
    await supabase.storage.from('videos').uploadBinary(
      storagePath,
      bytes,
      fileOptions: const FileOptions(
        contentType: 'video/mp4',
        upsert: true,
      ),
    );

    // 3. Получаем публичный URL
    return supabase.storage.from('videos').getPublicUrl(storagePath);
  }
}
