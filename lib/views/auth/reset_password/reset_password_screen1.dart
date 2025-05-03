import 'package:flutter/material.dart';
import 'package:rebooked_app/core/theme.dart';
import 'package:rebooked_app/views/auth/reset_password/reset_password_screen2.dart';
import 'package:rebooked_app/widgets/primary_button.dart';

class ResetPasswordScreen1 extends StatelessWidget {
  const ResetPasswordScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ResetPasswordScreen2()),
                          );
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
