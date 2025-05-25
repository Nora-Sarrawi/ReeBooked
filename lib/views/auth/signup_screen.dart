import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/services/auth_service.dart';

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

  void _signUp() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }
    if (_passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters')),
      );
      return;
    }
    if (!_emailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid email')),
      );
      return;
    }

    try {
      await AuthService().signUpWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created! Please sign in.")),
      );
      Navigator.pop(context); // Go back to login screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign up failed: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: const Color(0xFF562B56),
          onPressed: () => Navigator.pop(context),
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
            _buildLabel("Name"),
            _buildTextField(_nameController, "ex: jon smith"),
            const SizedBox(height: 20.0),
            _buildLabel("Email"),
            _buildTextField(_emailController, "ex: jon.smith@email.com"),
            const SizedBox(height: 20.0),
            _buildLabel("Password"),
            _buildTextField(_passwordController, "*********", obscure: true),
            const SizedBox(height: 20.0),
            _buildLabel("Confirm password"),
            _buildTextField(_confirmPasswordController, "*********",
                obscure: true),
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
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'I understood the ',
                          style: TextStyle(
                            color: Color(0xFF562B56),
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: 'terms & policy',
                          style: const TextStyle(
                            color: Color(0xFFCDA2F2),
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const TextSpan(
                          text: '.',
                          style: TextStyle(
                            color: Color(0xFF562B56),
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _termsAgreed ? _signUp : null,
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
                    child: Divider(color: Color(0xFF888888), thickness: 0.8)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'or sign up with',
                    style: TextStyle(
                      color: Color(0xFF562B56),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Expanded(
                    child: Divider(color: Color(0xFF888888), thickness: 0.8)),
              ],
            ),
            const SizedBox(height: 10.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Handle Google sign up
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    side:
                        const BorderSide(color: Color(0xFF888888), width: 0.5),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/images/google.jpg', height: 24.0),
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
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    context.go('/login');
                  },
                  child: const Text(
                    'Sign in',
                    style: TextStyle(
                      color: Color(0xFF562B56),
                      fontSize: 16,
                      fontFamily: 'Poppins',
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF562B56),
        fontSize: 16,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
        height: 1.95,
        letterSpacing: 0.32,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {bool obscure = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFF888888),
          fontSize: 15,
          fontFamily: 'Poppins',
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(color: Color(0xFF562B56), width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(color: Color(0xFF562B56), width: 2.0),
        ),
        filled: true,
        fillColor: const Color(0xFFF2E9DC),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      ),
    );
  }
}
