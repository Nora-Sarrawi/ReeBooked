import 'package:flutter/material.dart';

class EmptyBookList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0, // Aligns content flush to the left
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF562B56)),
              iconSize: 32,
              onPressed: () {},
            ),
            SizedBox(width: 4),
            Text(
              'My Books',
              style: TextStyle(
                color: Color(0xFF562B56),
                fontSize: 32,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            "You don't have any books yet.",
            style: TextStyle(
              color: Color(0xFF562B56),
              fontSize: 18,
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          backgroundColor: Color(0xFFC76767),
          child: Icon(Icons.add, size: 32, color: Colors.white),
          onPressed: () {
            // Handle add book action
          },
          shape: const CircleBorder(), 
        ),
      ),
    );
  }
}
