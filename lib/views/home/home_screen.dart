import 'package:rebooked_app/widgets/book_card.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../../core/theme.dart'; // AppColors, appTheme
import '../../core/constants.dart'; // AppPadding

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double logoW = size.width * 0.62;
    final double logoH = logoW * 1.12;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppPadding.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ------- red header + search -------
              _Header(logoW: logoW, logoH: logoH),

              const SizedBox(height: 5),

              // ------- filter chips row -------
              const _FilterRow(),

              const SizedBox(height: 24),

              // ------- book cards -------
              const _BookCard(
                coverPath: 'assets/images/book3.jpg',
                title: 'Things We Never Got Over',
                author: 'Lucy Score',
                ownerName: 'Masa Jaara',
                ownerAvatar: 'assets/images/book3.jpg',
              ),

              const SizedBox(height: 32),
              const _BookCard(
                coverPath: 'assets/images/book4.jpg',
                title: 'This Summer Will Be Different',
                author: 'Carley',
                ownerName: 'Alaa Qaqa',
              ),

              const SizedBox(height: 32),
              const _BookCard(
                coverPath: 'assets/images/book2.avif',
                title: 'This Summer Will Be Different',
                author: 'Carley',
                ownerName: 'Alaa Qaqa',
              ),

              const SizedBox(height: 32),
              const _BookCard(
                coverPath: 'assets/images/book1.jpg',
                title: 'This Summer Will Be Different',
                author: 'Carley',
                ownerName: 'Alaa Qaqa',
              ),

              const SizedBox(height: 32),
              const _BookCard(
                coverPath: 'assets/images/logo.png',
                title: 'This Summer Will Be Different',
                author: 'Carley',
                ownerName: 'Alaa Qaqa',
              ),

              const SizedBox(height: 32),
              const _BookCard(
                coverPath: 'assets/images/book5.webp',
                title: 'This Summer Will Be Different',
                author: 'Carley',
                ownerName: 'Alaa Qaqa',
              ),

              const SizedBox(height: 96), // space for floating button
            ],
          ),
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
/*  Book Card – centred text, centred image, left-aligned owner row           */
/*─────────────────────────────────────────────────────────────────────────────*/

class _BookCard extends StatelessWidget {
  const _BookCard({
    required this.coverPath,
    required this.title,
    required this.author,
    required this.ownerName,
    this.ownerAvatar,
    this.widthFactor = .80, // % of screen width
    this.cardHeight = 280, // total beige card height
    this.contentPadding = 16, // left padding for avatar + name row
    super.key,
  });

  final String coverPath, title, author, ownerName;
  final String? ownerAvatar;
  final double widthFactor;
  final double cardHeight;
  final double contentPadding;

  @override
  Widget build(BuildContext context) {
    // responsive width with min/max safety
    final double cardW =
        (MediaQuery.of(context).size.width * widthFactor).clamp(212, 260);
    final double cardH = cardHeight.clamp(220, 400);

    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: cardW,
        height: cardH,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.beige,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // centre text column
            children: [
              // -------- Cover (centred) ---------------------------------------
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16), bottom: Radius.circular(16)),
                    child: Image.asset(
                      coverPath,
                      height: 160,
                      width: 150, // thumbnail width
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // -------- Title & author (centred text) -------------------------
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
              const Spacer(),

              // -------- Owner row (left-aligned) ------------------------------
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
                            ) as ImageProvider // default
                          : (ownerAvatar!.startsWith(
                              'http',
                            )
                              ? NetworkImage(
                                  ownerAvatar!,
                                ) // Cloud Storage / URL
                              : AssetImage(
                                  ownerAvatar!,
                                )), // local asset
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
    );
  }
}
