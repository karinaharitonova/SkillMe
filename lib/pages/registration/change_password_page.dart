import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;

  Future<void> changePassword() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final oldPassword = oldPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (newPassword != confirmPassword) {
      _showMessage("Пароли не совпадают");
      return;
    }

    if (newPassword.length < 6) {
      _showMessage("Пароль должен быть минимум 6 символов");
      return;
    }

    setState(() => isLoading = true);

    try {
      // Переавторизация
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );

      await user.reauthenticateWithCredential(cred);

      // Обновление пароля
      await user.updatePassword(newPassword);

      _showMessage("Пароль успешно изменён");

      Navigator.pop(context);
    } catch (e) {
      _showMessage("Ошибка: неверный старый пароль");
    }

    setState(() => isLoading = false);
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Сменить пароль"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: oldPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Старый пароль",
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Новый пароль",
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Подтвердите пароль",
              ),
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : changePassword,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Сохранить"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
