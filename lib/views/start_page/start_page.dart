import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFC76767), // ← colour the whole screen
      body: SafeArea(
        // container no longer needs its own background colour
        child: Stack(
          children: [
            // --- Logo oval ---
            Positioned(
              top: size.height * 0.12,
              left: (size.width - 362) / 2,
              child: Container(
                width: 362,
                height: 405,
                decoration: const ShapeDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.cover,
                  ),
                  shape: OvalBorder(),
                ),
              ),
            ),

            // --- "ReBooked" title ---
            Positioned(
              top: size.height * 0.50,
              left: 0,
              right: 0,
              child: const Center(
                child: Text(
                  'ReBooked',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            // --- Tagline ---
            Positioned(
              top: size.height * 0.57,
              left: 0,
              right: 0,
              child: const Center(
                child: Text(
                  'Where every book gets a second story',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            // --- Start button ---
            Positioned(
              top: size.height * 0.78,
              left: (size.width - 195) / 2,
              child: SizedBox(
                width: 195,
                height: 51,
                child: ElevatedButton(
                  onPressed: () {
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF7C873),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Start',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
