import 'package:cloud_firestore/cloud_firestore.dart';
import 'local_cache.dart';
import 'internet_checker.dart';

class VideoRepository {
  static Future<List<Map<String, dynamic>>> loadVideos() async {
    final online = await InternetChecker.hasInternet();

    if (online) {
      try {
        final snap = await FirebaseFirestore.instance
            .collection('videos')
            .get();

        final videos = snap.docs.map((d) => d.data()).toList();

        await LocalCache.saveVideos(videos);

        return videos;
      } catch (_) {
        return await LocalCache.loadVideos();
      }
    } else {
      return await LocalCache.loadVideos();
    }
  }
}
