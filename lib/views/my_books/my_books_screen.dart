import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme.dart'; // Contains AppColors
import '../../core/constants.dart'; // Contains AppPadding

// ✅ Updated Book model with 'id'
class Book {
  final String id;
  final String coverUrl;
  final String title;
  final String author;

  Book({
    required this.id,
    required this.coverUrl,
    required this.title,
    required this.author,
  });

  factory Book.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Book(
      id: doc.id,
      coverUrl: data['coverUrl'] ?? '',
      title: data['title'] ?? '',
      author: data['author'] ?? '',
    );
  }
}

class MyBooksScreen extends StatefulWidget {
  const MyBooksScreen({super.key});

  @override
  _MyBooksScreenState createState() => _MyBooksScreenState();
}

class _MyBooksScreenState extends State<MyBooksScreen> {
  late Future<List<Book>> booksFuture;

  @override
  void initState() {
    super.initState();
    booksFuture = fetchBooksFromFirebase();
  }

  Future<List<Book>> fetchBooksFromFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final querySnapshot = await FirebaseFirestore.instance
        .collection('books')
        .where('ownerId', isEqualTo: user.uid)
        .get();

    return querySnapshot.docs.map((doc) => Book.fromDocument(doc)).toList();
  }

  Future<void> deleteBook(String bookId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You must be logged in to delete books'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // First verify that the book belongs to the current user
      final bookDoc = await FirebaseFirestore.instance
          .collection('books')
          .doc(bookId)
          .get();

      if (!bookDoc.exists) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Book not found'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      final bookData = bookDoc.data() as Map<String, dynamic>;

      // Check if ownerId exists in the document
      if (!bookData.containsKey('ownerId')) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'This book has no owner information and cannot be deleted'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      if (bookData['ownerId'] != user.uid) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You do not have permission to delete this book'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // If all checks pass, proceed with deletion
      await FirebaseFirestore.instance.collection('books').doc(bookId).delete();

      // Refresh the books list
      setState(() {
        booksFuture = fetchBooksFromFirebase();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Book deleted successfully'),
            backgroundColor: Color(0xFFC76767),
          ),
        );
      }
    } on FirebaseException catch (e) {
      print('Firebase error deleting book: $e'); // For debugging
      if (mounted) {
        String errorMessage = 'Failed to delete book';
        if (e.code == 'permission-denied') {
          errorMessage =
              'You do not have permission to delete this book. Please ensure you are the owner.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error deleting book: $e'); // For debugging
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete book: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<bool> showDeleteConfirmationDialog(Book book) async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                'Delete Book',
                style: TextStyle(
                  color: Color(0xFFC76767),
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Are you sure you want to delete this book?'),
                  const SizedBox(height: 20),
                  Container(
                    width: 100,
                    height: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        book.coverUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 100),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    book.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    book.author,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFC76767),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double logoW = size.width * 0.5;
    final double logoH = logoW * 0.5;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: AppPadding.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(
                logoW: logoW,
                logoH: logoH,
                onSearch: (query) {
                  // Handle search
                },
              ),
              const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<Book>>(
                  future: booksFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                      return _EmptyBooksWidget();
                    } else if (snapshot.hasData) {
                      return GridView.builder(
                        itemCount: snapshot.data!.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                        itemBuilder: (context, index) {
                          final book = snapshot.data![index];
                          return _BookCard(
                            book: book,
                            onPressed: () {
                              context.pushNamed(
                                'bookDetails',
                                pathParameters: {'bookId': book.id},
                              );
                            },
                            onDelete: () async {
                              final shouldDelete =
                                  await showDeleteConfirmationDialog(book);
                              if (shouldDelete) {
                                await deleteBook(book.id);
                              }
                            },
                          );
                        },
                      );
                    } else {
                      return const Center(child: Text('No books found.'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFC76767),
        child: const Icon(Icons.add, size: 32, color: Colors.white),
        onPressed: () {
          // Handle add book action
        },
        shape: const CircleBorder(),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.logoW,
    required this.logoH,
    required this.onSearch,
  });

  final double logoW, logoH;
  final Function(String) onSearch;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const Expanded(
              child: Center(
                child: Text(
                  'My Books',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 180),
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          onSubmitted: onSearch,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintText: 'Search books, authors…',
            hintStyle: const TextStyle(color: Colors.white70),
            prefixIcon: const Icon(Icons.search, color: Colors.white70),
            filled: true,
            fillColor: AppColors.primary,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(60),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(60),
              borderSide: BorderSide(color: AppColors.accent, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}

class _BookCard extends StatefulWidget {
  const _BookCard({
    required this.book,
    required this.onPressed,
    required this.onDelete,
    super.key,
  });

  final Book book;
  final VoidCallback onPressed;
  final VoidCallback onDelete;

  @override
  State<_BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<_BookCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isLongPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleLongPressStart() {
    setState(() => _isLongPressed = true);
    _controller.forward();
  }

  void _handleLongPressEnd() {
    setState(() => _isLongPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) => _handleLongPressStart(),
      onLongPressEnd: (_) {
        _handleLongPressEnd();
        widget.onDelete();
      },
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.beige,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _isLongPressed
                        ? Colors.red.withOpacity(0.3)
                        : Colors.black12,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: widget.onPressed,
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Hero(
                                tag: 'book-${widget.book.id}',
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    widget.book.coverUrl,
                                    height: 120,
                                    width: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(Icons.broken_image,
                                                size: 100),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              widget.book.title,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.book.author,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (_isLongPressed)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _EmptyBooksWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "You don't have any books yet.",
        style: TextStyle(
          color: Color(0xFF562B56),
          fontSize: 18,
          fontFamily: 'Outfit',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
