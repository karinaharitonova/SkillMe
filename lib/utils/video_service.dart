import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VideoService {
  final supabase = Supabase.instance.client;

  /// Только загрузка в Storage
  Future<String> uploadVideoToStorage(String url, String fileName) async {
    final response = await supabase.functions.invoke(
      'import-video',
      body: {
        'stockUrl': url,
        'fileName': fileName,
      },
    );

    if (response.data == null) {
      throw Exception('Сервер вернул пустой ответ');
    }

    if (response.data['success'] != true) {
      final error = response.data['error'] ?? 'Неизвестная ошибка';
      throw Exception('Ошибка: $error');
    }

    return response.data['url'];
  }

  Future<void> addVideoToFirestore({
    required String title,
    required String categoryId,
    required String videoUrl,
    required String thumbnailUrl,
    required int duration,
  }) async {
    await FirebaseFirestore.instance.collection('videos').add({
      'title': title,
      'categoryId': categoryId,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'duration': duration,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}