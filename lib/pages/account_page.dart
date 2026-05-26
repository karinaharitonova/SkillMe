import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/model/profile.dart';
import 'package:myapp/utils/user_preferences.dart';
import 'package:myapp/widget/profile_widget.dart';
import 'package:myapp/widget/numbers_widget.dart';
import 'package:myapp/widget/buttom_widget.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final firebaseUser = FirebaseAuth.instance.currentUser;
  Profile user = UserPreferences.myUser;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    setState(() {
      user = user.copyWith(imagePath: picked.path);
    });
  }

  Future<void> signOut() async {
    if (!mounted) return;
    final navigator = Navigator.of(context);

    await FirebaseAuth.instance.signOut();
    navigator.pushNamedAndRemoveUntil('/first', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
          ProfileWidget(
            imagePath: user.imagePath,
            onClicked: pickImage,
          ),

          const SizedBox(height: 20),
          _buildName(user),
          const SizedBox(height: 10),

          Center(
            child: Text(
              'Ваш Email: ${firebaseUser?.email ?? "Неизвестно"}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),

          const SizedBox(height: 20),

// ⭐ Кнопка Настройки
const SizedBox(height: 160),
Center(
  child: SizedBox(
    width: 200,
    height: 50,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF064A8F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/settings');
      },
      child: const Text(
        'Настройки',
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    ),
  ),
),
        ],
      ),
    );
  }

  Widget _buildName(Profile user) => Column(
        children: [
          Text(
            user.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
        ],
      );
}
