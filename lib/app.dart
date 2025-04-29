import 'package:flutter/material.dart';
import 'package:rebooked_app/providers/swap_provider.dart';
import 'package:rebooked_app/views/auth/reset_password/reset_password_screen2.dart';
import 'package:rebooked_app/views/auth/reset_password/reset_password_screen3.dart';
import 'package:rebooked_app/views/books/add_book_screen.dart';
import 'package:rebooked_app/views/start_page/start_page.dart';
import 'package:rebooked_app/core/theme.dart';
import 'package:rebooked_app/views/shell/shell_scaffold.dart';

class ReBooked extends StatelessWidget {
  const ReBooked({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReBooked',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const StartScreen(),
    );
  }
}
