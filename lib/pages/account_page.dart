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
        title: const Text(style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),'АККАУНТ'),
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
          Center(
            child: ButtonWidget(
              text: 'Редактировать',
              onClicked: () {
                Navigator.pushNamed(context, '/edit-profile');
              },
            ),
          ),

          const SizedBox(height: 20),
          NumbersWidget(),
          const SizedBox(height: 40),
          _buildAbout(user),
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

  Widget _buildAbout(Profile user) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'О себе',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              user.about,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );
}
