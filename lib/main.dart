import 'package:flutter/material.dart';
import './views/my_books/my_books_screen.dart';
import './views/requests/requests_screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RequestDetailsScreen(),
    ),
  );
}
