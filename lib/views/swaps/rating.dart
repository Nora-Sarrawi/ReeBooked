import 'package:flutter/material.dart';

class ExchangeExperienceCard extends StatefulWidget {
  const ExchangeExperienceCard({Key? key}) : super(key: key);

  @override
  State<ExchangeExperienceCard> createState() => _ExchangeExperienceCardState();
}

class _ExchangeExperienceCardState extends State<ExchangeExperienceCard> {
  int _selectedRating = 0;
  int _hoveredRating = 0;

  Widget _buildStar(int index) {
    final isHovered = index <= _hoveredRating;
    final isSelected = index <= _selectedRating;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredRating = index),
      onExit: (_) => setState(() => _hoveredRating = 0),
      child: GestureDetector(
        onTap: () => setState(() => _selectedRating = index),
        child: AnimatedScale(
          scale: isHovered ? 1.2 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: Icon(
            Icons.star,
            size: 32,
            color: isSelected ? Colors.amber : Colors.grey.shade400,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color (0xFFF2E9DC), // Set full background to white
      body: Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white, // Card background also white
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'how was your exchange experience?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF562B56),
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                  decoration: TextDecoration.none, // Ensure no underline
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) => _buildStar(index + 1)),
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC76767),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 106, vertical: 15),
                  elevation: 2,
                ),
                onPressed: () {},
                child: const Text(
                  'Confirm',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                    fontSize: 16,
                    decoration: TextDecoration.none, // Confirm text also clean
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}