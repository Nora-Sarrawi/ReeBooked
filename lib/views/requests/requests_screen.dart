import 'package:flutter/material.dart';

class RequestsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Requests Screen'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Text(
          'Requests Screen',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
    );
  }
}
