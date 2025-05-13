import 'package:flutter/material.dart';
import 'package:rebooked_app/views/start_page/start_page.dart';
import 'package:rebooked_app/core/theme.dart';
import 'package:rebooked_app/core/router.dart';

class ReBooked extends StatelessWidget {
  const ReBooked({super.key});

  @override
 Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ReBooked',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      routerConfig: router, // 👈 This connects GoRouter to your app
    );
  }
}