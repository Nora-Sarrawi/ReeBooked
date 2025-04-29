import 'package:flutter/material.dart';
import 'package:rebooked_app/core/theme.dart';
import 'package:rebooked_app/widgets/primary_button.dart';

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
  String? _imagePath;

  void _saveBook() {
    if (_formKey.currentState?.validate() ?? false) {
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
              },
              child: const Text(
                'OK',
                style: TextStyle(color: AppColors.secondary),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Add Another',
                style: TextStyle(color: AppColors.secondary),
              ),
            ),
          ],
        ),
      );
    }
  }

  void _cancel() {
    Navigator.pop(context);
  }

  Future<void> _pickImage() async {
    setState(() {
      _imagePath = 'path/to/image.jpg';
    });
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: screenHeight * 0.02,
                      bottom: screenHeight * 0.02,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          color: AppColors.secondary,
                          onPressed: () {
                            Navigator.pop(context);
                          },
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
                  SizedBox(height: screenHeight * 0.02),
                  // Wrap the image in a Center widget to keep it centered
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
                        child: _imagePath == null
                            ? Center(
                                child: Text(
                                  'Pick an Image',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: AppColors.secondary,
                                  ),
                                ),
                              )
                            : Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                    _imagePath!,
                                    fit: BoxFit.cover,
                                  ),
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
                    mainAxisAlignment: MainAxisAlignment.center,
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
                    mainAxisAlignment: MainAxisAlignment.center,
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
}
