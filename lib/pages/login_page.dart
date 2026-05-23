import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/pages/snack_bar.dart';
import 'package:myapp/services/yandex_auth.dart'; 

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginPage> {
  bool isHiddenPassword = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  int currentIndex = 0;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    final navigator = Navigator.of(context);

    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e.code);

      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        SnackBarService.showSnackBar(
          context,
          'Неправильный email или пароль. Повторите попытку',
          true,
        );
        return;
      } else {
        SnackBarService.showSnackBar(
          context,
          'Неизвестная ошибка! Попробуйте еще раз или обратитесь в поддержку.',
          true,
        );
        return;
      }
    }

    navigator.pushNamedAndRemoveUntil('/first', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      body: Stack(
        children: [

          Positioned.fill(
            child: Image.asset(
              'lib/assets/images/Registr.png',
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.arrow_back),
                        color: Colors.black,
                        iconSize: 28,
                        onPressed: () => Navigator.of(context).pushNamed('/dobro_pozalovat'),
                      ),

                      const SizedBox(height: 40),

                      Center(
                        child: Text(
                          'SkillMe',
                          style: TextStyle(
                            fontSize: 75,
                            fontFamily: 'Alana',
                            color: Colors.black,
                          ),
                        ),
                      ),

                      const SizedBox(height: 50),

                      // EMAIL
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFCBDDFD),
                              Color(0xFF5D65D6),
                            ],
                            stops: [0.6, 1.0],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                        ),
                        child: TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (email) =>
                              email != null && !EmailValidator.validate(email)
                                  ? 'Введите корректный Email'
                                  : null,
                          decoration: InputDecoration(
                            hintText: 'Введите Email',
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 18,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // PASSWORD
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFCBDDFD),
                              Color(0xFF5D65D6),
                            ],
                            stops: [0.6, 1.0],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: isHiddenPassword,
                          validator: (value) =>
                              value != null && value.length < 6
                                  ? 'Минимум 6 символов'
                                  : null,
                          decoration: InputDecoration(
                            hintText: 'Введите пароль',
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 18,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isHiddenPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() => isHiddenPassword = !isHiddenPassword);
                              },
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // LOGIN BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(40, 43, 74, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: login,
                          child: const Text(
                            'Войти',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(235, 255, 255, 255),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 55),

                      // SOCIALS — Яндекс
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final result = await YandexAuth.signIn();
                              print(result);

                              if (result != null) {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/first',
                                  (route) => false,
                                );
                              }
                            },
                            child: SizedBox(
                              width: 55,
                              height: 55,
                              child: Image.asset(
                                'lib/assets/images/Yandex.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),

                      Center(
                        child: TextButton(
                          onPressed: () =>
                              Navigator.of(context).pushNamed('/reset_password'),
                          child: const Text(
                            'Сбросить пароль',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      Center(
                        child: GestureDetector(
                          onTap: () =>
                              Navigator.of(context).pushNamed('/signup'),
                          child: const Text(
                            'Еще нет аккаунта? Регистрация',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}