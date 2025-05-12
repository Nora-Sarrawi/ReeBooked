import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme.dart'; // AppColors, appTheme
import '../../core/constants.dart'; // AppPadding

class MyBooksScreen extends StatelessWidget {
  const MyBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double logoW = size.width * 0.5;
    final double logoH = logoW * 0.5;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppPadding.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(logoW: logoW, logoH: logoH),
              const SizedBox(height: 20),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 24,
                childAspectRatio: 0.6,
                children: const [
                  _BookCard(
                    coverPath: 'assets/images/bookCover2.png',
                    title: 'We Never Got Over',
                    author: 'Lucy Score',
                  ),
                  _BookCard(
                    coverPath: 'assets/images/bookCover3.png',
                    title: 'This Summer Will Be Different',
                    author: 'Carley Fortune',
                  ),
                  _BookCard(
                    coverPath: 'assets/images/bookCover4.png',
                    title: 'Deathly Hollows',
                    author: 'Harry Potter',
                  ),
                  _BookCard(
                    coverPath: 'assets/images/bookCover5.png',
                    title: 'The beloved girls',
                    author: 'Harriet Evans',
                  ),
                  _BookCard(
                    coverPath: 'assets/images/bookCover6.png',
                    title: 'The book of art',
                    author: 'Thomas J.',
                  ),
                  _BookCard(
                    coverPath: 'assets/images/bookCover7.png',
                    title: 'The island',
                    author: 'Usher Evans',
                  ),
                ],
              ),
              const SizedBox(height: 96),
            ],
          ),
        ),
      ),
    );
  }
}

/*─────────────────────────────────────────────────────────────────────────────*/
/*  Header                                                                     */
/*─────────────────────────────────────────────────────────────────────────────*/

class _Header extends StatefulWidget {
  const _Header({required this.logoW, required this.logoH});

  final double logoW, logoH;

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

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
          controller: _search,
          textInputAction: TextInputAction.search,
          onSubmitted: (q) => debugPrint('Search: $q'),
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

/*─────────────────────────────────────────────────────────────────────────────*/
/*  Book Card                                                                  */
/*─────────────────────────────────────────────────────────────────────────────*/

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
      onPressed: onPressed ?? () {context.go('/bookDetails');},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 22),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  coverPath,
                  height: 120,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
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
