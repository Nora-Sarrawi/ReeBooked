import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String author;
  final String? ownerName;
  final String? ownerImageUrl;
  final VoidCallback onTap;
  final bool isHorizontal;

  const BookCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.author,
    this.ownerName,
    this.ownerImageUrl,
    required this.onTap,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 2,
        color: const Color(0xFFF2E9DC),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: isHorizontal ? _buildHorizontal() : _buildVertical(),
        ),
      ),
    );
  }

  Widget _buildVertical() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            imageUrl,
            width: double.infinity,
            height: 120,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF562B56),
          ),
        ),
        Text(
          author,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 8),
        if (ownerName != null && ownerImageUrl != null)
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(ownerImageUrl!),
                radius: 12,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  ownerName!,
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildHorizontal() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            imageUrl,
            width: 70,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF562B56),
                ),
              ),
              Text(
                author,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 8),
              if (ownerName != null && ownerImageUrl != null)
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(ownerImageUrl!),
                      radius: 12,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        ownerName!,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black87),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
