import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<void> deleteFirebaseUser(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final success = await reauthenticateUser(context);
        if (success) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .delete();

          await user.delete();

          await FirebaseAuth.instance.signOut();

          if (context.mounted) {
            context.go('/start');
          }
        }
      }
    } catch (e) {
      print('Error during deletion: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error during deletion: $e')),
        );
      }
    }
  }

  Future<bool> reauthenticateUser(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && user.email != null) {
      try {
        final password = await _promptForPassword(context);
        if (password == null) return false;

        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );

        await user.reauthenticateWithCredential(credential);
        return true;
      } catch (e) {
        print('Reauthentication error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Incorrect password.')),
        );
        return false;
      }
    }
    return false;
  }

  Future<String?> _promptForPassword(BuildContext context) async {
    String? password;
    return await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter your password'),
          content: TextField(
            obscureText: true,
            onChanged: (value) => password = value,
            decoration: InputDecoration(labelText: 'Password'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF562B56)),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(password),
              child: Text(
                'Delete',
                style: TextStyle(color: Color(0xFF562B56)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFDF7FF),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Decorative circles in the background
              Positioned(
                top: -100,
                right: -100,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF562B56).withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                bottom: -50,
                left: -50,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF562B56).withOpacity(0.05),
                  ),
                ),
              ),
              // Main content
              ListView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  SizedBox(height: 16),
                  // Header with back button
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon:
                              Icon(Icons.arrow_back, color: Color(0xFF562B56)),
                          iconSize: 32,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Text(
                        'Settings',
                        style: TextStyle(
                          color: Color(0xFF562B56),
                          fontSize: 40,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          shadows: [
                            Shadow(
                              color: Colors.grey.withOpacity(0.3),
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  // Profile preview card
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Color(0xFF562B56).withOpacity(0.1),
                          child: Text(
                            user?.email?.substring(0, 1).toUpperCase() ?? 'U',
                            style: TextStyle(
                              fontSize: 30,
                              color: Color(0xFF562B56),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          user?.email ?? 'User',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF562B56),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Account Settings',
                    style: TextStyle(
                      color: Color(0xFF562B56),
                      fontSize: 25,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Settings options
                  _buildSettingRow(
                      Icons.key_outlined, 'Forgot Password', context),
                  _buildSettingRow(Icons.logout, 'Logout', context),
                  _buildSettingRow(
                      Icons.delete_outline, 'Delete Account', context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingRow(IconData icon, String title, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (title == 'Delete Account') {
                deleteFirebaseUser(context);
              } else if (title == 'Forgot Password') {
                context.go('/forgot-password');
              } else if (title == 'Logout') {
                FirebaseAuth.instance.signOut();
                context.go('/login');
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFF562B56).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: Color(0xFF562B56)),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Color(0xFF562B56),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Color(0xFF562B56),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
