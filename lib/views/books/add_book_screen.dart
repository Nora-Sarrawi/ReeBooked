import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'package:rebooked_app/core/theme.dart';
import 'package:rebooked_app/widgets/primary_button.dart';
import 'package:rebooked_app/services/storage_service.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _publishYearController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  final _picker = ImagePicker();
  final _storage = StorageService();
  File? _pickedImageFile;

  String? _selectedLocation;
  String? _selectedGenre;

  final List<String> _locations = [
    'Jerusalem', 'Ramallah', 'Nablus', 'Bethlehem', 'Hebron', 'Jenin'
  ];

  final List<String> _genres = [
    'Storytelling', 'Truth', 'Imagination', 'Wisdom', 'Growth'
  ];

Future<void> _pickImage() async {
  final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    final file = File(pickedFile.path);
    final extension = pickedFile.name.split('.').last.toLowerCase();
    final allowedExtensions = ['jpg', 'jpeg', 'png'];

    if (!allowedExtensions.contains(extension)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Only JPG, JPEG, or PNG files are allowed.'),
        ),
      );
      return;
    }

    setState(() {
      _pickedImageFile = file;
    });
  }
}


  Future<void> _saveBook() async {
    if (!_formKey.currentState!.validate()) return;
    if (_pickedImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please pick an image")),
      );
      return;
    }

    try {
      final newBookRef = FirebaseFirestore.instance.collection('books').doc();

      final coverUrl = await _storage.uploadFile(
        _pickedImageFile!,
        'book_covers/${FirebaseAuth.instance.currentUser!.uid}/${newBookRef.id}.jpg',
      );

      await newBookRef.set({
        'title': _titleController.text.trim(),
        'author': _authorController.text.trim(),
        'coverUrl': coverUrl,
        'ownerId': FirebaseAuth.instance.currentUser!.uid,
        'status': 'available',
        'createdAt': FieldValue.serverTimestamp(),
        'publishYear': _publishYearController.text.trim(),
        'description': _descriptionController.text.trim(),
        'notes': _notesController.text.trim(),
        'location': _selectedLocation,
        'genre': _selectedGenre,
      });

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text(
            'Book added!',
            style: TextStyle(color: AppColors.secondary),
          ),
          content: const Text(
            'The book has been successfully added.',
            style: TextStyle(color: AppColors.secondary),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.go('/home');
              },
              child: const Text('OK', style: TextStyle(color: AppColors.secondary)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _formKey.currentState?.reset();
                setState(() {
                  _pickedImageFile = null;
                  _selectedLocation = null;
                  _selectedGenre = null;
                });
              },
              child: const Text('Add Another', style: TextStyle(color: AppColors.secondary)),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _cancel() {
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.06,
              vertical: screenHeight * 0.02,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: screenHeight * 0.02,
                      bottom: screenHeight * 0.02,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          color: AppColors.secondary,
                          onPressed: _cancel,
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Text(
                          'Add Book',
                          style: theme.textTheme.headlineLarge?.copyWith(
                            color: AppColors.secondary,
                            fontSize: screenWidth > 600 ? 25 : 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Center(
                      child: Container(
                        width: screenWidth * 0.8,
                        height: screenWidth * 0.6,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: _pickedImageFile == null
                            ? Center(
                                child: Text(
                                  'Pick an Image',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: AppColors.secondary,
                                  ),
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.file(
                                  _pickedImageFile!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  _buildLabeledTextField(
                    label: 'Book Name',
                    controller: _titleController,
                    theme: theme,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Row(
                    children: [
                      Expanded(
                        child: _buildLabeledTextField(
                          label: 'Author',
                          controller: _authorController,
                          theme: theme,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Expanded(
                        child: _buildLabeledTextField(
                          label: 'Publish Year',
                          controller: _publishYearController,
                          theme: theme,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  _buildDropdownField(
                    label: 'Location',
                    value: _selectedLocation,
                    items: _locations,
                    onChanged: (val) => setState(() => _selectedLocation = val),
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                    theme: theme,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  _buildDropdownField(
                    label: 'Genre',
                    value: _selectedGenre,
                    items: _genres,
                    onChanged: (val) => setState(() => _selectedGenre = val),
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                    theme: theme,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  _buildLabeledTextField(
                    label: 'Description',
                    controller: _descriptionController,
                    theme: theme,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    isRequired: false,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  _buildLabeledTextField(
                    label: 'Notes',
                    controller: _notesController,
                    theme: theme,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    isRequired: false,
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          text: 'Add Book',
                          color: AppColors.secondary,
                          onPressed: _saveBook,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Expanded(
                        child: PrimaryButton(
                          text: 'Cancel',
                          color: AppColors.accent,
                          onPressed: _cancel,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledTextField({
    required String label,
    required TextEditingController controller,
    required ThemeData theme,
    required double screenWidth,
    required double screenHeight,
    TextInputType keyboardType = TextInputType.text,
    bool isRequired = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            color: AppColors.secondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          cursorColor: AppColors.secondary,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.secondary,
          ),
          decoration: InputDecoration(
            hintText: label,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.secondary.withOpacity(0.6),
            ),
            filled: true,
            fillColor: AppColors.texe_field_background,
            contentPadding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.06,
              vertical: screenHeight * 0.02,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                color: AppColors.secondary,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                color: AppColors.secondary,
                width: 2,
              ),
            ),
          ),
          validator: (value) {
            if (isRequired && (value == null || value.isEmpty)) {
              return 'Please fill this field';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    required double screenHeight,
    required double screenWidth,
    required ThemeData theme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            color: AppColors.secondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        DropdownButtonFormField<String>(
          value: value,
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.texe_field_background,
            contentPadding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.06,
              vertical: screenHeight * 0.02,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: AppColors.secondary, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: AppColors.secondary, width: 2),
            ),
          ),
          validator: (value) => value == null ? 'Please select $label' : null,
        ),
      ],
    );
  }
}
