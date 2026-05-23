import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class VideoService {
  final supabase = Supabase.instance.client;
  final firestore = FirebaseFirestore.instance;

  /// Скачивает видео по URL и загружает в Supabase
  Future<String> uploadVideoFromUrl(String url, String fileName) async {
    // 1. Корректное потоковое скачивание
    final request = http.Request('GET', Uri.parse(url));
    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Ошибка скачивания: ${response.statusCode}');
    }

    final bytes = await response.stream.toBytes();
    print('Размер файла: ${bytes.length}');

    // 2. Загружаем в подпапку uploads/
    final storagePath = 'uploads/$fileName';

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

  /// Создаёт документ в Firestore
  Future<void> saveVideoToFirestore({
    required String title,
    required String categoryId,
    required String videoUrl,
    required String thumbnailUrl,
    required int duration,
  }) async {
    await firestore.collection('videos').add({
      'title': title,
      'categoryId': categoryId,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'duration': duration,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Полный процесс: загрузка + Firestore
  Future<void> addVideo({
    required String sourceUrl,
    required String fileName,
    required String title,
    required String categoryId,
    required String thumbnailUrl,
    required int duration,
  }) async {
    final publicUrl = await uploadVideoFromUrl(sourceUrl, fileName);

    await saveVideoToFirestore(
      title: title,
      categoryId: categoryId,
      videoUrl: publicUrl,
      thumbnailUrl: thumbnailUrl,
      duration: duration,
    );
  }
}
