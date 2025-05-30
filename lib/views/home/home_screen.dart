import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../../core/theme.dart'; // AppColors
import '../../core/constants.dart'; // AppPadding

/* ──────────────────────────────────────────────────────────── */
/*  Model                                                      */
/* ──────────────────────────────────────────────────────────── */

enum BookStatus { available, requested, onLoan }

BookStatus _statusFromString(String s) => BookStatus.values
    .firstWhere((e) => e.name == s, orElse: () => BookStatus.available);

class Book {
  final String id;
  final String coverPath;
  final String title;
  final String author;
  final String ownerName;
  final String? ownerAvatar;
  final String location;
  final String genre;
  final BookStatus status;

  const Book({
    required this.id,
    required this.coverPath,
    required this.title,
    required this.author,
    required this.ownerName,
    this.ownerAvatar,
    required this.location,
    required this.genre,
    this.status = BookStatus.available,
  });

  /// Factory to create a Book from Firestore
  factory Book.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return Book(
      id: doc.id,
      coverPath: d['coverUrl'] ?? '',
      title: d['title'] ?? 'Untitled',
      author: d['author'] ?? 'Unknown',
      ownerName: d['ownerName'] ?? 'Unknown',
      ownerAvatar: d['ownerAvatarUrl'],
      location: d['location'] ?? '',
      genre: d['genre'] ?? '',
      status: _statusFromString(d['status'] ?? 'available'),
    );
  }
}

/* ──────────────────────────────────────────────────────────── */
/*  Home Screen                                                */
/* ──────────────────────────────────────────────────────────── */

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _search = TextEditingController();
  String _gSel = 'Genre';
  String _lSel = 'Location';
  String _searchQuery = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<List<Book>> _fetchBooks() async {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    final qs = await FirebaseFirestore.instance
        .collection('books')
        .where('ownerId', isNotEqualTo: currentUid)
        .get();
    List<Book> allBooks = qs.docs.map(Book.fromDoc).toList();

    // Apply search filter
    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.toLowerCase().trim();
      allBooks = allBooks.where((book) {
        final titleMatch = book.title.toLowerCase().contains(query);
        final authorMatch = book.author.toLowerCase().contains(query);
        return titleMatch || authorMatch;
      }).toList();
    }

    // Apply genre filter
    if (_gSel != 'Genre') {
      allBooks = allBooks
          .where((book) => book.genre.toLowerCase() == _gSel.toLowerCase())
          .toList();
    }

    // Apply location filter
    if (_lSel != 'Location') {
      allBooks = allBooks
          .where((book) => book.location.toLowerCase() == _lSel.toLowerCase())
          .toList();
    }

    return allBooks;
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _onGenreChanged(String genre) {
    setState(() {
      _gSel = genre;
    });
  }

  void _onLocationChanged(String location) {
    setState(() {
      _lSel = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double logoW = size.width * 0.62;
    final double logoH = logoW * 1.12;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: AppPadding.screenPadding,
              child: Column(
                children: [
                  _Header(logoW: logoW, logoH: logoH, search: _search),
                  _FilterRow(
                    gSel: _gSel,
                    lSel: _lSel,
                    onGenre: _onGenreChanged,
                    onLoc: _onLocationChanged,
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Book>>(
                future: _fetchBooks(),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snap.hasError || !snap.hasData || snap.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No books available.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }
                  final books = snap.data!;
                  return ListView.builder(
                    padding: AppPadding.screenPadding.copyWith(
                      top: 24,
                      bottom: 96,
                    ),
                    itemCount: books.length,
                    itemBuilder: (ctx, i) {
                      final b = books[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: _BookCard(
                          coverPath: b.coverPath,
                          title: b.title,
                          author: b.author,
                          ownerName: b.ownerName,
                          ownerAvatar: b.ownerAvatar,
                          location: b.location,
                          genre: b.genre,
                          status: b.status,
                          id: b.id,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ──────────────────────────────────────────────────────────── */
/*  Header                                                     */
/* ──────────────────────────────────────────────────────────── */

class _Header extends StatelessWidget {
  const _Header({
    required this.logoW,
    required this.logoH,
    required this.search,
  });
  final double logoW, logoH;
  final TextEditingController search;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        TextField(
          controller: search,
          textInputAction: TextInputAction.search,
          onChanged: (query) {
            // Get the HomeScreen state and update search
            final homeState =
                context.findAncestorStateOfType<_HomeScreenState>();
            homeState?._onSearchChanged(query);
          },
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
        const SizedBox(height: 20),
      ],
    );
  }
}

/* ──────────────────────────────────────────────────────────── */
/*  Filter row                                                 */
/* ──────────────────────────────────────────────────────────── */

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.gSel,
    required this.lSel,
    required this.onGenre,
    required this.onLoc,
  });

  final String gSel, lSel;
  final ValueChanged<String> onGenre, onLoc;

  static const _genres = [
    'Genre',
    'Storytelling',
    'Truth',
    'Imagination',
    'Wisdom',
    'Growth'
  ];
  static const _locations = [
    'Location',
    'Jerusalem',
    'Ramallah',
    'Nablus',
    'Hebron',
    'Bethlehem',
    'Jenin'
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child:
                _DropdownChip(value: gSel, items: _genres, onChanged: onGenre)),
        const SizedBox(width: 12),
        Expanded(
            child: _DropdownChip(
                value: lSel, items: _locations, onChanged: onLoc)),
      ],
    );
  }
}

/* ──────────────────────────────────────────────────────────── */
/*  DropdownChip                                               */
/* ──────────────────────────────────────────────────────────── */

class _DropdownChip extends StatefulWidget {
  const _DropdownChip({
    required this.value,
    required this.items,
    required this.onChanged,
    this.width = 185,
    super.key,
  });

  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  final double width;

  @override
  State<_DropdownChip> createState() => _DropdownChipState();
}

class _DropdownChipState extends State<_DropdownChip> {
  bool _open = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          value: widget.value,
          isExpanded: true,
          onMenuStateChange: (o) => setState(() => _open = o),
          onChanged: (v) => widget.onChanged(v!),
          customButton: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(25)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(widget.value,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 4),
                AnimatedRotation(
                  turns: _open ? 0.25 : 0,
                  duration: const Duration(milliseconds: 150),
                  child: const Icon(Icons.arrow_drop_down,
                      size: 22, color: Colors.white),
                ),
              ],
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            width: widget.width,
            maxHeight: 220,
            offset: const Offset(0, 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(.85),
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          menuItemStyleData:
              const MenuItemStyleData(padding: EdgeInsets.zero, height: 44),
          items: widget.items.map((txt) {
            final last = txt == widget.items.last;
            return DropdownMenuItem<String>(
              value: txt,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: last
                    ? null
                    : const BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.white24))),
                child: Text(txt,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/* ──────────────────────────────────────────────────────────── */
/*  Book Card                                                  */
/* ──────────────────────────────────────────────────────────── */

class _BookCard extends StatelessWidget {
  const _BookCard({
    required this.coverPath,
    required this.title,
    required this.author,
    required this.ownerName,
    this.ownerAvatar,
    this.location = '',
    this.genre = '',
    this.status = BookStatus.available,
    this.widthFactor = .80,
    this.cardHeight = 340,
    this.contentPadding = 16,
    required this.id,
    super.key,
  });

  final String coverPath, title, author, ownerName, id;
  final String? ownerAvatar;
  final String location, genre;
  final BookStatus status;
  final double widthFactor, cardHeight, contentPadding;

  Color _statusColor() {
    switch (status) {
      case BookStatus.available:
        return Colors.green;
      case BookStatus.requested:
        return Colors.orange;
      case BookStatus.onLoan:
        return Colors.red;
    }
  }

  String _statusText() => status.name
      .replaceFirstMapped(RegExp(r'([A-Z])'), (m) => ' ${m.group(1)}')
      .trim();

  @override
  Widget build(BuildContext context) {
    final double cardW = (MediaQuery.of(context).size.width * widthFactor)
        .clamp(212.0, 260.0)
        .toDouble();

    final double cardH = cardHeight.clamp(220.0, 400.0).toDouble();

    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: cardW,
        height: cardH,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.go('/book/$id', extra: {
            'bookId': id,
            'bookTitle': title,
            'bookCover': coverPath,
            'author': author,
            'ownerName': ownerName,
            'location': location,
            'genre': genre,
            'status': status,
          }),
          child: Container(
            decoration: BoxDecoration(
                color: AppColors.beige,
                borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // cover
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16), bottom: Radius.circular(16)),
                    child: coverPath.startsWith('http')
                        ? Image.network(coverPath,
                            height: 160, width: 150, fit: BoxFit.cover)
                        : Image.asset(coverPath,
                            height: 160, width: 150, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 12),
                // title & author
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      Text(title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text(author,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // location & genre
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on,
                            size: 14, color: AppColors.secondary),
                        const SizedBox(width: 4),
                        Text(location, style: const TextStyle(fontSize: 12)),
                        const SizedBox(width: 12),
                        Icon(Icons.category,
                            size: 14, color: AppColors.secondary),
                        const SizedBox(width: 4),
                        Text(genre, style: const TextStyle(fontSize: 12)),
                      ]),
                ),
                const Spacer(),
                // status badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: _statusColor().withOpacity(.2),
                      borderRadius: BorderRadius.circular(12)),
                  child: Text(_statusText(),
                      style: TextStyle(
                          color: _statusColor(),
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 8),
                // owner row
                Padding(
                  padding: EdgeInsets.only(
                      left: contentPadding, right: 12, bottom: 16),
                  child: Row(children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundImage: ownerAvatar == null
                          ? const AssetImage('assets/images/book1.jpg')
                              as ImageProvider
                          : (ownerAvatar!.startsWith('http')
                              ? NetworkImage(ownerAvatar!)
                              : AssetImage(ownerAvatar!)),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(ownerName,
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
