import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
import 'package:myapp/utils/user_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Загружаем .env
  await dotenv.load(fileName: ".env");
  final url = dotenv.env['SUPABASE_URL'] ?? 'NULL';
  final anon = dotenv.env['SUPABASE_ANON_KEY'] ?? 'NULL';
  print('SUPABASE_URL prefix: ${url.length > 20 ? url.substring(0, 20) : url}');
  print('SUPABASE_ANON_KEY prefix: ${anon.length > 8 ? anon.substring(0, 8) : anon}');

  // 2. Инициализируем Firebase
  await Firebase.initializeApp();

  // 3. Инициализируем Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  // 4. Загружаем профиль пользователя (включая настройки языка)
  await UserPreferences.loadUser();

  // 5. Настройка уведомлений
  await _requestNotificationPermission();
  await _syncInitialNotificationState();
  await _saveDeviceToken();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Получено уведомление: ${message.notification?.title}");
  });

  // 6. Запуск приложения
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
  await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
}

Future<void> _syncInitialNotificationState() async {
  final settings = await FirebaseMessaging.instance.getNotificationSettings();
  final allowed = settings.authorizationStatus == AuthorizationStatus.authorized;
  await UserPreferences.setNotificationsEnabled(allowed);
}

Future<void> _saveDeviceToken() async {
  final enabled = await UserPreferences.getNotificationsEnabled();
  if (!enabled) return;

  final token = await FirebaseMessaging.instance.getToken();
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
      
      // Локаль из LanguageProvider
      locale: languageProvider.locale,
      supportedLocales: const [
        Locale('ru'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      
      // Тема
      themeMode: themeProvider.isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF064A8F),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF5D65D6),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF2B233A),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF352A47),
        ),
        cardColor: const Color(0xFF352A47),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1A1A1A),
          selectedItemColor: Color(0xFFCBDDFD),
          unselectedItemColor: Colors.white70,
          type: BottomNavigationBarType.fixed,
        ),
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