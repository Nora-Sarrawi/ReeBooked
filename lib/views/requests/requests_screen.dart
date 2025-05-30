import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../core/theme.dart';
import '../../widgets/primary_button.dart';

class RequestDetailsScreen extends StatefulWidget {
  final String swapId;
  final String ownerId;
  final String borrowerId;

  const RequestDetailsScreen({
    super.key,
    required this.swapId,
    required this.ownerId,
    required this.borrowerId,
  });

  @override
  State<RequestDetailsScreen> createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  Map<String, dynamic>? ownerUserData;
  Map<String, dynamic>? borrowerUserData;
  Map<String, dynamic>? ownerBookData;
  Map<String, dynamic>? borrowerBookData;
  String? status;
  final TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final ownerSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.ownerId)
        .get();
    final borrowerSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.borrowerId)
        .get();
    final swapSnapshot = await FirebaseFirestore.instance
        .collection('swaps')
        .doc(widget.swapId)
        .get();

    final swapData = swapSnapshot.data();

    Map<String, dynamic>? ownerBook;
    Map<String, dynamic>? borrowerBook;

    if (swapData != null) {
      final ownerBookId = swapData['ownerBookId'] as String?;
      final borrowerBookId = swapData['borrowerBookId'] as String?;

      if (ownerBookId != null) {
        final ownerBookSnap = await FirebaseFirestore.instance
            .collection('books')
            .doc(ownerBookId)
            .get();
        ownerBook = ownerBookSnap.data();
      }

      if (borrowerBookId != null) {
        final borrowerBookSnap = await FirebaseFirestore.instance
            .collection('books')
            .doc(borrowerBookId)
            .get();
        borrowerBook = borrowerBookSnap.data();
      }
    }

    setState(() {
      ownerUserData = ownerSnapshot.data();
      borrowerUserData = borrowerSnapshot.data();
      ownerBookData = ownerBook;
      borrowerBookData = borrowerBook;
      status = swapData?['status'];
    });
  }

  Future<void> sendNote() async {
    final message = noteController.text.trim();
    if (message.isEmpty) return;

    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final timestamp = Timestamp.now();

    await FirebaseFirestore.instance
        .collection('swaps')
        .doc(widget.swapId)
        .collection('notes')
        .add({
      'senderId': currentUserId,
      'message': message,
      'createdAt': timestamp,
    });

    noteController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.secondary,
          onPressed: () => context.go('/swap-request'),
        ),
        title: const Text(
          'Swap Details',
          style: TextStyle(color: AppColors.secondary, fontSize: 30),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: false,
        actions: [
          if (status != null)
            Padding(
              padding: const EdgeInsets.only(right: 35),
              child: Container(
                width: 100,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFF7C873),
                  border: Border.all(color: const Color(0xFFF7C873)),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    status!,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFA45800),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildUserProfile(ownerUserData, ownerBookData),
                  _buildUserProfile(borrowerUserData, borrowerBookData),
                ],
              ),
              const SizedBox(height: 60),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Notes:',
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          child: NotesList(
                            swapId: widget.swapId,
                            ownerId: widget.ownerId,
                            borrowerId: widget.borrowerId,
                            ownerUserData: ownerUserData ?? {},
                            borrowerUserData: borrowerUserData ?? {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextField(
                  controller: noteController,
                  decoration: InputDecoration(
                    hintText: 'Add Note ...',
                    hintStyle: TextStyle(color: Colors.grey),
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: AppColors.secondary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: AppColors.secondary, width: 2),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      color: AppColors.secondary,
                      onPressed: sendNote,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    PrimaryButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('swaps')
                            .doc(widget.swapId)
                            .update({'status': 'Accepted'});
                        setState(() {
                          status = 'Accepted';
                        });
                      },
                      text: 'Agree',
                      width: 170,
                      height: 50,
                    ),
                    PrimaryButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('swaps')
                            .doc(widget.swapId)
                            .update({'status': 'Declined'});
                        setState(() {
                          status = 'Declined';
                        });
                      },
                      text: 'Decline',
                      width: 170,
                      height: 50,
                      color: AppColors.accent,
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

  Widget _buildUserProfile(
      Map<String, dynamic>? userData,
      Map<String, dynamic>? bookData,
      ) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: (userData?['avatarUrl'] != null &&
              userData!['avatarUrl'].toString().isNotEmpty)
              ? NetworkImage(userData['avatarUrl'])
              : const NetworkImage('https://i.imgur.com/BoN9kdC.png'),
          radius: 30,
        ),
        const SizedBox(height: 8),
        Text(
          userData?['displayName'] ?? '',
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.secondary , fontSize: 22),
        ),
        const SizedBox(height: 4),
        if (bookData != null && bookData['title'] != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.book, size: 18, color: Colors.black),
              const SizedBox(width: 4),
              Text(
                bookData['title'],
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontStyle: FontStyle.italic),
              ),
            ],
          ),
      ],
    );
  }
}

class NotesList extends StatefulWidget {
  final String swapId;
  final String ownerId;
  final String borrowerId;
  final Map<String, dynamic> ownerUserData;
  final Map<String, dynamic> borrowerUserData;

  const NotesList({
    required this.swapId,
    required this.ownerId,
    required this.borrowerId,
    required this.ownerUserData,
    required this.borrowerUserData,
  });

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('swaps')
          .doc(widget.swapId)
          .collection('notes')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();

        final notes = snapshot.data!.docs;
        _scrollToBottom(); // scroll to bottom when new data comes

        return ListView.separated(
          controller: _scrollController,
          reverse: true,
          itemCount: notes.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          padding: const EdgeInsets.only(bottom: 8),
          itemBuilder: (context, index) {
            final note = notes[index].data()! as Map<String, dynamic>;
            final user = note['senderId'] == widget.ownerId
                ? widget.ownerUserData
                : widget.borrowerUserData;

            return Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.secondary, width: 2.0),
                borderRadius: BorderRadius.circular(25),
                color: Colors.white,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: (user['avatarUrl'] != null &&
                        user['avatarUrl'].toString().isNotEmpty)
                        ? NetworkImage(user['avatarUrl'])
                        : const NetworkImage(
                        'https://i.imgur.com/BoN9kdC.png'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user['displayName'] ?? '',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          note['message'] ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    timeago.format((note['createdAt'] as Timestamp).toDate()),
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}