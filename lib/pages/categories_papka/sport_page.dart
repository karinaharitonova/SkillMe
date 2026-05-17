import 'package:flutter/material.dart';
import 'package:myapp/pages/categories_page.dart';

class SportPage extends StatelessWidget {
  const SportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Спорт'),
      ),
      body: const Center(
      ),
    );
  }
}

