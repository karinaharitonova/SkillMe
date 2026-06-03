import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminCategoriesPage extends StatefulWidget {
  final String? videoUrl; // URL загруженного видео

  const AdminCategoriesPage({super.key, this.videoUrl});

  @override
  State<AdminCategoriesPage> createState() => _AdminCategoriesPageState();
}

class _AdminCategoriesPageState extends State<AdminCategoriesPage> {
  final _titleController = TextEditingController();
  final _categoryIdController = TextEditingController();
  final _thumbnailUrlController = TextEditingController();
  final _durationController = TextEditingController();
  
  String? _selectedVideoUrl;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedVideoUrl = widget.videoUrl;
  }

  Future<void> _saveToFirestore() async {
    if (_titleController.text.isEmpty || _selectedVideoUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните название и выберите видео')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('videos').add({
        'title': _titleController.text.trim(),
        'categoryId': _categoryIdController.text.trim().isEmpty 
            ? 'default' 
            : _categoryIdController.text.trim(),
        'videoUrl': _selectedVideoUrl,
        'thumbnailUrl': _thumbnailUrlController.text.trim(),
        'duration': int.tryParse(_durationController.text.trim()) ?? 0,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Видео добавлено в категорию!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Очищаем поля
      _titleController.clear();
      _categoryIdController.clear();
      _thumbnailUrlController.clear();
      _durationController.clear();
      setState(() => _selectedVideoUrl = null);
      
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(' Ошибка: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Добавить в категорию'),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Шаг 2: Добавление видео в категорию',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            
            if (_selectedVideoUrl != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Видео загружено:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(_selectedVideoUrl!, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Название видео *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 12),
            
            TextField(
              controller: _categoryIdController,
              decoration: const InputDecoration(
                labelText: 'ID категории',
                hintText: 'например: tutorials',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
            ),
            const SizedBox(height: 12),
            
            TextField(
              controller: _thumbnailUrlController,
              decoration: const InputDecoration(
                labelText: 'Ссылка на обложку',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.image),
              ),
            ),
            const SizedBox(height: 12),
            
            TextField(
              controller: _durationController,
              decoration: const InputDecoration(
                labelText: 'Длительность (сек)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.timer),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            
            ElevatedButton(
              onPressed: isLoading ? null : _saveToFirestore,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                isLoading ? 'Сохранение...' : 'Добавить в категорию',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}