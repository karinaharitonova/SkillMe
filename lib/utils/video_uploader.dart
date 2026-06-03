import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VideoService {
  final supabase = Supabase.instance.client;
  final firestore = FirebaseFirestore.instance;

  /// Загружаем видео через Edge Function (сервер сам скачивает и кладет в Storage)
  Future<String> uploadVideoFromUrl(String url, String fileName) async {
    print('🚀 Отправляем запрос на Edge Function...');
    
    // Вызываем Edge Function 'import-video'
    final response = await supabase.functions.invoke(
      'import-video',
      body: {
        'stockUrl': url,
        'fileName': fileName,
      },
    );

    // Проверяем ответ
    if (response.data == null) {
      throw Exception('Сервер вернул пустой ответ');
    }

    if (response.data['success'] != true) {
      final error = response.data['error'] ?? 'Неизвестная ошибка';
      throw Exception('Ошибка Edge Function: $error');
    }

    final publicUrl = response.data['url'];
    print('✅ Видео загружено! URL: $publicUrl');
    
    return publicUrl;
  }

  /// Сохраняем документ в Firestore (этот метод не меняется)
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
    print('✅ Документ сохранен в Firestore');
  }

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
    
    print('🎉 Видео добавлено успешно!');
  }
}