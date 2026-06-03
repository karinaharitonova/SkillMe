import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/pages/snack_bar.dart';
import 'package:myapp/pages/registration/email_page.dart';
import 'package:myapp/utils/app_strings.dart';
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
        AppStrings.get('signup_passwords_not_match'),
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
          AppStrings.get('signup_email_in_use'),
          true,
        );
      } else {
        SnackBarService.showSnackBar(
          context,
          AppStrings.get('login_error_unknown'),
          true,
        );
      }
      return;
    }

    navigator.pushReplacement(
      MaterialPageRoute(builder: (_) => const EmailPage()),
    );
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
          // Фон
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
                            // Назад
                            IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.arrow_back),
                              color: Colors.black,
                              iconSize: width * 0.08,
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/dobro_pozalovat'),
                            ),

                            SizedBox(height: height * 0.04),

                            //  Логотип
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

                            // Email
                            _buildGradientField(
                              controller: emailController,
                              hint: AppStrings.get('email_hint'),
                              validator: (email) =>
                                  email != null && !EmailValidator.validate(email)
                                      ? AppStrings.get('email_invalid')
                                      : null,
                              width: width,
                              height: height,
                            ),

                            SizedBox(height: height * 0.025),

                            // Пароль
                            _buildGradientField(
                              controller: passwordController,
                              hint: AppStrings.get('password_hint'),
                              obscure: isHiddenPassword,
                              validator: (value) =>
                                  value != null && value.length < 6
                                      ? AppStrings.get('password_min_length')
                                      : null,
                              suffix: IconButton(
                                icon: Icon(
                                  isHiddenPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.black,
                                ),
                                onPressed: togglePasswordView,
                              ),
                              width: width,
                              height: height,
                            ),

                            SizedBox(height: height * 0.025),

                            //  Повтор пароля
                            _buildGradientField(
                              controller: repeatPasswordController,
                              hint: AppStrings.get('repeat_password_hint'),
                              obscure: isHiddenPassword,
                              validator: (value) =>
                                  value != null && value.length < 6
                                      ? AppStrings.get('password_min_length')
                                      : null,
                              suffix: IconButton(
                                icon: Icon(
                                  isHiddenPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.black,
                                ),
                                onPressed: togglePasswordView,
                              ),
                              width: width,
                              height: height,
                            ),

                            SizedBox(height: height * 0.05),

                            // Кнопка регистрации
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
                                onPressed: signUp,
                                child: Text(
                                  AppStrings.get('auth_sign_up'),
                                  style: TextStyle(
                                    fontSize: width * 0.05,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: height * 0.03),

                            Center(
                              child: GestureDetector(
                                onTap: () =>
                                    Navigator.pushNamed(context, '/login'),
                                child: Text(
                                  AppStrings.get('already_have_account_login'),
                                  style: const TextStyle(
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

  Widget _buildGradientField({
    required TextEditingController controller,
    required String hint,
    required double width,
    required double height,
    bool obscure = false,
    String? Function(String?)? validator,
    Widget? suffix,
  }) {
    return Container(
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
        controller: controller,
        obscureText: obscure,
        validator: validator,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black),
          contentPadding: EdgeInsets.symmetric(
            horizontal: width * 0.05,
            vertical: height * 0.02,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          suffixIcon: suffix,
        ),
      ),
    );
  }
}