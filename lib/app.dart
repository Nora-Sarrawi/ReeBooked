import 'package:flutter/material.dart';
import 'package:rebooked_app/views/start_page/start_page.dart';
import 'package:rebooked_app/core/theme.dart';

class ReBooked extends StatelessWidget {
  const ReBooked({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReBooked',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const StartScreen(),
    );
  }
}
