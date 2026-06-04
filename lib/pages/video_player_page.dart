import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:myapp/utils/app_strings.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoUrl;
  final String title;
  final String? category;

  const VideoPlayerPage({
    super.key,
    required this.videoUrl,
    required this.title,
    this.category,
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;
  bool _isReady = false;
  bool _showUI = true;
  bool _isPlaying = true;
  bool _isBuffering = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      setState(() => _errorMessage = null);

      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );

      await _controller.initialize();
      await _controller.setVolume(1.0);

      _controller.addListener(() {
        if (mounted) {
          setState(() {
            _isPlaying = _controller.value.isPlaying;
            _isBuffering = _controller.value.isBuffering;
          });
        }
      });

      _controller.setLooping(true);
      await _controller.play();

      if (mounted) setState(() => _isReady = true);
    } catch (e) {
      print('Ошибка: $e');
      if (mounted) {
        setState(() => _errorMessage = e.toString());
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleUI() {
    setState(() => _showUI = !_showUI);
  }

  void togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  String _formatTime(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final minutes = two(d.inMinutes.remainder(60));
    final seconds = two(d.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }


  String _localizedCategory(String? category) {
    if (category == null || category.isEmpty) return '';
    
    const categoryKeys = {
      'Музыка': 'category_music',
      'Music': 'category_music',
      'Образование': 'category_education',
      'Education': 'category_education',
      'Игры': 'category_games',
      'Games': 'category_games',
      'Кулинария': 'category_cooking',
      'Cooking': 'category_cooking',
      'Дизайн': 'category_design',
      'Design': 'category_design',
      'Спорт': 'category_sport',
      'Sport': 'category_sport',
      'Наука': 'category_science',
      'Science': 'category_science',
      'Бизнес': 'category_business',
      'Business': 'category_business',
    };

    final key = categoryKeys[category];
    if (key != null) {
      return AppStrings.get(key);
    }
    return category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Видео или ошибка
          GestureDetector(
            onTap: toggleUI,
            child: Center(
              child: _errorMessage != null
                  ? Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error, color: Colors.red, size: 60),
                          const SizedBox(height: 20),
                          Text(
                            AppStrings.get('video_error'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: _initPlayer,
                            icon: const Icon(Icons.refresh),
                            label: Text(AppStrings.get('retry')),
                          ),
                        ],
                      ),
                    )
                  : _isReady
                      ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(color: Colors.white),
                            const SizedBox(height: 20),
                            Text(
                              AppStrings.get('video_loading'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
            ),
          ),

          // Индикатор буферизации
          if (_isBuffering && _isReady)
            Container(
              color: Colors.black26,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(color: Colors.white),
                    const SizedBox(height: 10),
                    Text(
                      AppStrings.get('video_buffering'),
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

          // Верхний градиент
          if (_showUI && _isReady)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 120,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black87, Colors.transparent],
                  ),
                ),
              ),
            ),

          // Нижний градиент
          if (_showUI && _isReady)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 220,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black87, Colors.transparent],
                  ),
                ),
              ),
            ),

          // Кнопка назад
          if (_showUI)
            Positioned(
              top: 40,
              left: 16,
              child: Tooltip(
                message: AppStrings.get('back'),
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    tooltip: AppStrings.get('back'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ),

          // Название и категория 
          if (_showUI && _isReady)
            Positioned(
              left: 20,
              right: 20,
              bottom: 130,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.title.isEmpty
                        ? AppStrings.get('video_no_title')
                        : widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (widget.category != null && widget.category!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      _localizedCategory(widget.category),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

          // Ползунок с временем (СНИЗУ)
          if (_showUI && _isReady)
            Positioned(
              left: 20,
              right: 20,
              bottom: 70,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  VideoProgressIndicator(
                    _controller,
                    allowScrubbing: true,
                    colors: const VideoProgressColors(
                      playedColor: Colors.white,
                      bufferedColor: Colors.white30,
                      backgroundColor: Colors.white10,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatTime(_controller.value.position),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        _formatTime(_controller.value.duration),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          // Кнопка Play/Pause (по центру)
          if (_showUI && _isReady)
            Center(
              child: Tooltip(
                message: _isPlaying ? 'Pause' : 'Play',
                child: IconButton(
                  iconSize: 70,
                  icon: Icon(
                    _isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    color: Colors.white70,
                  ),
                  onPressed: togglePlayPause,
                ),
              ),
            ),
        ],
      ),
    );
  }
}