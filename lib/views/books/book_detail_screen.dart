import 'package:flutter/material.dart';

class BookDetailsScreen extends StatelessWidget {
  const BookDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF562B56)),
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
                  child: Image.asset(
                    'assets/images/bookCover3.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Icon(Icons.book, color: Color(0xFF562B56)),
                  const SizedBox(width: 8),
                  const Text(
                    'Book Name',
                    style: TextStyle(
                      color: Color(0xFF562B56),
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'This summer will be different',
                style: TextStyle(
                  color: Color(0xFF562B56),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person, color: Color(0xFF562B56)),
                      const SizedBox(width: 6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Author',
                            style: TextStyle(
                              color: Color(0xFF562B56),
                              fontSize: 20,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Carley',
                            style: TextStyle(
                              color: Color(0xFF562B56),
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Publish Year',
                        style: TextStyle(
                          color: Color(0xFF562B56),
                          fontSize: 20,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '2010',
                        style: TextStyle(
                          color: Color(0xFF562B56),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 25),
              buildExpandableInfoCard('Description',
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed sit amet lacus enim.'),
              const SizedBox(height: 16),
              buildExpandableInfoCard('Notes',
                  'These are some detailed notes. You can add more information here and it will expand.'),
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
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7C873),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Available',
                      style: TextStyle(
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
                  const CircleAvatar(
                    backgroundImage: NetworkImage("https://placehold.co/30x30"),
                    radius: 15,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Kareem Abukharma',
                    style: TextStyle(
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
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Send Swap Request',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      height: 1,
                      letterSpacing: 0.10,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildExpandableInfoCard(String title, String content) {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        collapsedBackgroundColor: const Color(0xFFF2E9DC),
        backgroundColor: const Color(0xFFF2E9DC),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        leading: const Icon(Icons.description, color: Color(0xFF562B56)),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF562B56),
            fontSize: 20,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
          ),
        ),
        children: [
          Text(
            content,
            style: const TextStyle(
              color: Color(0xFF562B56),
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}