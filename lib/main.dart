import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/pages/first_page.dart';
import 'package:myapp/pages/home_page.dart';
import 'package:myapp/pages/signup_page.dart';
import 'package:myapp/pages/reset_password_page.dart';
import 'package:myapp/pages/login_page.dart';
import 'package:myapp/pages/dobro_pozalovat_page.dart';
import 'package:myapp/pages/categories_page.dart';
import 'package:myapp/pages/edit_profile_page.dart';
import 'package:myapp/pages/following_page.dart';
import 'package:myapp/pages/account_page.dart';
import 'package:myapp/pages/nickname_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Разрешение на уведомления
  await _requestNotificationPermission();

  await _saveDeviceToken();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Получено уведомление: ${message.notification?.title}");
  });

  runApp(const MyApp());
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirstPage(),
      routes: {
        '/first': (context) => FirstPage(),
        '/home': (context) => HomePage(),
        '/signup': (context) => const SignUpPage(),
        '/reset_password': (context) => const ResetPasswordPage(),
        '/login': (context) => const LoginPage(),
        '/dobro_pozalovat': (context) => const DobroPozalovatPage(),
        '/categories': (context) => const CategoriesPage(),
        '/edit-profile': (context) => const EditProfilePage(),
        '/following': (context) => const FollowingPage(),
        '/create-profile': (context) => const NicknamePage(),
        '/account': (context) => const AccountPage(),
        '/nickname': (context) => const NicknamePage(),
      },
    );
  }
}
