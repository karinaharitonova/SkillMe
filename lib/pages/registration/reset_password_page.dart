import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/pages/snack_bar.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    final navigator = Navigator.of(context);

    if (!formKey.currentState!.validate()) return;

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        SnackBarService.showSnackBar(
          context,
          'Такой email не зарегистрирован!',
          true,
        );
      } else {
        SnackBarService.showSnackBar(
          context,
          'Ошибка! Попробуйте снова.',
          true,
        );
      }
      return;
    }

    SnackBarService.showSnackBar(
      context,
      'Ссылка для сброса отправлена на почту',
      false,
    );

    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final height = screen.height;
    final width = screen.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      body: SafeArea(
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
                        Row(
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.arrow_back),
                              color: Colors.black,
                              iconSize: width * 0.08,
                              onPressed: () => Navigator.pop(context),
                            ),
                            SizedBox(width: width * 0.03),
                            Text(
                              'СБРОС ПАРОЛЯ',
                              style: TextStyle(
                                fontSize: width * 0.08,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: height * 0.05),

                        // Поле Email
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

                        SizedBox(height: height * 0.05),

                        // Кнопка сброса
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
                            onPressed: resetPassword,
                            child: Text(
                              'Сбросить пароль',
                              style: TextStyle(
                                fontSize: width * 0.05,
                                color: Colors.white,
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
    );
  }
}
