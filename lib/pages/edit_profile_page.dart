import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/user_preferences.dart';
import 'package:myapp/utils/app_strings.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController nicknameController;
  String? photoPath;

  @override
  void initState() {
    super.initState();
    final user = UserPreferences.myUser;

    nameController = TextEditingController(text: user.name);
    nicknameController = TextEditingController(text: user.nickname);
    photoPath = user.imagePath;
  }

  Future<void> pickPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() => photoPath = picked.path);
    }
  }

  Future<void> save() async {
    final updatedUser = UserPreferences.myUser.copyWith(
      name: nameController.text,
      nickname: nicknameController.text,
      imagePath: photoPath ?? "",
    );

    await UserPreferences.setUser(updatedUser);

    if (!mounted) return;
    Navigator.pop(context, updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        /*title: Text(
          AppStrings.get('account_edit_profile').toUpperCase(),
          style: const TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),*/
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // АВАТАР
            GestureDetector(
              onTap: pickPhoto,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFCBDDFD),
                      Color(0xFF5D65D6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(4),
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: (photoPath != null && photoPath!.isNotEmpty)
                      ? FileImage(File(photoPath!))
                      : null,
                  child: (photoPath == null || photoPath!.isEmpty)
                      ? const Icon(Icons.camera_alt, size: 40)
                      : null,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ПОЛЕ "Имя"
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFCBDDFD),
                    Color(0xFF5D65D6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: AppStrings.get('account_name'),
                  labelStyle: const TextStyle(color: Colors.black),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                cursorColor: Colors.black,
                style: const TextStyle(color: Colors.black),
              ),
            ),

            const SizedBox(height: 20),

            // ПОЛЕ "Ник"
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFCBDDFD),
                    Color(0xFF5D65D6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                controller: nicknameController,
                decoration: InputDecoration(
                  labelText: AppStrings.get('account_nickname'),
                  labelStyle: const TextStyle(color: Colors.black),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                cursorColor: Colors.black,
                style: const TextStyle(color: Colors.black),
              ),
            ),

            const SizedBox(height: 40),

            // КНОПКА "Сохранить"
            SizedBox(
              width: double.infinity,
              height: 55,
              child: InkWell(
                onTap: save,
                borderRadius: BorderRadius.circular(14),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFCBDDFD),
                        Color(0xFF5D65D6),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      AppStrings.get('save'),
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}