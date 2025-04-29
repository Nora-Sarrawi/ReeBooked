import 'package:flutter/material.dart';
import 'package:rebooked_app/core/theme.dart';
import '../widgets/primary_button.dart';

class ConfirmSwapPage extends StatefulWidget {
  const ConfirmSwapPage({super.key});

  static const List<String> books = [
    'Book 1',
    'Book 2',
    'Book 3',
    'Book 4'
  ];

  @override
  State<ConfirmSwapPage> createState() => _ConfirmSwapPageState();
}

class _ConfirmSwapPageState extends State<ConfirmSwapPage> {
  String? selectedBook;

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 60),
                SizedBox(height: 16),
                Text(
                  'The request has been sent successfully',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.secondary),
                ),
                SizedBox(height: 24),
                PrimaryButton(
                  text: 'Thanks',
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06, vertical: screenHeight * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                color: AppColors.beige,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.03, horizontal: screenWidth * 0.04),
                  child: Center(
                    child: Text(
                      'Confirm your swap request!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              DropdownButtonHideUnderline(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: DropdownButton<String>(
                    value: selectedBook,
                    hint: Text(
                      'Choose your book',
                      style: TextStyle(color: Colors.white),
                    ),
                    dropdownColor: AppColors.primary,
                    iconEnabledColor: Colors.white,
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(25), // يغير شكل الليست
                    items: ConfirmSwapPage.books.map((String book) {
                      return DropdownMenuItem<String>(
                        value: book,
                        child: Text(
                          book,
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedBook = value;
                      });
                    },
                  ),
                ),
              ),

              if (selectedBook != null) ...[
                SizedBox(height: 12),
                Text(
                  'Selected book: $selectedBook',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.secondary,
                  ),
                ),
              ],
              SizedBox(height: screenHeight * 0.04),
              Container(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08, vertical: screenHeight * 0.04),
                decoration: BoxDecoration(
                  color: AppColors.beige,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.black.withOpacity(0.1)),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(5, 5)),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'You are requesting to swap your book with OCEAN DOOR',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/book3.jpg',
                        width: screenWidth * 0.5,
                        height: screenHeight * 0.2,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: screenHeight * 0.06,
                            child: ElevatedButton(
                              onPressed: () {
                                showSuccessDialog(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'Send request',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.04),
                        Expanded(
                          child: SizedBox(
                            height: screenHeight * 0.06,
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                backgroundColor: AppColors.gray,
                                side: const BorderSide(color: Color(0xFFD1D1D6)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFF5F5F5),
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
            ],
          ),
        ),
      ),
    );
  }
}
