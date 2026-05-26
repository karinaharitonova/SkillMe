import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/utils/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:myapp/utils/language_provider.dart';
import 'package:myapp/pages/registration/change_password_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  bool darkMode = false;

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
            onChanged: (value) {
              setState(() {
                notificationsEnabled = value;
              });
            },
            secondary: const Icon(Icons.notifications),
          ),

          SwitchListTile(
  title: const Text("Тёмная тема"),
  value: context.watch<ThemeProvider>().isDark,
  onChanged: (value) {
    context.read<ThemeProvider>().toggleTheme(value);
  },
  secondary: const Icon(Icons.dark_mode),
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

          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("Версия приложения"),
            subtitle: const Text("1.0.0"),
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
