import 'package:flutter/material.dart';
import 'package:myapp/pages/first_page.dart';
import 'package:myapp/pages/home_page.dart';
import 'package:myapp/pages/signup_page.dart';
import 'package:myapp/pages/reset_password_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  runApp(const MyApp());
}


final apiKey = dotenv.env['API_KEY'];


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:FirstPage(),
      routes: {
        '/first': (context) => FirstPage(),
        '/home': (context) => HomePage(),
        '/signup': (context) => const SignUpPage(),
        '/reset_password': (context) => const ResetPasswordPage(),
      },
    );
  }
}
