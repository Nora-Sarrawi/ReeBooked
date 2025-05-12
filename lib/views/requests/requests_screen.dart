import 'package:flutter/material.dart';

class RequestDetailsScreen extends StatelessWidget {
  const RequestDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon:
                        const Icon(Icons.arrow_back, color: Color(0xFF562B56)),
                    iconSize: 32,
                    onPressed: () {},
                  ),
                  const Text(
                    'Request Details',
                    style: TextStyle(
                      color: Color(0xFF562B56),
                      fontSize: 25,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEDB9C),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Completed',
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
              const SizedBox(height: 24),

              // User info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _userInfo("assets/images/profilePic1.png", "Masa Jaara",
                      "Things we never got over"),
                  _userInfo("assets/images/profilePic2.png", "Nora Sarrawi",
                      "This summer will be different"),
                ],
              ),
              const SizedBox(height: 24),

              const Text(
                'Notes:',
                style: TextStyle(
                  color: Color(0xFF562B56),
                  fontSize: 24,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),

              // Notes
              // Scrollable Notes
              SizedBox(
                height: 275, // Set appropriate height depending on your layout
                child: ListView(
                  children: [
                    _noteCard("assets/images/profilePic1.png", "Masa Jaara",
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit"),
                    _noteCard("assets/images/profilePic2.png", "Nora Sarrawi",
                        "Lorem ipsum dolor sit amet, adipiscing elit"),
                    _noteCard("assets/images/profilePic1.png", "Masa Jaara",
                        "Lorem ipsum dolor sit"),
                    // Add more _noteCard(...) here as needed
                  ],
                ),
              ),

              const SizedBox(height: 50),
              // Add a note field
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Add a note',
                    hintStyle: TextStyle(
                      color: Color(0xFFD9D9D9),
                      fontSize: 24,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF562B56),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10), // Increased padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Agree',
                        style: TextStyle(
                          color: Color(0xFFEEEEEE),
                          fontSize: 20,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD1B2FF),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10), // Increased padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Decline',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _userInfo(String imgPath, String name, String book) {
    return Column(
      children: [
        CircleAvatar(backgroundImage: AssetImage(imgPath), radius: 25),
        const SizedBox(height: 4),
        Text(
          name,
          style: const TextStyle(
            color: Color(0xFF562B56),
            fontSize: 21,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.menu_book, size: 14, color: Color(0xFF562B56)),
            const SizedBox(width: 4),
            Text(
              book,
              style: const TextStyle(
                color: Color(0xFF562B56),
                fontSize: 12.2,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _noteCard(String imgPath, String name, String comment) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF562B56)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(backgroundImage: AssetImage(imgPath), radius: 25),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$name:\n',
                    style: const TextStyle(
                      color: Color(0xFF562B56),
                      fontSize: 21,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: comment,
                    style: const TextStyle(
                      color: Color(0xFF562B56),
                      fontSize: 13.5,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
