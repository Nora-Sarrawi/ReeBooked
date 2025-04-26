import 'package:flutter/material.dart';
import 'package:rebooked_app/core/theme.dart';
import 'package:rebooked_app/widgets/priary_button.dart';

class ResetPasswordScreen3 extends StatefulWidget {
  const ResetPasswordScreen3({super.key});

  @override
  State<ResetPasswordScreen3> createState() => _ResetPasswordScreen3State();
}

class _ResetPasswordScreen3State extends State<ResetPasswordScreen3> {
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button and title
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
                      'Change Password',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.05),
                Text(
                  'Enter a new password',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                TextField(
                  obscureText: _obscureNewPassword,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.secondary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'At least 8 digits',
                    hintStyle: TextStyle(
                      color: AppColors.secondary.withOpacity(0.5),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                        color: AppColors.secondary,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                        color: AppColors.secondary,
                        width: 2,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.secondary,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureNewPassword = !_obscureNewPassword;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                Text(
                  'Confirm your password',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                TextField(
                  obscureText: _obscureConfirmPassword,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.secondary,
                  ),
                  decoration: InputDecoration(
                    hintText: '****',
                    hintStyle: TextStyle(
                      color: AppColors.secondary.withOpacity(0.5),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                        color: AppColors.secondary,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                        color: AppColors.secondary,
                        width: 2,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.secondary,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.1),
                Center(
                  child: PrimaryButton(
                    text: 'Set Password',
                    color: AppColors.secondary,
                    onPressed: () {
                      // Add your functionality here
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}