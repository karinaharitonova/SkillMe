import 'package:flutter/material.dart';
import 'package:myapp/pages/categories_page.dart';

class DesignPage extends StatelessWidget {
  const DesignPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Дизайн'),
      ),
      body: const Center(
        child: Text('Страница Дизайн'),
      ),
    );
  }
}

