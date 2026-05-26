import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:myapp/pages/registration/login_page.dart';

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
              'lib/assets/images/A4 - 1.png',
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
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
                    fontSize: 40,
                    fontFamily: 'Amagro',
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                const Spacer(flex: 3),

                Center(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF282B4A), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                  child: const Text(
                    'ВХОД',
                    style: TextStyle(
                      fontSize: 35,
                      fontFamily: 'Amagro',
                      color: Color(0xFF282B4A),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF282B4A), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),    
                    ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: const Text(
                    'РЕГИСТРАЦИЯ',
                    style: TextStyle(
                      fontSize: 35,
                      fontFamily: 'Amagro',
                      color: Color(0xFF282B4A),
                    ),
                  ),
                ),
              ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
