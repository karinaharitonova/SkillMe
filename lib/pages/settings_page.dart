import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:myapp/utils/theme_provider.dart';
import 'package:myapp/utils/language_provider.dart';
import 'package:myapp/utils/user_preferences.dart';
import 'package:myapp/utils/app_strings.dart';
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
          title: Text(AppStrings.get('settings_disable_notifications')),
          content: Text(AppStrings.get('settings_disable_notifications_confirm')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(AppStrings.get('no')),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(AppStrings.get('yes')),
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
          title: Text(AppStrings.get('settings_enter_password')),
          content: TextField(
            autofocus: true,
            obscureText: true,
            onChanged: (v) => input = v,
            decoration: InputDecoration(
              hintText: AppStrings.get('settings_password_hint'),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppStrings.get('cancel')),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, input),
              child: Text(AppStrings.get('ok')),
            ),
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
        SnackBar(content: Text(AppStrings.get('settings_wrong_password'))),
      );
    }
  }

  // Перезапуск приложения после смены языка
  void _restartApp() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/first',
      (route) => false,
    );
  }

  @override
  void dispose() {
    _versionTapTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppStrings.get('settings_title')),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                AppStrings.get('settings_section_profile'),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              ListTile(
                leading: const Icon(Icons.person),
                title: Text(AppStrings.get('account_edit_profile')),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pushNamed(context, '/edit-profile');
                },
              ),

              const SizedBox(height: 20),

              Text(
                AppStrings.get('settings_section_app'),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              SwitchListTile(
                title: Text(AppStrings.get('settings_notifications')),
                value: notificationsEnabled,
                onChanged: toggleNotifications,
                activeColor: const Color(0xFF5D65D6),
                activeTrackColor: const Color(0xFFCBDDFD),
                secondary: const Icon(Icons.notifications),
              ),

              SwitchListTile(
                title: Text(AppStrings.get('settings_theme_dark')),
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
                title: Text(AppStrings.get('settings_language')),
                subtitle: Text(
                  languageProvider.currentLanguage == 'ru' 
                      ? AppStrings.get('language_russian')
                      : AppStrings.get('language_english'),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => _buildLanguageSheet(context),
                  );
                },
              ),

              const SizedBox(height: 20),

              Text(
                AppStrings.get('settings_section_account'),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              ListTile(
                leading: const Icon(Icons.lock),
                title: Text(AppStrings.get('account_change_password')),
                onTap: () {
                  Navigator.pushNamed(context, '/change-password');
                },
              ),

              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: Text(
                  AppStrings.get('settings_delete_account'),
                  style: const TextStyle(color: Colors.red),
                ),
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text(AppStrings.get('settings_confirm_delete')),
                      content: Text(AppStrings.get('settings_delete_warning')),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(AppStrings.get('cancel')),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          onPressed: () => Navigator.pop(context, true),
                          child: Text(AppStrings.get('delete')),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    try {
                      await FirebaseAuth.instance.currentUser?.delete();
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${AppStrings.get('settings_delete_error')}: $e')),
                        );
                      }
                    }
                  }
                },
              ),

              const SizedBox(height: 20),

              Text(
                AppStrings.get('settings_about'),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              GestureDetector(
                onLongPress: _onSecretTriggered,
                onTap: _onVersionTileTap,
                child: ListTile(
                  leading: const Icon(Icons.info),
                  title: Text(AppStrings.get('settings_version')),
                  subtitle: const Text("1.0.0"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.get('settings_choose_language'),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.flag),
            title: Text(AppStrings.get('language_russian')),
            trailing: context.watch<LanguageProvider>().currentLanguage == 'ru'
                ? const Icon(Icons.check, color: Colors.green)
                : null,
            onTap: () async {
              await context.read<LanguageProvider>().setLanguage('ru');
              if (context.mounted) {
                Navigator.pop(context);
                _restartApp();
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.flag_outlined),
            title: Text(AppStrings.get('language_english')),
            trailing: context.watch<LanguageProvider>().currentLanguage == 'en'
                ? const Icon(Icons.check, color: Colors.green)
                : null,
            onTap: () async {
              await context.read<LanguageProvider>().setLanguage('en');
              if (context.mounted) {
                Navigator.pop(context);
                _restartApp();
              }
            },
          ),
        ],
      ),
    );
  }
}