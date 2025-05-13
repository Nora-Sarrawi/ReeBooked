import 'package:flutter/material.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _termsAgreed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: const Color(0xFF562B56),
          onPressed: () {
            // Handle back button action
          },
        ),
      ),
      backgroundColor: const Color(0xFFF2E9DC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20.0),
            const Text(
              'Create your account',
              style: TextStyle(
                color: Color(0xFF562B56),
                fontSize: 26.72,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                height: 1.3,
                letterSpacing: 0.53,
              ),
            ),
            const SizedBox(height: 25.0),
            const Text(
              'Name',
              style: TextStyle(
                color: Color(0xFF562B56),
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                height: 1.95,
                letterSpacing: 0.32,
              ),
            ),
            const SizedBox(height: 4.0,),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'ex: jon smith',
                hintStyle: const TextStyle(
                  color: Color(0xFF888888),
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                  letterSpacing: 0.30,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(
                    color: Color(0xFF562B56),
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(
                    color: Color(0xFF562B56),
                    width: 2.0,
                  ),
                ),
                filled: true,
                fillColor: Color(0xFFF2E9DC),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Email',
              style: TextStyle(
                color: Color(0xFF562B56),
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                height: 1.95,
                letterSpacing: 0.32,
              ),
            ),
            const SizedBox(height: 4.0),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'ex: jon.smith@email.com',
                hintStyle: const TextStyle(
                  color: Color(0xFF888888),
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                  letterSpacing: 0.30,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(
                    color: Color(0xFF562B56),
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(
                    color: Color(0xFF562B56),
                    width: 2.0,
                  ),
                ),
                filled: true,
                fillColor: Color(0xFFF2E9DC),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              ),
            ),

            const SizedBox(height: 20.0),
            const Text(
              'Password',
              style: TextStyle(
                color: Color(0xFF562B56),
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                height: 1.95,
                letterSpacing: 0.32,
              ),
            ),
            const SizedBox(height: 4.0),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: '*********',
                hintStyle: const TextStyle(
                  color: Color(0xFF888888),
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                  letterSpacing: 0.30,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(
                    color: Color(0xFF562B56),
                    width: 2.3,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(
                    color: Color(0xFF562B56),
                    width: 2.0,
                  ),
                ),
                filled: true,
                fillColor: Color(0xFFF2E9DC),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              ),
            ),

            const SizedBox(height: 20.0),
            const Text(
              'Confirm password',
              style: TextStyle(
                color: Color(0xFF562B56),
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                height: 1.95,
                letterSpacing: 0.32,
              ),
            ),
            const SizedBox(height: 4.0),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: '*********',
                hintStyle: const TextStyle(
                  color: Color(0xFF888888),
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                  letterSpacing: 0.30,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(
                    color: Color(0xFF562B56),
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(
                    color: Color(0xFF562B56),
                    width: 2.0,
                  ),
                ),
                filled: true,
                fillColor: Color(0xFFF2E9DC),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              ),
            ),

            const SizedBox(height: 5.0),
            Row(
              children: <Widget>[
                Checkbox(
                  value: _termsAgreed,
                  onChanged: (bool? value) {
                    setState(() {
                      _termsAgreed = value!;
                    });
                  },
                  activeColor: const Color(0xFF562B56),
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'I understood the ',
                        style: TextStyle(
                          color: Color(0xFF562B56),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          height: 2.07,
                        ),
                      ),
                      TextSpan(
                        text: 'terms & policy',
                        style: const TextStyle(
                          color: Color(0xFFCDA2F2),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          height: 2.07,
                        ),
                      ),
                      const TextSpan(
                        text: '.',
                        style: TextStyle(
                          color: Color(0xFF562B56),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          height: 2.07,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _termsAgreed ? () {
                  // Handle sign up logic
                  print('Sign Up button pressed');
                  print('Name: ${_nameController.text}');
                  print('Email: ${_emailController.text}');
                  print('Password: ${_passwordController.text}');
                  print('Confirm Password: ${_confirmPasswordController.text}');
                  if (_passwordController.text != _confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Passwords do not match')),
                    );
                  } else if (_passwordController.text.length < 6) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Password must be at least 6 characters')),
                    );
                  } else {
                    // Proceed with account creation
                  }
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC76767),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                child: const Text(
                  'SIGN UP',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFF2E9DC),
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    height: 1.7,
                    letterSpacing: 0.30,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Divider(
                    color: Color(0xFF888888),
                    thickness: 0.8,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'or sign up with',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF562B56),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 1.95,
                      letterSpacing: 0.32,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Color(0xFF888888),
                    thickness: 0.8,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle Google sign up
                  text:'Sign up with Google';
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    side: const BorderSide(color: Color(0xFF888888), width: 0.5),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/google.jpg', // Replace with your actual asset path
                      height: 24.0,
                    ),
                    const SizedBox(width: 10.0),
                    const Text(
                      'Sign up with Google',
                      style: TextStyle(
                        color: Color(0xFF562B56),
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 1.7,
                        letterSpacing: 0.30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Already have an account? ',
                  style: TextStyle(
                    color: Color(0xFF888888),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 1.95,
                    letterSpacing: 0.32,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Handle sign in navigation
                    print('Sign in tapped');
                  },
                  child: const Text(
                    'Sign in',
                    style: TextStyle(
                      color: Color(0xFF562B56),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 1.95,
                      letterSpacing: 0.32,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }
}