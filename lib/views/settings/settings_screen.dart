import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Top bar with back arrow and Settings title
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
                    onPressed: () {},
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

            // Account Settings title
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

            // List of settings
            Positioned(
              top: 160,
              left: 16,
              right: 16,
              child: Column(
                children: [
                  _buildSettingRow(
                      Icons.lock_outline, 'Change Password', context),
                  _buildSettingRow(
                      Icons.key_outlined, 'Forgot Password', context),
                  _buildSettingRow(Icons.logout, 'Logout', context),
                  _buildSettingRow(
                      Icons.delete_outline, 'Delete Account', context),
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
                _showDeleteConfirmation(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$title tapped')),
                );
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

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  width: 1,
                  color: Colors.black.withOpacity(0.1),
                ),
              ),
              shadows: [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 20,
                  offset: Offset(20, 20),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Are you sure you want to delete your account?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF562B56),
                    fontSize: 24,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 20),
                Opacity(
                  opacity: 0.56,
                  child: Text(
                    'This action cannot be undone.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF562B56),
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  children: [
                    // Delete button
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Account deleted")),
                          );
                          // Add deletion logic here
                        },
                        child: Container(
                          height: 48,
                          decoration: ShapeDecoration(
                            color: Color(0xFFCDA2F2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: BorderSide(color: Color(0xFFCDA2F2)),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Delete',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    // Cancel button
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          height: 48,
                          decoration: ShapeDecoration(
                            color: Color(0xFF562B56),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: BorderSide(color: Color(0xFF562B56)),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Color(0xFFF5F5F5),
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
