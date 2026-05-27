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
    // Отложенный запуск, чтобы layout успел выполниться и MediaQuery был доступен
    WidgetsBinding.instance.addPostFrameCallback((_) => initApp());
  }

  Future<void> initApp() async {
    try {
      // Ждём загрузки, но не дольше 10 секунд
      await VideoRepository.loadVideos().timeout(const Duration(seconds: 10));
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const FirstPage()),
      );
    } catch (e, st) {
      debugPrint('Splash init error: $e\n$st');
      if (!mounted) return;
      // В случае ошибки всё равно переходим дальше, можно показать экран ошибки вместо этого
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const FirstPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: Colors.blue, strokeWidth: 3),
      ),
    );
  }
}
