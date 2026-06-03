import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/utils/app_strings.dart';
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
  // Кэш избранного (чтобы не делать запросы к Firestore для каждого видео)
  final Set<String> _favoriteIds = {};
  bool _favoritesLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  // Загружаем избранное 
  Future<void> _loadFavorites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => _favoritesLoaded = true);
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('favorites')
          .doc(user.uid)
          .get();

      final list = List<String>.from(doc.data()?["videoIds"] ?? []);
      
      if (mounted) {
        setState(() {
          _favoriteIds.addAll(list);
          _favoritesLoaded = true;
        });
      }
    } catch (e) {
      print('Ошибка загрузки избранного: $e');
      if (mounted) setState(() => _favoritesLoaded = true);
    }
  }

  // Добавить / убрать из избранного
  Future<void> toggleFavorite(String videoId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.get('favorites_login_required'))),
      );
      return;
    }

    final uid = user.uid;
    final doc = FirebaseFirestore.instance.collection('favorites').doc(uid);

    setState(() {
      if (_favoriteIds.contains(videoId)) {
        _favoriteIds.remove(videoId);
      } else {
        _favoriteIds.add(videoId);
      }
    });

    try {
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
    } catch (e) {
      print('Ошибка сохранения: $e');
      // Откатываем изменение
      setState(() {
        if (_favoriteIds.contains(videoId)) {
          _favoriteIds.remove(videoId);
        } else {
          _favoriteIds.add(videoId);
        }
      });
    }
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

              final title = (video['title'] as String?) ?? AppStrings.get('video_no_title');
              final videoUrl = (video['videoUrl'] as String?) ?? "";
              final thumb = (video['thumbnailUrl'] as String?) ?? "";
              final duration = video['duration'] ?? 0;
              final videoId = doc.id;

              final isFav = _favoriteIds.contains(videoId);

              return Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Превью видео
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
                          child: thumb.isNotEmpty
                              ? Image.network(
                                  thumb,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      color: Colors.grey[300],
                                      child: const Center(
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: const Center(
                                        child: Icon(Icons.play_circle_fill,
                                            size: 70, color: Colors.black54),
                                      ),
                                    );
                                  },
                                )
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
                      AppStrings.get('video_duration').replaceAll('{seconds}', duration.toString()),
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Избранное
                    GestureDetector(
                      onTap: () => toggleFavorite(videoId),
                      child: Row(
                        children: [
                          Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            size: 26,
                            color: isFav ? Colors.red : Colors.black,
                          ),
                          const SizedBox(width: 6),
                          Text(isFav 
                              ? AppStrings.get('favorites_added') 
                              : AppStrings.get('favorites_add')),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Text(
        AppStrings.get('no_connection'),
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Text(
        AppStrings.get('video_empty'),
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}