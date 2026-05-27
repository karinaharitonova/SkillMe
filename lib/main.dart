import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:myapp/utils/theme_provider.dart';
import 'package:myapp/utils/language_provider.dart';

import 'package:myapp/widget/splash_screen.dart';  
import 'package:myapp/pages/first_page.dart';
import 'package:myapp/pages/home_page.dart';
import 'package:myapp/pages/registration/signup_page.dart';
import 'package:myapp/pages/registration/reset_password_page.dart';
import 'package:myapp/pages/registration/login_page.dart';
import 'package:myapp/pages/dobro_pozalovat_page.dart';
import 'package:myapp/pages/categories_page.dart';
import 'package:myapp/pages/edit_profile_page.dart';
import 'package:myapp/pages/account_page.dart';
import 'package:myapp/pages/nickname_page.dart';
import 'package:myapp/pages/settings_page.dart';
import 'package:myapp/pages/registration/change_password_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await _requestNotificationPermission();
  await _saveDeviceToken();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Получено уведомление: ${message.notification?.title}");
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> _requestNotificationPermission() async {
  final messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  print("Уведомления разрешены: ${settings.authorizationStatus}");
}

Future<void> _saveDeviceToken() async {
  final token = await FirebaseMessaging.instance.getToken();
  print("FCM TOKEN: $token");

  if (token != null) {
    await FirebaseFirestore.instance
        .collection('deviceTokens')
        .doc(token)
        .set({'token': token});
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final languageProvider = context.watch<LanguageProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      locale: languageProvider.locale,

      supportedLocales: const [
        Locale('ru'),
        Locale('en'),
      ],

      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      themeMode: themeProvider.isDark ? ThemeMode.dark : ThemeMode.light,

      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF064A8F),
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF064A8F),
      ),

      home: const SplashScreen(),

      routes: {
        '/first': (context) => const FirstPage(),
        '/home': (context) => const HomePage(),
        '/signup': (context) => const SignUpPage(),
        '/reset_password': (context) => const ResetPasswordPage(),
        '/login': (context) => const LoginPage(),
        '/dobro_pozalovat': (context) => const DobroPozalovatPage(),
        '/categories': (context) => const CategoriesPage(),
        '/edit-profile': (context) => const EditProfilePage(),
        '/create-profile': (context) => const NicknamePage(),
        '/account': (context) => const AccountPage(),
        '/nickname': (context) => const NicknamePage(),
        '/settings': (context) => const SettingsPage(),
        '/change-password': (context) => const ChangePasswordPage(),
      },
    );
  }
}
