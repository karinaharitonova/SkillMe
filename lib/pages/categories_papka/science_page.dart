import 'package:flutter/material.dart';

class SciencePage extends StatelessWidget {
  const SciencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Наука'),
      ),
      body: const Center(
        child: Text('Страница Наука'),
      ),
    );
  }
}

