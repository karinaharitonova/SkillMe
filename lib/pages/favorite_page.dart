import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/pages/registration/login_page.dart';
import 'video_player_page.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  Stream<DocumentSnapshot<Map<String, dynamic>>> _favoritesStream(String uid) {
    return FirebaseFirestore.instance
        .collection('favorites')
        .doc(uid)
        .snapshots();
  }

  Future<List<Map<String, dynamic>>> _fetchVideosByIds(List ids) async {
    if (ids.isEmpty) return [];

    final chunks = <List>[];
    for (var i = 0; i < ids.length; i += 10) {
      chunks.add(ids.sublist(i, i + 10 > ids.length ? ids.length : i + 10));
    }

    final results = <Map<String, dynamic>>[];
    for (final chunk in chunks) {
      final q = await FirebaseFirestore.instance
          .collection('videos')
          .where(FieldPath.documentId, whereIn: chunk)
          .get();

      results.addAll(q.docs.map((d) {
        final data = d.data() as Map<String, dynamic>;
        return {
          ...data,
          'id': d.id, 
        };
      }).toList());
    }

    return results;
  }

  Future<void> _removeFromFavorites(String uid, String videoId) async {
    final docRef = FirebaseFirestore.instance.collection('favorites').doc(uid);
    await FirebaseFirestore.instance.runTransaction((tx) async {
      final snap = await tx.get(docRef);
      if (!snap.exists) return;
      final data = snap.data()!;
      final List ids = List.from(data['videoIds'] ?? []);
      ids.remove(videoId);
      tx.update(docRef, {'videoIds': ids});
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('ИЗБРАННОЕ', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
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
                            backgroundColor: const Color(0xFF064A8F),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                          },
                          child: const Text('Войти', style: TextStyle(fontSize: 18, color: Colors.white)),
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

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _favoritesStream(user.uid),
      builder: (context, favSnap) {
        if (favSnap.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final favDoc = favSnap.data;
        final videoIds = favDoc?.data()?['videoIds'] ?? [];

        return FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchVideosByIds(videoIds),
          builder: (context, videosSnap) {
            if (videosSnap.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            final videos = videosSnap.data ?? [];

            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('ИЗБРАННОЕ', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    //const SizedBox(height: 30),
                    videos.isEmpty
                        ? const Expanded(child: Center(child: Text("Избранных видео пока нет", style: TextStyle(fontSize: 16))))
                        : Expanded(
                            child: ListView.builder(
                              itemCount: videos.length,
                              itemBuilder: (context, index) {
                                final video = videos[index];
                                final videoId = (video['id'] ?? video['videoId'] ?? '').toString();

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => VideoPlayerPage(
                                      videoUrl: video['videoUrl'],
                                      title: video['title'],
                                    )));
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
                                                ? Image.network(video['thumbnailUrl'], fit: BoxFit.cover)
                                                : Container(
                                                    color: Colors.grey[300],
                                                    child: const Center(
                                                      child: Icon(Icons.play_circle_fill, size: 70, color: Colors.black54),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        //const SizedBox(height: 10),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(video['title'] ?? "Без названия", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                                                  const SizedBox(height: 5),
                                                  Text(video['category'] ?? "", style: const TextStyle(fontSize: 15, color: Colors.grey)),
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.favorite, color: Colors.red),
                                              onPressed: () async {
                                                try {
                                                  await _removeFromFavorites(user.uid, videoId);
                                                  if (context.mounted) {
                                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Удалено из избранного')));
                                                  }
                                                } catch (e) {
                                                  if (context.mounted) {
                                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ошибка при удалении')));
                                                  }
                                                }
                                              },
                                            ),
                                          ],
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
      },
    );
  }
}
