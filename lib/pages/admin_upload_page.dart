import 'package:flutter/material.dart';
import 'package:myapp/utils/video_service.dart';

class AdminUploadPage extends StatefulWidget {
  const AdminUploadPage({super.key});

  @override
  State<AdminUploadPage> createState() => _AdminUploadPageState();
}

class _AdminUploadPageState extends State<AdminUploadPage> {
  final videoService = VideoService();
  final _urlController = TextEditingController();
  final _fileNameController = TextEditingController();
  
  bool isLoading = false;
  String? _uploadedUrl; // URL загруженного видео

  Future<void> _uploadVideo() async {
    final url = _urlController.text.trim();
    final fileName = _fileNameController.text.trim();

    if (url.isEmpty || fileName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните URL и имя файла')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final publicUrl = await videoService.uploadVideoToStorage(url, fileName);

      if (!mounted) return;
      
      setState(() => _uploadedUrl = publicUrl);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Видео загружено! URL: $publicUrl'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 5),
        ),
      );
      
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    _fileNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Загрузка видео'),
        backgroundColor: Colors.blue[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Шаг 1: Загрузка видео в хранилище',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Видео будет загружено в Supabase Storage. Потом вы сможете добавить его в категорию.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'Ссылка на видео *',
                hintText: 'https://example.com/video.mp4',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.link),
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 12),
            
            TextField(
              controller: _fileNameController,
              decoration: const InputDecoration(
                labelText: 'Имя файла *',
                hintText: 'my_video.mp4',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.insert_drive_file),
              ),
            ),
            const SizedBox(height: 24),
            
            ElevatedButton.icon(
              onPressed: isLoading ? null : _uploadVideo,
              icon: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.cloud_upload, size: 24),
              label: Text(
                isLoading ? 'Загрузка...' : 'Загрузить в хранилище',
                style: const TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),

            if (_uploadedUrl != null) ...[
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'Видео загружено!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              const SizedBox(height: 12),
              Text(
                'URL: $_uploadedUrl',
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }
}