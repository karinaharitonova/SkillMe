import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final apiKey = dotenv.env['API_KEY'];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Поисковая строка
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color.fromARGB(221, 212, 239, 252),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.black),
                  hintText: 'Поиск',
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Заголовок
            const Text(
              'ДЛЯ ВАС',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
