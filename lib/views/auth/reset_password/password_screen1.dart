import 'package:flutter/material.dart';
import 'package:rebooked_app/core/theme.dart';
import 'package:rebooked_app/widgets/primary_button.dart';
import 'package:rebooked_app/services/auth_service.dart';

class ResetPasswordScreen1 extends StatelessWidget {
  const ResetPasswordScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final TextEditingController emailController = TextEditingController();
    final authService = AuthService();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.06,
              vertical: screenHeight * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: AppColors.secondary,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Text(
                      'Forgot Password',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.05),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.15),
                    Text(
                      'Enter your Email address',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w300,
                        color: AppColors.secondary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'example@gmail.com',
                        hintStyle: TextStyle(color: AppColors.secondary),
                        filled: true,
                        fillColor: theme.scaffoldBackgroundColor,
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
                    ),
                    SizedBox(height: screenHeight * 0.18),
                    Center(
                      child: PrimaryButton(
                        text: 'Send Code',
                        color: AppColors.secondary,
                        onPressed: () async {
                          final email = emailController.text.trim();

                          if (email.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text('Error',style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.secondary.withOpacity(0.8), )),
                                content: Text('Please enter your email address.'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: Text('OK',style: theme.textTheme.bodyMedium?.copyWith(
                                      color: AppColors.secondary.withOpacity(0.8), )),
                                  ),
                                ],
                              ),
                            );
                            return;
                          }

                          try {
                            await authService.sendPasswordResetEmail(email);
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text('Check your email'),
                                content: Text('A password reset link has been sent to your email.' , style: theme.textTheme.bodyMedium?.copyWith(
                                    color: AppColors.secondary.withOpacity(0.8), ),),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: Text('OK',style: theme.textTheme.bodyMedium?.copyWith(
                                      color: AppColors.secondary.withOpacity(0.8), )),
                                  ),
                                ],
                              ),
                            );
                          } catch (e) {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text('Error',style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.secondary.withOpacity(0.8), )),
                                content: Text('Something went wrong. Please try again later.' ,style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.secondary.withOpacity(0.8), )),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: Text('OK' ,style: theme.textTheme.bodyMedium?.copyWith(
                                      color: AppColors.secondary.withOpacity(0.8), )),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
