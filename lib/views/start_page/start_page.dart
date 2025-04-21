import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // responsive numbers
    final double logoW = size.width * 0.65; // 65 % of width
    final double logoH = logoW * 1.12; // keep aspect
    final double btnW = size.width * 0.45; // 45 % of width
    final double titleF = (size.width * 0.10).clamp(32, 48);
    final double tagF = (size.width * 0.04).clamp(12, 18);
    final double btnF = (size.width * 0.07).clamp(20, 30);

    return Scaffold(
      backgroundColor: const Color(0xFFC76767),
      body: SafeArea(
        child: Stack(
          children: [
            // Logo
            Positioned(
              top: size.height * 0.12,
              left: (size.width - logoW) / 2,
              child: Container(
                width: logoW,
                height: logoH,
                decoration: const ShapeDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.cover,
                  ),
                  shape: OvalBorder(),
                ),
              ),
            ),

            // Title
            Positioned(
              top: size.height * 0.50,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'ReBooked',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: titleF,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            // Tagline
            Positioned(
              top: size.height * 0.57,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Where every book gets a second story',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: tagF,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            // Button
            Positioned(
              top: size.height * 0.78,
              left: (size.width - btnW) / 2,
              child: SizedBox(
                width: btnW,
                height: kMinInteractiveDimension, // 48dp per Material spec
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF7C873),
                    elevation: 0,
                  ),
                  child: Text(
                    'Start',
                    style: TextStyle(
                      fontSize: btnF,
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
