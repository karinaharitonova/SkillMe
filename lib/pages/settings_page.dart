import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:myapp/utils/theme_provider.dart';
import 'package:myapp/utils/language_provider.dart';
import 'package:myapp/utils/user_preferences.dart';
import 'package:myapp/pages/admin_upload_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = false;

  int _versionTapCount = 0;
  Timer? _versionTapTimer;

  @override
  void initState() {
    super.initState();
    loadState();
  }

  Future<void> loadState() async {
    notificationsEnabled = await UserPreferences.getNotificationsEnabled();
    setState(() {});
  }

  Future<void> toggleNotifications(bool value) async {
    if (!value) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Отключить уведомления"),
          content: const Text("Вы действительно хотите отписаться от уведомлений?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Нет"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Да"),
            ),
          ],
        ),
      );

      if (confirm != true) {
        setState(() => notificationsEnabled = true);
        return;
      }
    }

    setState(() => notificationsEnabled = value);
    await UserPreferences.setNotificationsEnabled(value);

    final token = await FirebaseMessaging.instance.getToken();
    if (token == null) return;

    if (value) {
      await FirebaseFirestore.instance
          .collection('deviceTokens')
          .doc(token)
          .set({'token': token});
    } else {
      await FirebaseFirestore.instance
          .collection('deviceTokens')
          .doc(token)
          .delete();
    }
  }

  void _onVersionTileTap() {
    _versionTapCount++;
    _versionTapTimer?.cancel();
    _versionTapTimer = Timer(const Duration(seconds: 2), () {
      _versionTapCount = 0;
    });

    if (_versionTapCount >= 7) {
      _versionTapCount = 0;
      _onSecretTriggered();
    }
  }

  Future<void> _onSecretTriggered() async {
    final password = await showDialog<String?>(
      context: context,
      builder: (context) {
        String input = '';
        return AlertDialog(
          title: const Text('Введите пароль'),
          content: TextField(
            autofocus: true,
            obscureText: true,
            onChanged: (v) => input = v,
            decoration: const InputDecoration(hintText: 'Пароль'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
            TextButton(onPressed: () => Navigator.pop(context, input), child: const Text('ОК')),
          ],
        );
      },
    );

    if (password == null || password.isEmpty) return;

    // ЛОКАЛЬНАЯ проверка пароля
    if (password == "admin123") { 
      if (!mounted) return;
      Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminUploadPage()));
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Неверный пароль')),
      );
    }
  }

  @override
  void dispose() {
    _versionTapTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Настройки"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Профиль",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Редактировать профиль"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.pushNamed(context, '/edit-profile');
            },
          ),

          const SizedBox(height: 20),

          const Text(
            "Приложение",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          SwitchListTile(
            title: const Text("Уведомления"),
            value: notificationsEnabled,
            onChanged: toggleNotifications,
            activeColor: const Color(0xFF5D65D6),
            activeTrackColor: const Color(0xFFCBDDFD),
            secondary: const Icon(Icons.notifications),
          ),

          SwitchListTile(
            title: const Text("Тёмная тема"),
            value: context.watch<ThemeProvider>().isDark,
            onChanged: (value) {
              context.read<ThemeProvider>().toggleTheme(value);
            },
            secondary: const Icon(Icons.dark_mode),
            activeColor: const Color(0xFF5D65D6),
            activeTrackColor: const Color(0xFFCBDDFD),
          ),

          ListTile(
            leading: const Icon(Icons.language),
            title: const Text("Язык"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => _buildLanguageSheet(context),
              );
            },
          ),

          const SizedBox(height: 20),

          const Text(
            "Аккаунт",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text("Сменить пароль"),
            onTap: () {
              Navigator.pushNamed(context, '/change-password');
            },
          ),

          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text(
              "Удалить аккаунт",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Подтвердите удаление"),
                  content: const Text("Вы уверены, что хотите удалить аккаунт? Это действие нельзя отменить."),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Отмена"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Удалить"),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                try {
                  await FirebaseAuth.instance.currentUser?.delete();
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Ошибка при удалении аккаунта: $e")),
                  );
                }
              }
            },
          ),

          const SizedBox(height: 20),

          const Text(
            "О приложении",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          GestureDetector(
            onLongPress: _onSecretTriggered,
            onTap: _onVersionTileTap,
            child: const ListTile(
              leading: Icon(Icons.info),
              title: Text("Версия приложения"),
              subtitle: Text("1.0.0"),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Выберите язык",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.flag),
            title: const Text("Русский"),
            onTap: () {
              context.read<LanguageProvider>().setLanguage('ru');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.flag_outlined),
            title: const Text("English"),
            onTap: () {
              context.read<LanguageProvider>().setLanguage('en');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
