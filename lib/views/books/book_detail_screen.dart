import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BookDetailsScreen extends StatelessWidget {
  final String bookId;

  const BookDetailsScreen({Key? key, required this.bookId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('books').doc(bookId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Book not found.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          print('Book Data: $data');

          final title = data['title'] ?? '';
          final author = data['author'] ?? '';
          final publishYear = data['publishYear']?.toString() ?? '';
          final description = data['description'] ?? '';
          final notes = data['notes'] ?? '';
          final coverUrl = data['coverUrl'] ?? '';
          final status = data['status'] ?? '';
          final ownerId = data['ownerId'] ?? '';

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () => context.go('/my-books'),
                        icon: const Icon(Icons.arrow_back,
                            color: Color(0xFF562B56)),
                        label: const Text(
                          'Book Details',
                          style: TextStyle(
                            color: Color(0xFF562B56),
                            fontSize: 24,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        coverUrl,
                        height: 200,
                        width: 140,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image_not_supported, size: 80),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildIconLabelRow(Icons.book, 'Book Name', title),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildIconLabelRow(Icons.person, 'Author', author),
                      _buildTextColumn('Publish Year', publishYear),
                    ],
                  ),
                  const SizedBox(height: 25),
                  buildExpandableInfoCard('Description', description),
                  const SizedBox(height: 16),
                  buildExpandableInfoCard('Notes', notes),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.check_circle, color: Color(0xFF562B56)),
                      const SizedBox(width: 8),
                      const Text(
                        'Status',
                        style: TextStyle(
                          color: Color(0xFF562B56),
                          fontSize: 20,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7C873),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status,
                          style: const TextStyle(
                            color: Color(0xFFA35800),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: data['ownerAvatarUrl'] != null
                            ? NetworkImage(data['ownerAvatarUrl'])
                            : const NetworkImage("https://placehold.co/30x30"),
                        radius: 15,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        data['ownerName'] ?? 'Unknown Owner',
                        style: const TextStyle(
                          color: Color(0xFF562B56),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC76767),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 12),
                      ),
                      onPressed: () {
                        context.go('/confirm', extra: {
                          'bookId': bookId,
                          'bookTitle': title,
                          'bookCover': coverUrl,
                          'author': author,
                          'ownerName': data['ownerName'] ?? 'Unknown Owner',
                          'location': data['location'] ?? '',
                          'genre': data['genre'] ?? '',
                          'status': status,
                          'ownerId': data['ownerId'] ?? '',
                        });
                      },
                      child: const Text(
                        'Send Swap Request',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIconLabelRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF562B56)),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF562B56),
                fontSize: 20,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Color(0xFF562B56),
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF562B56),
            fontSize: 20,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF562B56),
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget buildExpandableInfoCard(String title, String content) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: ExpansionTile(
        collapsedIconColor: const Color(0xFF562B56),
        iconColor: const Color(0xFF562B56),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF562B56),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              content,
              style: const TextStyle(
                color: Color(0xFF562B56),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
