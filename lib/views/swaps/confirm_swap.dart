import 'package:flutter/material.dart';
import 'package:rebooked_app/core/theme.dart';
import 'package:rebooked_app/widgets/primary_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class Book {
  final String id;
  final String title;
  final String coverUrl;

  Book({
    required this.id,
    required this.title,
    required this.coverUrl,
  });

  factory Book.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Book(
      id: doc.id,
      title: data['title'] ?? 'Untitled',
      coverUrl: data['coverUrl'] ?? '',
    );
  }
}

class ConfirmSwapPage extends StatefulWidget {
  final Map<String, dynamic>? bookDetails;

  const ConfirmSwapPage({
    super.key,
    this.bookDetails,
  });

  @override
  State<ConfirmSwapPage> createState() => _ConfirmSwapPageState();
}

class _ConfirmSwapPageState extends State<ConfirmSwapPage> {
  Book? selectedBook;
  List<Book> userBooks = [];
  late final String targetBookTitle;
  late final String targetBookCover;
  late final String targetBookId;
  late final String targetOwnerId;

  @override
  void initState() {
    super.initState();
    print('Book Details received: ${widget.bookDetails}');
    targetBookTitle = widget.bookDetails?['bookTitle'] ?? 'Select a Book';
    targetBookCover = widget.bookDetails?['bookCover'] ??
        'assets/images/book_placeholder.jpg';
    targetBookId = widget.bookDetails?['bookId'] ?? '';
    targetOwnerId = widget.bookDetails?['ownerId'] ?? '';
    print('Target Owner ID: $targetOwnerId');
    _fetchUserBooks();
  }

  Future<void> _fetchUserBooks() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final querySnapshot = await FirebaseFirestore.instance
        .collection('books')
        .where('ownerId', isEqualTo: user.uid)
        .where('status', isEqualTo: 'available')
        .get();

    setState(() {
      userBooks =
          querySnapshot.docs.map((doc) => Book.fromFirestore(doc)).toList();
    });
  }

  Future<void> sendSwapRequest() async {
    if (selectedBook == null) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    print('DEBUG - Current user info:');
    print('User ID: ${user.uid}');
    print('Display Name: ${user.displayName}');
    print('Photo URL: ${user.photoURL}');
    print('Target Owner ID: $targetOwnerId');

    if (targetOwnerId.isEmpty) {
      print('Error: Owner ID is empty!');
      return;
    }

    // Check if the current user is the owner
    final isOwner = user.uid == targetOwnerId;
    String recipientId;
    if (isOwner) {
      recipientId = widget.bookDetails?['borrowerId'] ?? '';
    } else {
      recipientId = targetOwnerId;
    }

    String notificationText;
    String status;

    if (isOwner) {
      if (selectedBook!.title == 'Accept') {
        notificationText = "Your swap request has been accepted";
        status = 'accepted';
      } else {
        notificationText = "Your swap request has been declined";
        status = 'declined';
      }
    } else {
      notificationText =
          "I'd like to swap my '${selectedBook!.title}' for your '$targetBookTitle'";
      status = 'pending';
    }

    String borrowerId;
    if (isOwner) {
      borrowerId = widget.bookDetails?['borrowerId'] ?? '';
    } else {
      borrowerId = user.uid;
    }

    final swapData = {
      'name': targetBookTitle,
      'imagePath': targetBookCover,
      'requestMessage':
          "I'd like to swap my '${selectedBook!.title}' for your '$targetBookTitle'",
      'status': 'pending',
      'borrowerId': user.uid,
      'borrowerBookId': selectedBook!.id,
      'ownerBookId': targetBookId,
      'ownerId': targetOwnerId,
      'timestamp': FieldValue.serverTimestamp(),
    };

    print('DEBUG - Swap Data to be created:');
    print(swapData);

    try {
      DocumentReference swapDoc;
      if (isOwner) {
        // Update existing swap
        swapDoc = FirebaseFirestore.instance
            .collection('swaps')
            .doc(widget.bookDetails?['swapId']);
        await swapDoc.update({
          'status': status,
          'requestMessage': notificationText,
        });
        print('DEBUG - Swap updated with ID: ${swapDoc.id}');
      } else {
        // Create new swap request
        swapDoc =
            await FirebaseFirestore.instance.collection('swaps').add(swapData);
        print('DEBUG - New swap created with ID: ${swapDoc.id}');
      }

      // Create notification for the recipient
      print('DEBUG - Creating notification with:');
      print('Swap ID: ${swapDoc.id}');
      print('Sender ID: ${user.uid}');
      print('Sender Name: ${user.displayName ?? 'Unknown User'}');
      print('Sender Avatar: ${user.photoURL ?? ''}');
      print('Recipient ID: $recipientId');
      print('Text: $notificationText');

      // Notification creation code removed as per the instructions
    } catch (e) {
      print('DEBUG - Error details:');
      print(e);
      return;
    }
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.secondary,
                  ),
                ),
                SizedBox(height: 24),
                PrimaryButton(
                  text: 'Thanks',
                  onPressed: () {
                    Navigator.of(context).pop(); // close dialog
                    context
                        .go('/book/$targetBookId'); // navigate to book details
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
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.06, vertical: screenHeight * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: AppColors.beige,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.03,
                      horizontal: screenWidth * 0.04),
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
                  child: DropdownButton<Book>(
                    value: selectedBook,
                    hint: Text(
                      'Choose your book',
                      style: TextStyle(color: Colors.white),
                    ),
                    dropdownColor: AppColors.primary,
                    iconEnabledColor: Colors.white,
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(25),
                    items: userBooks.map((Book book) {
                      return DropdownMenuItem<Book>(
                        value: book,
                        child: Text(
                          book.title,
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                    onChanged: (Book? value) {
                      setState(() {
                        selectedBook = value;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.08,
                    vertical: screenHeight * 0.04),
                decoration: BoxDecoration(
                  color: AppColors.beige,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.black.withOpacity(0.1)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20,
                        offset: Offset(5, 5)),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'You are requesting to swap your book with $targetBookTitle',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (selectedBook != null)
                          Expanded(
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    selectedBook!.coverUrl,
                                    width: screenWidth * 0.35,
                                    height: screenHeight * 0.2,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      width: screenWidth * 0.35,
                                      height: screenHeight * 0.2,
                                      color: Colors.grey[300],
                                      child: Icon(Icons.book, size: 50),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Your Book',
                                  style: TextStyle(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (selectedBook != null)
                          Icon(Icons.swap_horiz, size: 40),
                        Expanded(
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: targetBookCover.startsWith('http')
                                    ? Image.network(
                                        targetBookCover,
                                        width: screenWidth * 0.35,
                                        height: screenHeight * 0.2,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                          width: screenWidth * 0.35,
                                          height: screenHeight * 0.2,
                                          color: Colors.grey[300],
                                          child: Icon(Icons.book, size: 50),
                                        ),
                                      )
                                    : Image.asset(
                                        targetBookCover,
                                        width: screenWidth * 0.35,
                                        height: screenHeight * 0.2,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                targetBookTitle,
                                style: TextStyle(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: screenHeight * 0.06,
                            child: ElevatedButton(
                              onPressed: selectedBook == null
                                  ? null
                                  : () async {
                                      await sendSwapRequest();
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
                                      color: Colors.white),
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
                              onPressed: () {
                                context.go('/book/$targetBookId');
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: AppColors.gray,
                                side:
                                    const BorderSide(color: Color(0xFFD1D1D6)),
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
