import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/utils/app_strings.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final formKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;
  bool hideOld = true;
  bool hideNew = true;
  bool hideConfirm = true;

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> changePassword() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (!formKey.currentState!.validate()) return;

    final oldPassword = oldPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (newPassword != confirmPassword) {
      _showMessage(AppStrings.get('msg_passwords_not_match'));
      return;
    }

    if (newPassword.length < 6) {
      _showMessage(AppStrings.get('password_min_length_full'));
      return;
    }

    setState(() => isLoading = true);

    try {
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );

      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);

      _showMessage(AppStrings.get('password_changed'));
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        _showMessage(AppStrings.get('wrong_old_password'));
      } else {
        _showMessage('${AppStrings.get('error')}: ${e.message ?? AppStrings.get('error_try_again')}');
      }
    } catch (_) {
      _showMessage(AppStrings.get('error_try_later'));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _showMessage(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required double horizontalPadding,
    required double verticalPadding,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      contentPadding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      suffixIcon: suffix,
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback toggle,
    required double width,
    required double height,
    required bool isNewPassword,
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
        validator: (v) {
          if (v == null || v.trim().isEmpty) return AppStrings.get('msg_field_required');
          if (isNewPassword && v.trim().length < 6) return AppStrings.get('password_min_length');
          return null;
        },
        decoration: _inputDecoration(
          hint: hint,
          horizontalPadding: width * 0.05,
          verticalPadding: height * 0.02,
          suffix: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: Colors.white),
            onPressed: toggle,
          ),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
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
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
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
                              color: Theme.of(context).iconTheme.color,
                              iconSize: (width * 0.08).clamp(20.0, 32.0),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  AppStrings.get('change_password_title').toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: height * 0.05),

                        // Старый пароль
                        _buildPasswordField(
                          controller: oldPasswordController,
                          hint: AppStrings.get('old_password'),
                          obscure: hideOld,
                          toggle: () => setState(() => hideOld = !hideOld),
                          width: width,
                          height: height,
                          isNewPassword: false,
                        ),

                        SizedBox(height: height * 0.03),

                        // Новый пароль
                        _buildPasswordField(
                          controller: newPasswordController,
                          hint: AppStrings.get('new_password'),
                          obscure: hideNew,
                          toggle: () => setState(() => hideNew = !hideNew),
                          width: width,
                          height: height,
                          isNewPassword: true,
                        ),

                        SizedBox(height: height * 0.03),

                        // Подтверждение пароля
                        _buildPasswordField(
                          controller: confirmPasswordController,
                          hint: AppStrings.get('confirm_password'),
                          obscure: hideConfirm,
                          toggle: () => setState(() => hideConfirm = !hideConfirm),
                          width: width,
                          height: height,
                          isNewPassword: false,
                        ),

                        SizedBox(height: height * 0.05),

                        // Кнопка сохранить
                        SizedBox(
                          width: double.infinity,
                          height: height * 0.065,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(40, 43, 74, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: isLoading ? null : changePassword,
                            child: isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : Text(
                                    AppStrings.get('save'),
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