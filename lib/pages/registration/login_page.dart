import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/pages/snack_bar.dart';
import 'package:myapp/services/yandex_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isHiddenPassword = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    final navigator = Navigator.of(context);

    if (!formKey.currentState!.validate()) return;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        SnackBarService.showSnackBar(
          context,
          'Неправильный email или пароль. Повторите попытку',
          true,
        );
      } else {
        SnackBarService.showSnackBar(
          context,
          'Неизвестная ошибка! Попробуйте еще раз.',
          true,
        );
      }
      return;
    }

    navigator.pushNamedAndRemoveUntil('/first', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final height = screen.height;
    final width = screen.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      body: Stack(
        children: [
          // ⭐ Фон
          Positioned.fill(
            child: Image.asset(
              'lib/assets/images/Registr.png',
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.06,
                        vertical: height * 0.03,
                      ),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ⭐ Назад
                            IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.arrow_back),
                              color: Colors.black,
                              iconSize: width * 0.08,
                              onPressed: () => Navigator.of(context)
                                  .pushNamed('/dobro_pozalovat'),
                            ),

                            SizedBox(height: height * 0.04),

                            // ⭐ Логотип
                            Center(
                              child: Text(
                                'SkillMe',
                                style: TextStyle(
                                  fontSize: width * 0.18,
                                  fontFamily: 'Alana',
                                  color: Colors.black,
                                ),
                              ),
                            ),

                            SizedBox(height: height * 0.06),

                            // ⭐ Email
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
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (email) =>
                                    email != null &&
                                            !EmailValidator.validate(email)
                                        ? 'Введите корректный Email'
                                        : null,
                                decoration: InputDecoration(
                                  hintText: 'Введите Email',
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: width * 0.05,
                                    vertical: height * 0.02,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: height * 0.025),

                            // ⭐ Пароль
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
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: width * 0.05,
                                    vertical: height * 0.02,
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
                                    onPressed: () => setState(() =>
                                        isHiddenPassword = !isHiddenPassword),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: height * 0.05),

                            // ⭐ Кнопка Войти
                            SizedBox(
                              width: double.infinity,
                              height: height * 0.065,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromRGBO(40, 43, 74, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: login,
                                child: Text(
                                  'Войти',
                                  style: TextStyle(
                                    fontSize: width * 0.05,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: height * 0.06),

                            // ⭐ Яндекс
                            Center(
                              child: GestureDetector(
                                onTap: () async {
                                  final result = await YandexAuth.signIn();
                                  if (result != null) {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/first',
                                      (route) => false,
                                    );
                                  }
                                },
                                child: SizedBox(
                                  width: width * 0.15,
                                  height: width * 0.15,
                                  child: Image.asset(
                                    'lib/assets/images/Yandex.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),

                            Center(
                              child: TextButton(
                                onPressed: () => Navigator.of(context)
                                    .pushNamed('/reset_password'),
                                child: const Text(
                                  'Сбросить пароль',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: height * 0.015),

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

                            SizedBox(height: height * 0.03),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
