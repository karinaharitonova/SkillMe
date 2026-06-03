import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../model/profile.dart';
import '../utils/user_preferences.dart';

class NicknamePage extends StatefulWidget {
  const NicknamePage({super.key});

  @override
  State<NicknamePage> createState() => _NicknamePageState();
}

class _NicknamePageState extends State<NicknamePage> {
  final nameController = TextEditingController();
  final nicknameController = TextEditingController();
  String? photoPath;

  Future<void> pickPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() => photoPath = picked.path);
    }
  }

  Future<void> saveProfile() async {
    final newUser = Profile(
      name: nameController.text,
      about: "Расскажите о себе",
      imagePath: photoPath ?? "",
      email: "",
      nickname: nicknameController.text,
      isDarkMode: false, 
    );

    await UserPreferences.setUser(newUser);

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, "/account");
  }

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
                  GestureDetector(
                    onTap: pickPhoto,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage:
                          photoPath != null ? FileImage(File(photoPath!)) : null,
                      child: photoPath == null
                          ? const Icon(Icons.camera_alt, size: 40, color: Colors.blue)
                          : null,
                    ),
                  ),

                  const SizedBox(height: 30),

                  _inputField("Введите имя", nameController),
                  const SizedBox(height: 15),
                  _inputField("Введите никнейм", nicknameController),
                ],
              ),
            ),

            const SizedBox(height: 40),

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
                onPressed: saveProfile,
                child: const Text(
                  "Продолжить",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _inputField(String hint, TextEditingController controller) {
    return Container(
      width: 300,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        ),
      ),
    );
  }
}