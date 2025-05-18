import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../../core/theme.dart'; // AppColors, appTheme
import '../../core/constants.dart'; // AppPadding

/* ────────────────────────────────────────────────────────────── */
/*  Model + dummy seed                                           */
/* ────────────────────────────────────────────────────────────── */

enum BookStatus { available, requested, onLoan }

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
}

const List<Book> kDummyBooks = [
  Book(
    id: 'b1',
    coverPath: 'assets/images/book3.jpg',
    title: 'Things We Never Got Over',
    author: 'Lucy Score',
    ownerName: 'Masa Jaara',
    ownerAvatar: 'assets/images/book3.jpg',
    location: 'Amman',
    genre: 'Romance',
    status: BookStatus.available,
  ),
  Book(
    id: 'b2',
    coverPath: 'assets/images/book4.jpg',
    title: 'This Summer Will Be Different',
    author: 'Carley',
    ownerName: 'Alaa Qaqa',
    location: 'Nablus',
    genre: 'Mystery',
    status: BookStatus.requested,
  ),
  Book(
    id: 'b1',
    coverPath: 'assets/images/book3.jpg',
    title: 'Things We Never Got Over',
    author: 'Lucy Score',
    ownerName: 'Masa Jaara',
    ownerAvatar: 'assets/images/book3.jpg',
    location: 'Amman',
    genre: 'Romance',
    status: BookStatus.available,
  ),
  Book(
    id: 'b2',
    coverPath: 'assets/images/book4.jpg',
    title: 'This Summer Will Be Different',
    author: 'Carley',
    ownerName: 'Alaa Qaqa',
    location: 'Nablus',
    genre: 'Mystery',
    status: BookStatus.requested,
  ),
  Book(
    id: 'b1',
    coverPath: 'assets/images/book3.jpg',
    title: 'Things We Never Got Over',
    author: 'Lucy Score',
    ownerName: 'Masa Jaara',
    ownerAvatar: 'assets/images/book3.jpg',
    location: 'Amman',
    genre: 'Romance',
    status: BookStatus.available,
  ),
  Book(
    id: 'b2',
    coverPath: 'assets/images/book4.jpg',
    title: 'This Summer Will Be Different',
    author: 'Carley',
    ownerName: 'Alaa Qaqa',
    location: 'Nablus',
    genre: 'Mystery',
    status: BookStatus.requested,
  ),
];

/* ────────────────────────────────────────────────────────────── */
/*  Home Screen                                                  */
/* ────────────────────────────────────────────────────────────── */

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double logoW = size.width * 0.62;
    final double logoH = logoW * 1.12;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView.builder(
          padding: AppPadding.screenPadding.copyWith(bottom: 96),
          itemCount: kDummyBooks.length + 2, // header + filter row
          itemBuilder: (ctx, i) {
            if (i == 0) return _Header(logoW: logoW, logoH: logoH);
            if (i == 1)
              return const Padding(
                  padding: EdgeInsets.only(top: 5), child: _FilterRow());

            final book = kDummyBooks[i - 2];
            return Padding(
              padding: const EdgeInsets.only(top: 24),
              child: _BookCard(
                coverPath: book.coverPath,
                title: book.title,
                author: book.author,
                ownerName: book.ownerName,
                ownerAvatar: book.ownerAvatar,
                location: book.location,
                genre: book.genre,
                status: book.status,
              ),
            );
          },
        ),
      ),
    );
  }
}

/*─────────────────────────────────────────────────────────────────────────────*/
/*  Header with REAL search bar                                                */
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
      children: [
        const SizedBox(height: 20),
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
        const SizedBox(height: 20), // slimmer gap than before
      ],
    );
  }
}

/*─────────────────────────────────────────────────────────────────────────────*/
/*  Row with three filter chips                                               */
/*─────────────────────────────────────────────────────────────────────────────*/

class _FilterRow extends StatefulWidget {
  const _FilterRow({Key? key}) : super(key: key);

  @override
  State<_FilterRow> createState() => _FilterRowState();
}

class _FilterRowState extends State<_FilterRow> {
  final _genres = ['Genre', 'Romance', 'Fantasy', 'Mystery'];
  final _authors = ['Author', 'Lucy', 'Carley', 'Unknown'];
  final _locations = ['Location', 'Library', 'Amman', 'Nablus'];

  String _gSel = 'Genre';
  String _aSel = 'Author';
  String _lSel = 'Location';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _DropdownChip(
          value: _gSel,
          items: _genres,
          onChanged: (v) => setState(() => _gSel = v),
        ),
        const SizedBox(width: 12),
        _DropdownChip(
          value: _aSel,
          items: _authors,
          onChanged: (v) => setState(() => _aSel = v),
        ),
        const SizedBox(width: 12),
        _DropdownChip(
          value: _lSel,
          items: _locations,
          onChanged: (v) => setState(() => _lSel = v),
        ),
      ],
    );
  }
}

/*─────────────────────────────────────────────────────────────────────────────*/
/*  Purple pill built with dropdown_button2 (v2.x)                            */
/*  – arrow sits right next to text                                           */
/*  – popup has square top corners                                            */
/*─────────────────────────────────────────────────────────────────────────────*/
class _DropdownChip extends StatefulWidget {
  const _DropdownChip({
    Key? key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.width = 110,
  }) : super(key: key);

  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  final double width;

  @override
  State<_DropdownChip> createState() => _DropdownChipState();
}

class _DropdownChipState extends State<_DropdownChip> {
  bool _menuOpen = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          // ───── model ─────
          value: widget.value,
          isExpanded: true,
          onMenuStateChange: (open) => setState(() => _menuOpen = open),
          onChanged: (v) => widget.onChanged(v!),

          /*────────── 100 % custom pill (⇢ arrow gap under your control) ─────────*/
          customButton: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    widget.value,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                const SizedBox(width: 4), // <── tighter gap
                AnimatedRotation(
                  turns: _menuOpen ? 0.25 : 0,
                  duration: const Duration(milliseconds: 150),
                  child: const Icon(Icons.arrow_drop_down,
                      size: 22, color: Colors.white),
                ),
              ],
            ),
          ),

          /*────────── dropdown (overlay) ─────────*/
          dropdownStyleData: DropdownStyleData(
            width: widget.width,
            maxHeight: 220,
            offset: const Offset(0, 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(.85),
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25), // bottom only  ➜ square top
                  bottomRight: Radius.circular(25),
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25)),
            ),
          ),
          menuItemStyleData:
              const MenuItemStyleData(padding: EdgeInsets.zero, height: 44),

          /*────────── items ─────────*/
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
                child: Text(
                  txt,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/*─────────────────────────────────────────────────────────────────────────────*/
/*  Book Card                           */
/*─────────────────────────────────────────────────────────────────────────────*/

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
    super.key,
  });

  final String coverPath, title, author, ownerName;
  final String? ownerAvatar;
  final String location, genre;
  final BookStatus status;
  final double widthFactor, cardHeight, contentPadding;

  @override
  Widget build(BuildContext context) {
    final double cardW =
        (MediaQuery.of(context).size.width * widthFactor).clamp(212, 260);
    final double cardH = cardHeight.clamp(220, 400);

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

    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: cardW,
        height: cardH,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => GoRouter.of(context).go('/book-details'),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.beige,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Cover
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                          bottom: Radius.circular(16)),
                      child: Image.asset(
                        coverPath,
                        height: 160,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Title & author
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
                // New: location & genre
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
                // New: status badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor().withOpacity(.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _statusText(),
                    style: TextStyle(
                        color: _statusColor(),
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 8),

                // Owner row
                Padding(
                  padding: EdgeInsets.only(
                      left: contentPadding, right: 12, bottom: 16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundImage: ownerAvatar == null
                            ? const AssetImage(
                                'assets/images/book1.jpg',
                              ) as ImageProvider
                            : (ownerAvatar!.startsWith('http')
                                ? NetworkImage(ownerAvatar!)
                                : AssetImage(ownerAvatar!)),
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
