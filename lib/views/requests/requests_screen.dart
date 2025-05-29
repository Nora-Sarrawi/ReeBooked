import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Models
class User {
  final String name;
  final String imageUrl;
  final String bookTitle;

  User({required this.name, required this.imageUrl, required this.bookTitle});

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json['name'],
        imageUrl: json['imageUrl'],
        bookTitle: json['bookTitle'],
      );
}

class Note {
  final String userName;
  final String userImage;
  final String text;

  Note({required this.userName, required this.userImage, required this.text});

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        userName: json['userName'],
        userImage: json['userImage'],
        text: json['text'],
      );
}

class RequestDetails {
  final User fromUser;
  final User toUser;
  final String status;
  final List<Note> notes;

  RequestDetails({
    required this.fromUser,
    required this.toUser,
    required this.status,
    required this.notes,
  });

  factory RequestDetails.fromJson(Map<String, dynamic> json) => RequestDetails(
        fromUser: User.fromJson(json['fromUser']),
        toUser: User.fromJson(json['toUser']),
        status: json['status'],
        notes: (json['notes'] as List).map((n) => Note.fromJson(n)).toList(),
      );
}

// Simulated Service (replace with real backend)
class RequestService {
  static Future<RequestDetails> fetchRequestDetails() async {
    await Future.delayed(const Duration(seconds: 1));
    return RequestDetails(
      fromUser: User(
        name: "Masa Jaara",
        imageUrl: "assets/images/profilePic1.png",
        bookTitle: "Things we never got over",
      ),
      toUser: User(
        name: "Nora Sarrawi",
        imageUrl: "assets/images/profilePic2.png",
        bookTitle: "This summer will be different",
      ),
      status: "Pending",
      notes: [
        Note(
            userName: "Masa Jaara",
            userImage: "assets/images/profilePic1.png",
            text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit"),
        Note(
            userName: "Nora Sarrawi",
            userImage: "assets/images/profilePic2.png",
            text: "Lorem ipsum dolor sit amet, adipiscing elit"),
      ],
    );
  }

  static Future<void> addNote(String text) async {
    await Future.delayed(const Duration(seconds: 1));
    // Push note to backend
  }

  static Future<void> respondToRequest(bool agree) async {
    await Future.delayed(const Duration(seconds: 1));
    // Send response to backend
  }
}

// UI Screen
class RequestDetailsScreen extends StatefulWidget {
  const RequestDetailsScreen({super.key});

  @override
  State<RequestDetailsScreen> createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  late Future<RequestDetails> _requestFuture;
  final TextEditingController _noteController = TextEditingController();
  bool _isLoading = false;
  bool _canSubmit = true;

  @override
  void initState() {
    super.initState();
    _requestFuture = RequestService.fetchRequestDetails();
  }

  void _submitNote() async {
    final noteText = _noteController.text.trim();
    if (noteText.isEmpty || noteText.length > 300 || !_canSubmit) return;

    setState(() {
      _isLoading = true;
      _canSubmit = false;
    });

    await RequestService.addNote(noteText);
    _noteController.clear();

    setState(() {
      _requestFuture = RequestService.fetchRequestDetails();
      _isLoading = false;
    });

    // Cooldown logic: re-enable after 1 minute
    Timer(const Duration(minutes: 1), () {
      if (mounted) {
        setState(() {
          _canSubmit = true;
        });
      }
    });
  }

  void _respond(bool agree) async {
    setState(() => _isLoading = true);
    await RequestService.respondToRequest(agree);
    setState(() => _isLoading = false);
    context.go('/swap-request');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder<RequestDetails>(
            future: _requestFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text('No data found.'));
              }

              final data = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: Color(0xFF562B56)),
                        iconSize: 32,
                        onPressed: () => context.go('/swap-request'),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEDB9C),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          data.status,
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
                  const SizedBox(height: 24),

                  // Users
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _userInfo(data.fromUser),
                      _userInfo(data.toUser),
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

                  // Notes List
                  SizedBox(
                    height: 250,
                    child: ListView(
                      children: data.notes
                          .map(
                              (n) => _noteCard(n.userImage, n.userName, n.text))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Note input
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _noteController,
                      maxLength: 300,
                      onSubmitted: (_) => _submitNote(),
                      decoration: const InputDecoration(
                        counterText: '',
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
                  const SizedBox(height: 8),

                  // Submit Button (instead of auto-submit for clarity)
                  ElevatedButton(
                    onPressed: _canSubmit && !_isLoading ? _submitNote : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF562B56),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Submit Note',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Agree / Decline
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _respond(true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF562B56),
                              padding: const EdgeInsets.symmetric(vertical: 10),
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
                            onPressed: () => _respond(false),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD1B2FF),
                              padding: const EdgeInsets.symmetric(vertical: 10),
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
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _userInfo(User user) {
    return Column(
      children: [
        CircleAvatar(backgroundImage: AssetImage(user.imageUrl), radius: 25),
        const SizedBox(height: 4),
        Text(
          user.name,
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
              user.bookTitle,
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
