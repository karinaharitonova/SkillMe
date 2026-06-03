import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/model/profile.dart';
import 'package:myapp/utils/user_preferences.dart';
import 'package:myapp/widget/profile_widget.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final firebaseUser = FirebaseAuth.instance.currentUser;

  late Profile user;

  @override
  void initState() {
    super.initState();
    user = UserPreferences.myUser;
  }

  Future<void> signOut() async {
    if (!mounted) return;
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/first', (route) => false);
  }

  // Открываем настройки и ждём возврата.
  // После возврата подтягиваем профиль из UserPreferences и обновляем UI.
  Future<void> _openSettingsAndRefresh() async {
    await Navigator.pushNamed(context, '/settings');

    // Всегда подтягиваем актуальные данные из UserPreferences (на случай, если
    // EditProfilePage сохранил профиль внутри Settings)
    final latest = UserPreferences.myUser;

    // Если что-то изменилось — очистим кэш изображений и обновим state
    if (latest.imagePath != user.imagePath ||
        latest.name != user.name ||
        latest.nickname != user.nickname) {
      try {
        if ((latest.imagePath).isNotEmpty) {
          final provider = FileImage(File(latest.imagePath));
          await provider.evict();
        }
        imageCache.clear();
        imageCache.clearLiveImages();
      } catch (_) {}

      if (!mounted) return;
      setState(() {
        user = latest;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'АККАУНТ',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: signOut,
          ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          Container(
  margin: const EdgeInsets.symmetric(horizontal: 20),
  padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
  decoration: BoxDecoration(
    gradient: const LinearGradient(
      colors: [
        Color(0xFFCBDDFD),
        Color(0xFF5D65D6),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.12),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  ),
  child: Column(
    children: [
      // АВАТАР
      ProfileWidget(
        imagePath: user.imagePath,
        onClicked: null, 
      ),

      const SizedBox(height: 15),

      // ИМЯ
      Text(
        user.name,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),

      const SizedBox(height: 6),

      // НИК
      Text(
        user.nickname,
        style: TextStyle(
          fontSize: 20,
          color: Colors.white.withOpacity(0.9),
        ),
      ),

      const SizedBox(height: 10),

      // ПОЧТА
      Text(
        firebaseUser?.email ?? "Неизвестно",
        style: TextStyle(
          fontSize: 18,
          color: Colors.white.withOpacity(0.8),
        ),
      ),
    ],
  ),
),


          const SizedBox(height: 20),


          Center(
  child: SizedBox(
    width: 200,
    height: 50,
    child: InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: _openSettingsAndRefresh, 
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            width: 3,
            color: const Color(0xFF5D65D6),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'Настройки',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF5D65D6),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    ),
  ),
)

        ],
      ),
    );
  }

}
