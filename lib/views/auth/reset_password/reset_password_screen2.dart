import 'package:flutter/material.dart';
import 'package:rebooked_app/core/theme.dart';

import '../../../widgets/priary_button.dart';

class ResetPasswordScreen2 extends StatelessWidget {
  const ResetPasswordScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.03,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.1),
                  Text(
                    'Enter your verification code',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: AppColors.secondary,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Container(
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    decoration: BoxDecoration(
                      color: AppColors.offWhite,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.vpn_key_rounded,
                      size: screenWidth * 0.15,
                      color: AppColors.secondary,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (index) {
                      return SizedBox(
                        width: screenWidth * 0.13,
                        child: TextField(
                          textAlign: TextAlign.center,
                          maxLength: 20,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            counterText: "",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: AppColors.secondary,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      "If you didn't receive a code, Resend",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  PrimaryButton(
                    text: 'Verify',
                    onPressed: () {
                      Navigator.pushNamed(context, '/reset-password/step3');
                    },
                    color: AppColors.secondary,
                    width: double.infinity,
                    height: screenHeight * 0.07,
                  ),
                ],
              ),
            ),
            Positioned(
              left: screenWidth * 0.04, 
              top: screenHeight * 0.02, 
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppColors.secondary,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/reset-password/step1');
                    },
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    'Verification',
                    style: TextStyle(
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
