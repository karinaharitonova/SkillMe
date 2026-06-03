import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/utils/app_strings.dart';
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
              Text(
                AppStrings.get('favorites_title').toUpperCase(),
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Center(
                  child: Text(
                    AppStrings.get('favorites_login_required'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
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
            final isDark = Theme.of(context).brightness == Brightness.dark;

            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.get('favorites_title').toUpperCase(),
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 20),

                    videos.isEmpty
                        ? Expanded(
                            child: Center(
                              child: Text(
                                AppStrings.get('favorites_empty'),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: videos.length,
                              itemBuilder: (context, index) {
                                final video = videos[index];
                                final videoId =
                                    (video['id'] ?? video['videoId'] ?? '').toString();

                                final cardColor = isDark
                                    ? const Color(0xFF1E1E1E)
                                    : Colors.white;

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
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 25),
                                    decoration: BoxDecoration(
                                      color: cardColor,
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(
                                              isDark ? 0.4 : 0.15),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.all(14),
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
                                                    color: isDark
                                                        ? Colors.white.withOpacity(0.1)
                                                        : Colors.grey[300],
                                                    child: Icon(
                                                      Icons.play_circle_fill,
                                                      size: 70,
                                                      color: isDark
                                                          ? Colors.white70
                                                          : Colors.black54,
                                                    ),
                                                  ),
                                          ),
                                        ),

                                        const SizedBox(height: 12),

                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    video['title'] ?? AppStrings.get('video_no_title'),
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.w700,
                                                      color: isDark
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    video['category'] ?? "",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: isDark
                                                          ? Colors.white.withOpacity(0.7)
                                                          : Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            IconButton(
                                              icon: const Icon(Icons.favorite,
                                                  color: Colors.red),
                                              tooltip: AppStrings.get('favorites_added'),
                                              onPressed: () async {
                                                await _removeFromFavorites(
                                                    user.uid, videoId);
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