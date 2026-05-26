import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'video_player_page.dart';

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

  @override
  void initState() {
    super.initState();
    loadAllVideos();
  }

  Future<void> loadAllVideos() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('videos')
        .orderBy('createdAt', descending: true)
        .get();

    final loaded = snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    loaded.shuffle();

    setState(() {
      videos = loaded;
      filteredVideos = loaded;
      isLoading = false;
    });
  }

  void updateSearch(String query) {
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
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 Поиск
            Container(
              height: 43,
              decoration: BoxDecoration(
                color: const Color.fromARGB(221, 212, 239, 252),
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                onChanged: updateSearch,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.black),
                  hintText: 'Поиск',
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'ДЛЯ ВАС',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: filteredVideos.isEmpty
                  ? const Center(child: Text("Ничего не найдено"))
                  : ListView.builder(
                      itemCount: filteredVideos.length,
                      itemBuilder: (context, index) {
                        final video = filteredVideos[index];

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
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    video['title'] ?? 'Без названия',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    video['categoryId'] ?? 'Без категории',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
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
          ],
        ),
      ),
    );
  }
}
