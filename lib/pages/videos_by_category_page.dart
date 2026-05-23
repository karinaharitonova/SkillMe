import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'video_player_page.dart';

class VideosByCategoryPage extends StatelessWidget {
  final String categoryId;
  final String categoryTitle;

  const VideosByCategoryPage({
    super.key,
    required this.categoryId,
    required this.categoryTitle,
  });

  // Проверка доступности URL (чтобы не было пустых превью)
  Future<bool> _checkUrl(String url) async {
    try {
      final r = await http.head(Uri.parse(url))
          .timeout(const Duration(seconds: 3));
      return r.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(categoryTitle)),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('videos')
            .where('categoryId', isEqualTo: categoryId)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // Ошибка Firestore (например, нет интернета)
          if (snapshot.hasError) {
            return _buildError();
          }

          // Загрузка
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final videos = snapshot.data!.docs;

          // Нет видео
          if (videos.isEmpty) {
            return _buildEmpty();
          }

          // Список видео
          return ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index].data() as Map<String, dynamic>;

              final title = video['title'] ?? "Без названия";
              final videoUrl = video['videoUrl'] ?? "";
              final thumb = video['thumbnailUrl'] ?? "";
              final duration = video['duration'] ?? 0;

              return FutureBuilder<bool>(
                future: _checkUrl(thumb),
                builder: (context, snap) {
                  final thumbOk = snap.data == true;

                  return ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: thumbOk
                          ? Image.network(
                              thumb,
                              width: 100,
                              height: 60,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 100,
                              height: 60,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image_not_supported),
                            ),
                    ),
                    title: Text(title),
                    subtitle: Text("Длительность: $duration сек"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VideoPlayerPage(
                            videoUrl: videoUrl,
                            title: title,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  // Экран ошибки (нет интернета / Firestore недоступен)
  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, size: 60, color: Colors.grey),
          const SizedBox(height: 10),
          const Text(
            "Нет соединения",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          const Text(
            "Проверьте интернет и попробуйте снова",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Экран, если нет видео
  Widget _buildEmpty() {
    return const Center(
      child: Text(
        "Видео пока нет",
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
