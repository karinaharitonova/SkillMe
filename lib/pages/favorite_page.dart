import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/pages/login_page.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Избранное'),
      ),

      body: Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [

      // Текст
      Text(
        user == null
            ? "Войдите в аккаунт, чтобы добавлять видео в избранное"
            : "Избранных видео пока нет. Добавьте что-нибудь!",
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16),
      ),

      const SizedBox(height: 24),

      // Кнопка показывается ТОЛЬКО если user == null
      if (user == null)
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4A90E2),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
          child: const Text(
            'Войти',
            style: TextStyle(fontSize: 18),
          ),
        ),
    ],
  ),
),
    );
  }
}
