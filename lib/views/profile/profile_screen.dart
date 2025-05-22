import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

import 'package:rebooked_app/core/custom_text_field.dart';
import 'package:rebooked_app/core/theme.dart';
import 'package:rebooked_app/services/profile_service.dart';
import '../settings/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _emailController = TextEditingController();
  final _bioController = TextEditingController();

  bool _isEditingName = false;
  bool _isEditingLocation = false;
  bool _isEditingEmail = false;
  bool _isEditingBio = false;
  bool _isEditingImage = false;

  /// Opens gallery, uploads to Storage, writes URL into the profile doc.
  Future<void> _pickAndUploadAvatar(String uid) async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      final url = await ProfileService().uploadAvatar(uid, file);
      await ProfileService().update(uid, {'avatarUrl': url});
      setState(() => _isEditingImage = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnap) {
        if (!authSnap.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final uid = authSnap.data!.uid;

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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SettingsPage()),
                  );
                },
              ),
            ],
          ),
          body: StreamBuilder(
            stream: ProfileService().stream(uid),
            builder: (context, profileSnap) {
              if (!profileSnap.hasData || !profileSnap.data!.exists) {
                return const Center(child: CircularProgressIndicator());
              }
              final data = profileSnap.data!.data()!;

              // populate controllers
              _nameController.text = data['displayName'] ?? '';
              _locationController.text = data['location'] ?? '';
              _emailController.text = data['email'] ?? '';
              _bioController.text = data['bio'] ?? '';

              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildAvatar(data, uid),
                    const SizedBox(height: 30),
                    sectionTitle('Personal info'),
                    _editable(
                      'Full Name',
                      _nameController,
                      _isEditingName,
                      () async {
                        setState(() => _isEditingName = !_isEditingName);
                        if (!_isEditingName) {
                          await ProfileService().update(
                              uid, {'displayName': _nameController.text});
                        }
                      },
                    ),
                    _editable(
                      'Location',
                      _locationController,
                      _isEditingLocation,
                      () async {
                        setState(
                            () => _isEditingLocation = !_isEditingLocation);
                        if (!_isEditingLocation) {
                          await ProfileService().update(
                              uid, {'location': _locationController.text});
                        }
                      },
                    ),
                    _editable(
                      'Email Address',
                      _emailController,
                      _isEditingEmail,
                      () async {
                        setState(() => _isEditingEmail = !_isEditingEmail);
                        if (!_isEditingEmail) {
                          await ProfileService()
                              .update(uid, {'email': _emailController.text});
                        }
                      },
                    ),
                    sectionTitle('About you'),
                    _editableBio(
                      _bioController,
                      _isEditingBio,
                      () async {
                        setState(() => _isEditingBio = !_isEditingBio);
                        if (!_isEditingBio) {
                          await ProfileService()
                              .update(uid, {'bio': _bioController.text});
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget sectionTitle(String title) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(title,
              style: TextStyle(
                  color: AppColors.secondary,
                  fontSize: 24,
                  fontWeight: FontWeight.w700)),
        ),
      );

  Widget _editable(String label, TextEditingController c, bool editing,
          Future<void> Function() toggle) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(color: AppColors.secondary, width: 2),
          ),
          elevation: 2,
          color: AppColors.texe_field_background,
          child: ListTile(
            title: Text('$label:',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.secondary)),
            subtitle: editing
                ? CustomTextField(controller: c)
                : Text(c.text, style: TextStyle(color: AppColors.secondary)),
            trailing: IconButton(
              icon: Icon(Icons.edit, color: AppColors.secondary),
              onPressed: toggle,
            ),
          ),
        ),
      );

  Widget _editableBio(TextEditingController c, bool editing,
          Future<void> Function() toggle) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(color: AppColors.secondary, width: 2),
          ),
          elevation: 2,
          color: AppColors.texe_field_background,
          child: ListTile(
            title: Text('Bio:',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.secondary)),
            subtitle: editing
                ? CustomTextField(controller: c)
                : Text(c.text, style: TextStyle(color: AppColors.secondary)),
            trailing: IconButton(
              icon: Icon(Icons.edit, color: AppColors.secondary),
              onPressed: toggle,
            ),
          ),
        ),
      );

  Widget _buildAvatar(Map<String, dynamic> data, String uid) => Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.secondary, width: 2),
            ),
            child: ClipOval(
              child: _isEditingImage
                  ? GestureDetector(
                      onTap: () => setState(() => _isEditingImage = false),
                      child: Icon(Icons.camera_alt,
                          size: 40, color: AppColors.secondary),
                    )
                  : (data['avatarUrl'] != null &&
                          data['avatarUrl'].toString().isNotEmpty)
                      ? Image.network(data['avatarUrl'], fit: BoxFit.cover)
                      : Image.asset('assets/images/profile.png',
                          fit: BoxFit.cover),
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
                  // this is where we pick + upload
                  _pickAndUploadAvatar(uid);
                },
              ),
            ),
          ),
        ],
      );
}
