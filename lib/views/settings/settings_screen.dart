import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});


  Future<void> deleteFirebaseUser(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final success = await reauthenticateUser(context);
        if (success) {

          await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();


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
              child: Text('Cancel' , style: TextStyle(color: Color(0xFF562B56)),),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(password),
              child: Text('Delete', style: TextStyle(color: Color(0xFF562B56)),),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: 16,
              top: 16,
              right: 16,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Color(0xFF562B56)),
                    iconSize: 32,
                    onPressed: () {
                      context.go('/profile');
                    },
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Settings',
                    style: TextStyle(
                      color: Color(0xFF562B56),
                      fontSize: 40,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 105,
              left: 36,
              child: Text(
                'Account Settings',
                style: TextStyle(
                  color: Color(0xFF562B56),
                  fontSize: 25,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Positioned(
              top: 160,
              left: 16,
              right: 16,
              child: Column(
                children: [
                  _buildSettingRow(Icons.lock_outline, 'Change Password', context),
                  _buildSettingRow(Icons.key_outlined, 'Forgot Password', context),
                  _buildSettingRow(Icons.logout, 'Logout', context),
                  _buildSettingRow(Icons.delete_outline, 'Delete Account', context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingRow(IconData icon, String title, BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            leading: Icon(icon, color: Color(0xFF562B56)),
            title: Text(
              title,
              style: TextStyle(
                color: Color(0xFF562B56),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
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
          ),
          Container(
            height: 2,
            color: Colors.grey.shade300,
            margin: EdgeInsets.symmetric(horizontal: 16),
          ),
        ],
      ),
    );
  }


}
