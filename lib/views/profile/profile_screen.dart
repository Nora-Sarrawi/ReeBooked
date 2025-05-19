import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rebooked_app/core/theme.dart';

import '../settings/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _nameController = TextEditingController(text: 'Masa Jaara');
  TextEditingController _locationController = TextEditingController(text: 'Palestine, Nablus');
  TextEditingController _emailController = TextEditingController(text: 'wewewewewe@gmail.com');
  TextEditingController _bioController = TextEditingController(text: 'wewewwewewew 😊,\nwewewwewewewwweweeeeeeeeeeeewwwwwww🌱.');

  bool _isEditingName = false;
  bool _isEditingLocation = false;
  bool _isEditingEmail = false;
  bool _isEditingBio = false;
  bool _isEditingImage = false; // Flag to toggle image edit mode

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

            onPressed: () {Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsPage()),
    );},

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
                    child: _isEditingImage
                        ? GestureDetector(
                      onTap: () {
                        setState(() {
                          _isEditingImage = !_isEditingImage; // toggle between edit and view mode
                        });
                      },
                      child: Icon(
                        Icons.camera_alt,
                        size: 40,
                        color: AppColors.secondary,
                      ),
                    )
                        : Image.asset(
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
                    child: IconButton(
                      icon: Icon(Icons.edit, size: 16, color: AppColors.accent),
                      onPressed: () {
                        setState(() {
                          _isEditingImage = !_isEditingImage; // toggle between edit and view mode
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            sectionTitle('Personal info'),
            _buildEditableCard('Full Name', _nameController, _isEditingName, () {
              setState(() {
                _isEditingName = !_isEditingName;
              });
            }),
            _buildEditableCard('Location', _locationController, _isEditingLocation, () {
              setState(() {
                _isEditingLocation = !_isEditingLocation;
              });
            }),
            _buildEditableCard('Email Address', _emailController, _isEditingEmail, () {
              setState(() {
                _isEditingEmail = !_isEditingEmail;
              });
            }),
            sectionTitle('About you'),
            _buildEditableBioCard(_bioController, _isEditingBio, () {
              setState(() {
                _isEditingBio = !_isEditingBio;
              });
            }),
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

  // Editable info card
  Widget _buildEditableCard(String label, TextEditingController controller, bool isEditing, Function() toggleEditing) {
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
          subtitle: isEditing
              ? CustomTextField(controller: controller)
              : Text(
            controller.text,
            style: TextStyle(color: AppColors.secondary),
          ),
          trailing: IconButton(
            icon: Icon(Icons.edit, color: AppColors.secondary),
            onPressed: toggleEditing,
          ),
        ),
      ),
    );
  }

  // Editable bio card
  Widget _buildEditableBioCard(TextEditingController controller, bool isEditing, Function() toggleEditing) {
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
          subtitle: isEditing
              ? CustomTextField(controller: controller)
              : Text(
            controller.text,
            style: TextStyle(color: AppColors.secondary),
          ),
          trailing: IconButton(
            icon: Icon(Icons.edit, color: AppColors.secondary),
            onPressed: toggleEditing,
          ),
        ),
      ),
    );
  }
}
