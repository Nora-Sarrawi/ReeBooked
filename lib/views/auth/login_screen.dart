import 'package:flutter/material.dart';




class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    final username = _usernameController.text;
    final password = _passwordController.text;

    // Example login logic (replace with actual)
    if (username == 'admin' && password == 'admin') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid username or password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2E9DC),
      body: Center(
        child: Container(
          width: 414,
          height: 874,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: const Color(0xFFF2E9DC),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(44),
            ),
          ),
          child: Stack(

            children: [
              // Logo/Image
              // Logo using local asset
              Positioned(
                left: 109,
                top: 158,
                child: Container(
                  width: 197,
                  height: 197,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/logo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 154,
                top: 308,
                child: SizedBox(
                  width: 105,
                  height: 19,
                  child: Text(
                    'ReBooked',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 60,
                top: 428,
                child: SizedBox(
                  width: 298,
                  height: 40,
                  child: Text(
                    'Sign in your account',
                    style: TextStyle(
                      color: const Color(0xFF562B56),
                      fontSize: 30,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              // Username Field
              Positioned(
                left: 32,
                top: 482,
                child: Container(
                  width: 350,
                  height: 45,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 2,
                        color: const Color(0xFF562B56),
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Username',
                      hintStyle: TextStyle(
                        color: Color(0xFF562B56),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    style: const TextStyle(
                      color: Color(0xFF562B56),
                    ),
                  ),
                ),
              ),
              // Password Field
              Positioned(
                left: 32,
                top: 540,
                child: Container(
                  width: 350,
                  height: 45,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 2,
                        color: const Color(0xFF562B56),
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter your password',
                      hintStyle: TextStyle(
                        color: Color(0xFF562B56),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    style: const TextStyle(
                      color: Color(0xFF562B56),
                    ),
                  ),
                ),
              ),
              // Login Button
              // Login Button
              Positioned(
                left: 32, // Align with username and password
                top: 610,
                child: SizedBox(
                  width: 350, // Match the width of input fields
                  height: 45,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF562B56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Login now',
                      style: TextStyle(
                        color: Color(0xFFF2E9DC),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              // Forgot Password
              Positioned(
                left: 116,
                top: 658,
                child: SizedBox(
                  width: 181,
                  height: 32,
                  child: TextButton(
                    onPressed: () {
                      // Navigate to reset page
                    },
                    child: const Text(
                      'Forgot your password?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF562B56),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              // Create account
              Positioned(
                left: 79,
                top: 815,
                child: SizedBox(
                  width: 267,
                  height: 47,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Not registered? ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: 'Create an account',
                          style: const TextStyle(
                            color: Color(0xFF562B56),
                            fontSize: 15,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                          recognizer: null, // Add TapGestureRecognizer if needed
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}