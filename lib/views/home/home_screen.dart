import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../../core/theme.dart'; // AppColors
import '../../core/constants.dart'; // AppPadding
import '../../services/profile_service.dart';
import '../../utils/content_wrapper.dart'; // MaxWidthBox helper

/* ──────────────────────────────────────────────────────────── */
/*  tiny helper – removes ellipsis + all whitespace in URLs    */
/* ──────────────────────────────────────────────────────────── */
String _cleanUrl(String raw) => raw
    .replaceAll('\u2026', '') // kill "…" character
    .replaceAll(RegExp(r'\s'), '') // trim spaces / newlines / tabs
    .trim();

/* ──────────────────────────────────────────────────────────── */
/*  Model                                                      */
/* ──────────────────────────────────────────────────────────── */

enum BookStatus { available, requested, onLoan }

BookStatus _statusFromString(String s) => BookStatus.values
    .firstWhere((e) => e.name == s, orElse: () => BookStatus.available);

class Book {
  final String id;
  final String coverPath; // http, gs://, or relative
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

  factory Book.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return Book(
      id: doc.id,
      coverPath: _cleanUrl(d['coverUrl'] ?? ''),
      title: d['title'] ?? 'Untitled',
      author: d['author'] ?? 'Unknown',
      ownerName: d['ownerName'] ?? 'Unknown',
      ownerAvatar:
          d['ownerAvatarUrl'] == null ? null : _cleanUrl(d['ownerAvatarUrl']),
      location: d['location'] ?? '',
      genre: d['genre'] ?? '',
      status: _statusFromString(d['status'] ?? 'available'),
    );
  }
}

/* ──────────────────────────────────────────────────────────── */
/*  Home Screen …  (everything below is unchanged except where */
/*  noted:   ① dropdownStyleData already has padding: zero     */
/*           ② _CoverImage now cleans incoming path)           */
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

  // Add constants for logo dimensions
  static const double logoW = 120.0;
  static const double logoH = 40.0;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<List<Book>> _fetchBooks() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final qs = await FirebaseFirestore.instance
        .collection('books')
        .where('ownerId', isNotEqualTo: uid)
        .get();

    final books = await Future.wait(qs.docs.map((doc) async {
      final data = doc.data();
      final ownerId = data['ownerId'] as String?;

      if (ownerId == null) {
        return Book.fromDoc(doc);
      }

      final ownerData = await ProfileService().getOwnerProfile(ownerId);
      return Book(
        id: doc.id,
        coverPath: data['coverUrl'] ?? '',
        title: data['title'] ?? 'Untitled',
        author: data['author'] ?? 'Unknown',
        ownerName: ownerData?['ownerName'] ?? 'Unknown',
        ownerAvatar: ownerData?['ownerAvatar'],
        location: data['location'] ?? '',
        genre: data['genre'] ?? '',
        status: _statusFromString(data['status'] ?? 'available'),
      );
    }));

    // Apply search filter
    List<Book> filteredBooks = books;
    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.toLowerCase().trim();
      filteredBooks = filteredBooks.where((book) {
        final titleMatch = book.title.toLowerCase().contains(query);
        final authorMatch = book.author.toLowerCase().contains(query);
        return titleMatch || authorMatch;
      }).toList();
    }

    // Apply genre filter
    if (_gSel != 'Genre') {
      filteredBooks = filteredBooks
          .where((book) => book.genre.toLowerCase() == _gSel.toLowerCase())
          .toList();
    }

    // Apply location filter
    if (_lSel != 'Location') {
      filteredBooks = filteredBooks
          .where((book) => book.location.toLowerCase() == _lSel.toLowerCase())
          .toList();
    }

    return filteredBooks;
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
    final isWide = MediaQuery.of(context).size.width > 600;
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

  static const double _chipWidth = 120.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _DropdownChip(
            width: _chipWidth,
            value: gSel,
            items: _genres,
            onChanged: onGenre,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _DropdownChip(
            width: _chipWidth,
            value: lSel,
            items: _locations,
            onChanged: onLoc,
          ),
        ),
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
    required this.width,
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
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    widget.value,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
          ), // unchanged

          dropdownStyleData: DropdownStyleData(
            width: widget.width,
            maxHeight: 220,
            offset: const Offset(0, 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(.85),
              borderRadius: BorderRadius.circular(25),
            ),
            padding: EdgeInsets.zero, // outer margin 0
            scrollPadding: EdgeInsets.zero, // ← NEW • ListView margin 0
          ),
          menuItemStyleData:
              const MenuItemStyleData(padding: EdgeInsets.zero, height: 44),

          items: widget.items.map((txt) {
            final last = txt == widget.items.last;
            return DropdownMenuItem<String>(
              value: txt,
              alignment: Alignment.center, // stretch to menu width (2.3+)
              child: Container(
                width: double.infinity,
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
/*  Cover image helper – path cleaned first                    */
/* ──────────────────────────────────────────────────────────── */
class _CoverImage extends StatelessWidget {
  const _CoverImage(this.rawPath, {super.key});
  final String rawPath;

  Future<String> _resolveUrl() async {
    final path = _cleanUrl(rawPath);

    // 👇 Debug line — look in the console while the app is running.
    debugPrint('COVER path after cleaning: "$path"');

    if (path.startsWith('http')) return path;

    try {
      final ref = path.startsWith('gs://')
          ? FirebaseStorage.instance.refFromURL(path)
          : FirebaseStorage.instance.ref(path);
      final url = await ref.getDownloadURL();
      debugPrint('Resolved download URL: $url'); // 👈 optional
      return url;
    } catch (e) {
      debugPrint('Failed to resolve "$path": $e');
      return ''; // triggers broken-image icon
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _resolveUrl(),
      builder: (ctx, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const SizedBox(
              height: 160,
              width: 150,
              child: Center(child: CircularProgressIndicator(strokeWidth: 1)));
        }
        final url = snap.data ?? '';
        return Image.network(
          url,
          height: 160,
          width: 150,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.broken_image, size: 80, color: Colors.grey),
        );
      },
    );
  }
}

/* ──────────────────────────────────────────────────────────── */
/*  Book Card                                                  */
/* ──────────────────────────────────────────────────────────── */

class _BookCard extends StatelessWidget {
  const _BookCard({
    required this.id,
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
              borderRadius: BorderRadius.circular(16),
            ),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
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
                const SizedBox(height: 8),
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
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor().withOpacity(.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(_statusText(),
                      style: TextStyle(
                          color: _statusColor(),
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.only(
                      left: contentPadding, right: 12, bottom: 16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundImage: ownerAvatar == null
                            ? const AssetImage('assets/images/book1.jpg')
                            : (ownerAvatar!.startsWith('http')
                                ? NetworkImage(ownerAvatar!) as ImageProvider
                                : AssetImage(ownerAvatar!) as ImageProvider),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          ownerName,
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ──────────────────────────────────────────────────────────── */
/*  Phone layout                                               */
/* ──────────────────────────────────────────────────────────── */

class _PhoneLayout extends StatelessWidget {
  const _PhoneLayout({
    required this.books,
    required this.gSel,
    required this.lSel,
    required this.onGenre,
    required this.onLoc,
    required this.search,
  });

  final List<Book> books;
  final String gSel, lSel;
  final ValueChanged<String> onGenre, onLoc;
  final TextEditingController search;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: AppPadding.screenPadding.copyWith(bottom: 96),
      itemCount: books.length + 2,
      itemBuilder: (ctx, i) {
        if (i == 0) {
          return _Header(
            logoW: _HomeScreenState.logoW,
            logoH: _HomeScreenState.logoH,
            search: search,
          );
        }
        if (i == 1) {
          return _FilterRow(
            gSel: gSel,
            lSel: lSel,
            onGenre: onGenre,
            onLoc: onLoc,
          );
        }
        final b = books[i - 2];
        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: _BookCard(
            id: b.id,
            coverPath: b.coverPath,
            title: b.title,
            author: b.author,
            ownerName: b.ownerName,
            ownerAvatar: b.ownerAvatar,
            location: b.location,
            genre: b.genre,
            status: b.status,
          ),
        );
      },
    );
  }
}

/* ──────────────────────────────────────────────────────────── */
/*  Wide layout                                                */
/* ──────────────────────────────────────────────────────────── */

class _WideLayout extends StatelessWidget {
  const _WideLayout({
    required this.books,
    required this.gSel,
    required this.lSel,
    required this.onGenre,
    required this.onLoc,
    required this.search,
  });

  final List<Book> books;
  final String gSel, lSel;
  final ValueChanged<String> onGenre, onLoc;
  final TextEditingController search;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _Header(
            logoW: _HomeScreenState.logoW,
            logoH: _HomeScreenState.logoH,
            search: search,
          ),
        ),
        SliverToBoxAdapter(
          child: _FilterRow(
            gSel: gSel,
            lSel: lSel,
            onGenre: onGenre,
            onLoc: onLoc,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => _BookCard(
                id: books[i].id,
                coverPath: books[i].coverPath,
                title: books[i].title,
                author: books[i].author,
                ownerName: books[i].ownerName,
                ownerAvatar: books[i].ownerAvatar,
                location: books[i].location,
                genre: books[i].genre,
                status: books[i].status,
              ),
              childCount: books.length,
            ),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 280,
              crossAxisSpacing: 16,
              mainAxisSpacing: 20,
              childAspectRatio: 0.65,
            ),
          ),
        ),
      ],
    );
  }
}
