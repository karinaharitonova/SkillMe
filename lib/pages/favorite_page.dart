import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/pages/registration/login_page.dart';
import 'video_player_page.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  Future<List<Map<String, dynamic>>> _loadFavoriteVideos() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final favDoc = await FirebaseFirestore.instance
        .collection('favorites')
        .doc(user.uid)
        .get();

    if (!favDoc.exists) return [];

    List videoIds = favDoc.data()?['videoIds'] ?? [];

    if (videoIds.isEmpty) return [];

    final videosQuery = await FirebaseFirestore.instance
        .collection('videos')
        .where(FieldPath.documentId, whereIn: videoIds)
        .get();

    return videosQuery.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // ⭐ Если пользователь не вошёл — обычная страница
    if (user == null) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ИЗБРАННОЕ',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Войдите в аккаунт, чтобы добавлять видео в избранное",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF064A8F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                            );
                          },
                          child: const Text(
                            'Войти',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ⭐ Если пользователь вошёл — FutureBuilder
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _loadFavoriteVideos(),
      builder: (context, snapshot) {
        // ⭐ Полноэкранная загрузка — НЕТ белого прямоугольника
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final videos = snapshot.data ?? [];

        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ИЗБРАННОЕ',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                videos.isEmpty
                    ? const Expanded(
                        child: Center(
                          child: Text(
                            "Избранных видео пока нет",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: videos.length,
                          itemBuilder: (context, index) {
                            final video = videos[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => VideoPlayerPage(
                                      videoUrl: video['videoUrl'],
                                      title: video['title'],
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 25),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: video['thumbnailUrl'] != null
                                            ? Image.network(
                                                video['thumbnailUrl'],
                                                fit: BoxFit.cover,
                                              )
                                            : Container(
                                                color: Colors.grey[300],
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.play_circle_fill,
                                                    size: 70,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      video['title'] ?? "Без названия",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      video['category'] ?? "",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
