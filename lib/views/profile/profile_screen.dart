import 'package:flutter/material.dart';
import 'package:rebooked_app/core/theme.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Your Profile',
          style: TextStyle(
            color: AppColors.secondary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: AppColors.secondary),
            onPressed: () {},
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.secondary,
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/profile.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),

                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.secondary,
                    child: Icon(Icons.edit, size: 16, color: AppColors.accent),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            sectionTitle('Personal info'),
            infoCard('Full Name', 'Masa Jaara'),
            infoCard('Location', 'Palestine, Nablus'),
            infoCard('Email Address', 'wewewewewe@gmail.com'),
            sectionTitle('About you'),
            bioCard('wewewwewewew 😊,\nwewewwewewewwweweeeeeeeeeeeewwwwwww🌱.'),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            color: AppColors.secondary,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget infoCard(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: BorderSide(color: AppColors.secondary, width: 2),
        ),
        elevation: 2,
        color: AppColors.texe_field_background,
        child: ListTile(
          title: Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
            ),
          ),
          subtitle: Text(
            value,
            style: TextStyle(
              color: AppColors.secondary,
            ),
          ),
          trailing: Icon(Icons.edit, color: AppColors.secondary),
        ),
      ),
    );
  }

  Widget bioCard(String bio) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: BorderSide(color: AppColors.secondary, width: 2),
        ),
        elevation: 2,
        color: AppColors.texe_field_background,
        child: ListTile(
          title: Text(
            'Bio:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              bio,
              style: TextStyle(
                color: AppColors.secondary,
              ),
            ),
          ),
          trailing: Icon(Icons.edit, color: AppColors.secondary),
        ),
      ),
    );
  }
}
