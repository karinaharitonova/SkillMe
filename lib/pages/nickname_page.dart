import 'package:flutter/material.dart';

class NicknamePage extends StatelessWidget {
  const NicknamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, 
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/account');
            },
            child: const Text(
              "Пропустить",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            // Верхняя голубая часть
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 40, bottom: 40),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF7EC8FF),
                    Color(0xFF4A90E2),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),

              child: Column(
                children: [

                  // Кнопка добавления фото
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        height: 90,
                        width: 90,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.blue,
                          size: 40,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Поле "Введите имя"
                  _inputField("Введите имя"),

                  const SizedBox(height: 15),

                  // Поле "Введите никнейм"
                  _inputField("Введите никнейм"),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Кнопка "Продолжить"
            SizedBox(
              width: 250,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/account');
                },
                child: const Text(
                  "Продолжить",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _inputField(String hint) {
    return Container(
      width: 300,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        ),
      ),
    );
  }
}
