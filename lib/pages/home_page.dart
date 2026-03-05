import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final apiKey = dotenv.env['API_KEY'];


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Главная страница'),
      ),
    );
  }
}