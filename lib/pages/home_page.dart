import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'video_player_page.dart';

List<Map<String, dynamic>> globalVideosCache = [];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> videos = [];
  List<Map<String, dynamic>> filteredVideos = [];

  bool isLoading = true;
  String searchQuery = "";

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    loadAllVideos();
  }

  Future<void> loadAllVideos() async {
    if (globalVideosCache.isNotEmpty) {
      setState(() {
        videos = List<Map<String, dynamic>>.from(globalVideosCache);
        filteredVideos = List<Map<String, dynamic>>.from(globalVideosCache);
        isLoading = false;
      });
      return;
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('videos')
          .orderBy('createdAt', descending: true)
          .get();

      final loaded = snapshot.docs
          .map((doc) => doc.data())
          .toList()
          .cast<Map<String, dynamic>>();

      loaded.shuffle();

      globalVideosCache = List<Map<String, dynamic>>.from(loaded);

      setState(() {
        videos = List<Map<String, dynamic>>.from(loaded);
        filteredVideos = List<Map<String, dynamic>>.from(loaded);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        videos = [];
        filteredVideos = [];
      });
    }
  }

  Future<void> _refreshVideos() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('videos')
          .orderBy('createdAt', descending: true)
          .get();

      final loaded = snapshot.docs
          .map((doc) => doc.data())
          .toList()
          .cast<Map<String, dynamic>>();

      loaded.shuffle();

      // Обновляем глобальный кеш и локальные списки
      globalVideosCache = List<Map<String, dynamic>>.from(loaded);

      setState(() {
        videos = List<Map<String, dynamic>>.from(loaded);
        // Если есть активный поиск — применяем фильтр к новым данным
        if (searchQuery.isNotEmpty) {
          filteredVideos = videos.where((video) {
            final title = (video['title'] ?? "").toString().toLowerCase();
            final category = (video['category'] ?? "").toString().toLowerCase();
            final categoryId = (video['categoryId'] ?? "").toString().toLowerCase();
            return title.contains(searchQuery) ||
                category.contains(searchQuery) ||
                categoryId.contains(searchQuery);
          }).toList();
        } else {
          filteredVideos = List<Map<String, dynamic>>.from(videos);
        }
      });
    } catch (e) {
      // Ошибка при обновлении
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ошибка при обновлении')),
        );
      }
    }
  }

  void updateSearch(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 150), () {
      setState(() {
        searchQuery = query.toLowerCase();

        filteredVideos = videos.where((video) {
          final title = (video['title'] ?? "").toString().toLowerCase();
          final category = (video['category'] ?? "").toString().toLowerCase();
          final categoryId = (video['categoryId'] ?? "").toString().toLowerCase();

          return title.contains(searchQuery) ||
              category.contains(searchQuery) ||
              categoryId.contains(searchQuery);
        }).toList();
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: cs.primary),
        ),
      );
    }

    const outerHorizontalPadding = 30.0;
    const cardInnerPadding = 12.0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: outerHorizontalPadding, vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Поиск с градиентом
            Container(
              height: 43,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFCBDDFD),
                    Color(0xFF5D65D6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                onChanged: updateSearch,
                cursorColor: const Color.fromARGB(255, 0, 0, 0),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Color.fromARGB(255, 0, 0, 0)),
                  hintText: 'Поиск',
                  border: InputBorder.none,
                  hintStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  filled: false,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                style: TextStyle(color: cs.onSurface),
              ),
            ),

            const SizedBox(height: 30),

            Text(
              'ДЛЯ ВАС',
              style: textTheme.headlineSmall?.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
            ),

            const SizedBox(height: 12),

            // RefreshIndicator оборачивает прокручиваемый виджет
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshVideos,
                // ListView внутри обеспечивает прокрутку и работу жеста
                child: filteredVideos.isEmpty
                    ? ListView(
                        // AlwaysScrollableScrollPhysics гарантирует, что жест pull-to-refresh сработает даже при пустом списке
                        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                          Center(
                            child: Text(
                              "Ничего не найдено",
                              style: TextStyle(color: cs.onSurface.withAlpha((0.7 * 255).round())),
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: filteredVideos.length,
                        itemBuilder: (context, index) {
                          final video = filteredVideos[index];

                          final screenW = MediaQuery.of(context).size.width;
                          final availableWidth = screenW - outerHorizontalPadding * 2 - cardInnerPadding * 2;
                          final thumbHeight = availableWidth * 9 / 16;

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => VideoPlayerPage(
                                    videoUrl: video['videoUrl'],
                                    title: video['title'],
                                    category: video['category'],
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Container(
                                padding: const EdgeInsets.all(cardInnerPadding),
                                decoration: BoxDecoration(
                                  color: cs.surface,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color.fromRGBO(0, 0, 0, 0.05),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        width: double.infinity,
                                        height: thumbHeight,
                                        color: cs.surfaceContainerHighest,
                                        child: (video['thumbnailUrl'] ?? "").toString().isNotEmpty
                                            ? Image.network(
                                                video['thumbnailUrl'],
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: double.infinity,
                                                errorBuilder: (_, __, ___) => Center(
                                                  child: Icon(
                                                    Icons.play_circle_fill,
                                                    size: 56,
                                                    color: cs.onSurface.withAlpha((0.7 * 255).round()),
                                                  ),
                                                ),
                                              )
                                            : Center(
                                                child: Icon(
                                                  Icons.play_circle_fill,
                                                  size: 56,
                                                  color: cs.onSurface.withAlpha((0.7 * 255).round()),
                                                ),
                                              ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      video['title'] ?? 'Без названия',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: cs.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      video['categoryId'] ?? 'Без категории',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: cs.onSurface.withAlpha((0.7 * 255).round()),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
