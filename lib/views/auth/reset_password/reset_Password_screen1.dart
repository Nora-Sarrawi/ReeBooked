import 'package:flutter/material.dart';
import 'package:rebooked_app/core/theme.dart';
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
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: AppColors.background,
              ),
            ),
            SingleChildScrollView(
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
                            Navigator.pop(context);
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
                            fontSize: 22,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w300,
                            color: AppColors.secondary,
                          ),
                          decoration: InputDecoration(
                            labelStyle: theme.textTheme.bodyLarge?.copyWith(
                              fontSize: 15,
                              color: AppColors.secondary,
                            ),
                            hintText: 'example@gmail.com',
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
                        ),
                        SizedBox(height: screenHeight * 0.25),
                        Center(
                          child: PrimaryButton(
                            text: 'Send Code',
                            color: AppColors.secondary,
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
