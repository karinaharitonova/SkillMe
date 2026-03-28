import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:myapp/pages/login_page.dart';

final apiKey = dotenv.env['API_KEY'];

class DobroPozalovatPage extends StatelessWidget {
  const DobroPozalovatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      body: Stack(
        children: [

          Positioned.fill(
            child: Image.asset(
              'lib/images/A4 - 1.png',
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.close, size: 30, color: Colors.black),
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/first',
                        (route) => false,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Добро \nпожаловать!',
                  style: TextStyle(
                    fontSize: 65,
                    fontFamily: 'GreatVibes',
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // ОПУСКАЕМ КНОПКИ НИЖЕ
                const Spacer(flex: 3),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF064A8F), width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                    child: const Text(
                      'ВОЙТИ',
                      style: TextStyle(fontSize: 18,
                        color: Color(0xFF064A8F),
                    ),
                  ),
                ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF064A8F), width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: const Text(
                      'РЕГИСТРАЦИЯ',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF064A8F),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
