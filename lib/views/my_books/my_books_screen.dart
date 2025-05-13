import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme.dart'; // AppColors, appTheme
import '../../core/constants.dart'; // AppPadding

class Book {
  final String coverPath;
  final String title;
  final String author;

  Book({required this.coverPath, required this.title, required this.author});
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
    booksFuture = fetchBooks();
  }

  Future<List<Book>> fetchBooks() async {
    return [
      Book(
          coverPath: 'assets/images/bookCover2.png',
          title: 'We Never Got Over',
          author: 'Lucy Score'),
      Book(
          coverPath: 'assets/images/bookCover3.png',
          title: 'This Summer Will Be Different',
          author: 'Carley Fortune'),
      Book(
          coverPath: 'assets/images/bookCover4.png',
          title: 'Deathly Hollows',
          author: 'Harry Potter'),
      Book(
          coverPath: 'assets/images/bookCover5.png',
          title: 'The beloved girls',
          author: 'Harriet Evans'),
      Book(
          coverPath: 'assets/images/bookCover6.png',
          title: 'The book of art',
          author: 'Thomas J.'),
      Book(
          coverPath: 'assets/images/bookCover7.png',
          title: 'The island',
          author: 'Usher Evans'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double logoW = size.width * 0.5;
    final double logoH = logoW * 0.5;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
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
              FutureBuilder<List<Book>>(
                future: booksFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    return GridView.builder(
                      itemCount: snapshot.data!.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.75, // Make cards shorter
                      ),
                      itemBuilder: (context, index) {
                        final book = snapshot.data![index];
                        return _BookCard(
                          coverPath: book.coverPath,
                          title: book.title,
                          author: book.author,
                          onPressed: () {
                            context.go('/bookDetails', extra: book);
                          },
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('No books found.'));
                  }
                },
              ),
              const SizedBox(height: 96),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(
      {required this.logoW, required this.logoH, required this.onSearch});

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

class _BookCard extends StatelessWidget {
  const _BookCard({
    required this.coverPath,
    required this.title,
    required this.author,
    this.widthFactor = 1.0,
    this.cardHeight = 120,
    this.contentPadding = 16,
    this.onPressed,
    super.key,
  });

  final String coverPath, title, author;
  final double widthFactor;
  final double cardHeight;
  final double contentPadding;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: AppColors.beige,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16), // smaller padding
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  coverPath,
                  height: 120, // reduced image height
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10), // reduced spacing
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8), // reduced spacing
            Text(
              author,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
