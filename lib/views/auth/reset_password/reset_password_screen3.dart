import 'package:flutter/material.dart';
import 'package:rebooked_app/core/theme.dart';
import 'package:rebooked_app/views/auth/reset_password/reset_password_screen2.dart';
import 'package:rebooked_app/widgets/primary_button.dart';

class ResetPasswordScreen3 extends StatefulWidget {
  const ResetPasswordScreen3({super.key});

  @override
  _ResetPasswordScreen3State createState() => _ResetPasswordScreen3State();
}

class _ResetPasswordScreen3State extends State<ResetPasswordScreen3> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void _resetPassword() {
    if (_formKey.currentState?.validate() ?? false) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text(
            'Password Reset Successful!',
            style: TextStyle(color: AppColors.secondary),
          ),
          content: const Text(
            'Your password has been reset successfully.',
            style: TextStyle(color: AppColors.secondary),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'OK',
                style: TextStyle(color: AppColors.secondary),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.06,
              vertical: screenHeight * 0.02,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: screenHeight * 0.02,
                      bottom: screenHeight * 0.02,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          color: AppColors.secondary,
                          onPressed: () {
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) => ResetPasswordScreen2()),);
                          },
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Text(
                          'Reset Password',
                          style: theme.textTheme.headlineLarge?.copyWith(
                            color: AppColors.secondary,
                            fontSize: screenWidth > 600 ? 25 : 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.1),
                  _buildLabeledTextField(
                    label: 'New Password',
                    controller: _newPasswordController,
                    theme: theme,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    isConfirmPassword: false,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  _buildLabeledTextField(
                    label: 'Confirm Password',
                    controller: _confirmPasswordController,
                    theme: theme,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    isConfirmPassword: true,
                  ),
                  SizedBox(height: screenHeight * 0.24),
                  Center(
                    child: PrimaryButton(
                      text: 'Reset Password',
                      color: AppColors.secondary,
                      onPressed: _resetPassword,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledTextField({
    required String label,
    required TextEditingController controller,
    required ThemeData theme,
    required double screenWidth,
    required double screenHeight,
    required bool isConfirmPassword,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            color: AppColors.secondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        TextFormField(
          controller: controller,
          obscureText: true,
          cursorColor: AppColors.secondary,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w300,
            color: AppColors.secondary,
          ),
          decoration: InputDecoration(
            hintText: label,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.secondary.withOpacity(0.6),
            ),
            filled: true,
            fillColor: AppColors.texe_field_background,
            contentPadding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.06,
              vertical: screenHeight * 0.02,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                color: AppColors.secondary,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                color: AppColors.secondary,
                width: 2,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please fill this field';
            }
            if (!isConfirmPassword && value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            if (isConfirmPassword && value != _newPasswordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
      ],
    );
  }
}
