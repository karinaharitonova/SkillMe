import 'package:flutter/material.dart';
import 'package:myapp/services/video_repository.dart';
import 'package:myapp/pages/first_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initApp();
  }

  Future<void> initApp() async {
    final videos = await VideoRepository.loadVideos();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => FirstPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
          strokeWidth: 3,
        ),
      ),
    );
  }
}
