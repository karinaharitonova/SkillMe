import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'video_player_page.dart';

class VideosByCategoryPage extends StatefulWidget {
  final String categoryId;
  final String categoryTitle;

  const VideosByCategoryPage({
    super.key,
    required this.categoryId,
    required this.categoryTitle,
  });

  @override
  State<VideosByCategoryPage> createState() => _VideosByCategoryPageState();
}

class _VideosByCategoryPageState extends State<VideosByCategoryPage> {
  // Проверка доступности URL
  Future<bool> _checkUrl(String url) async {
    if (url.isEmpty) return false;
    try {
      final r = await http.head(Uri.parse(url)).timeout(const Duration(seconds: 3));
      return r.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // Добавить / убрать из избранного
  Future<void> toggleFavorite(String videoId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final uid = user.uid;
    final doc = FirebaseFirestore.instance.collection('favorites').doc(uid);

    final snapshot = await doc.get();
    List list = List.from(snapshot.data()?["videoIds"] ?? []);

    if (list.contains(videoId)) {
      list.remove(videoId);
    } else {
      list.add(videoId);
    }

    if (!snapshot.exists) {
      await doc.set({"videoIds": list});
    } else {
      await doc.update({"videoIds": list});
    }

    setState(() {}); 
  }

  Future<bool> isFavorite(String videoId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final doc = await FirebaseFirestore.instance
        .collection('favorites')
        .doc(user.uid)
        .get();

    List list = List.from(doc.data()?["videoIds"] ?? []);
    return list.contains(videoId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryTitle)),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('videos')
            .where('categoryId', isEqualTo: widget.categoryId)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return _buildError();
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return _buildEmpty();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final video = doc.data() as Map<String, dynamic>? ?? {};

              final title = (video['title'] as String?) ?? "Без названия";
              final videoUrl = (video['videoUrl'] as String?) ?? "";
              final thumb = (video['thumbnailUrl'] as String?) ?? "";
              final duration = video['duration'] ?? 0;
              final videoId = doc.id;

              final Future<bool> thumbFuture =
                  thumb.isNotEmpty ? _checkUrl(thumb) : Future.value(false);

              return FutureBuilder<bool>(
                future: thumbFuture,
                builder: (context, thumbSnap) {
                  final thumbOk = thumbSnap.data == true;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: thumbOk
                                  ? Image.network(thumb, fit: BoxFit.cover)
                                  : Container(
                                      color: Colors.grey[300],
                                      child: const Center(
                                        child: Icon(Icons.play_circle_fill,
                                            size: 70, color: Colors.black54),
                                      ),
                                    ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          "Длительность: $duration сек",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(height: 12),

                        FutureBuilder<bool>(
                          future: isFavorite(videoId),
                          builder: (context, favSnap) {
                            final isFav = favSnap.data == true;

                            return GestureDetector(
                              onTap: () async {
                                await toggleFavorite(videoId);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    isFav ? Icons.favorite : Icons.favorite_border,
                                    size: 26,
                                    color: isFav ? Colors.red : Colors.black,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(isFav ? "В избранном" : "В избранное"),
                                ],
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildError() {
    return const Center(child: Text("Нет соединения", style: TextStyle(fontSize: 18)));
  }

  Widget _buildEmpty() {
    return const Center(child: Text("Видео пока нет", style: TextStyle(fontSize: 18)));
  }
}
