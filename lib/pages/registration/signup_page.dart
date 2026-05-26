import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/pages/snack_bar.dart';
import 'package:myapp/pages/registration/email_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final apiKey = dotenv.env['API_KEY'];

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isHiddenPassword = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    super.dispose();
  }

  void togglePasswordView() {
    setState(() => isHiddenPassword = !isHiddenPassword);
  }

  Future<void> signUp() async {
    final navigator = Navigator.of(context);

    if (!formKey.currentState!.validate()) return;

    if (passwordController.text.trim() != repeatPasswordController.text.trim()) {
      SnackBarService.showSnackBar(
        context,
        'Пароли должны совпадать',
        true,
      );
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        SnackBarService.showSnackBar(
          context,
          'Такой Email уже используется',
          true,
        );
        return;
      } else {
        SnackBarService.showSnackBar(
          context,
          'Ошибка! Попробуйте снова.',
          true,
        );
        return;
      }
    }

    navigator.pushReplacement(
      MaterialPageRoute(builder: (_) => const EmailPage()),
    );
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
                        onPressed: () => Navigator.pushNamed(context, '/dobro_pozalovat'),
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
                              onPressed: togglePasswordView,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // REPEAT PASSWORD
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
                          controller: repeatPasswordController,
                          obscureText: isHiddenPassword,
                          validator: (value) =>
                              value != null && value.length < 6
                                  ? 'Минимум 6 символов'
                                  : null,
                          decoration: InputDecoration(
                            hintText: 'Повторите пароль',
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
                              onPressed: togglePasswordView,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // SIGN UP BUTTON
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
                          onPressed: signUp,
                          child: const Text(
                            'Зарегистрироваться',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Center(
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/login'),
                          child: const Text(
                            'Уже есть аккаунт? Войти',
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
