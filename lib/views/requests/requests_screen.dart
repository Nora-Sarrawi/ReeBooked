import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../core/theme.dart';
import '../../widgets/primary_button.dart';
import '../../services/notification_service.dart';

class RequestDetailsScreen extends StatefulWidget {
  final String swapId;
  final String ownerId;
  final String borrowerId;
  final String? fromRoute;

  const RequestDetailsScreen({
    super.key,
    required this.swapId,
    required this.ownerId,
    required this.borrowerId,
    this.fromRoute,
  });

  @override
  State<RequestDetailsScreen> createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  Map<String, dynamic>? ownerUserData;
  Map<String, dynamic>? borrowerUserData;
  Map<String, dynamic>? ownerBookData;
  Map<String, dynamic>? borrowerBookData;
  final TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final ownerSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.ownerId)
          .get();
      final borrowerSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.borrowerId)
          .get();

      Map<String, dynamic>? ownerBook;
      Map<String, dynamic>? borrowerBook;

      final swapSnapshot = await FirebaseFirestore.instance
          .collection('swaps')
          .doc(widget.swapId)
          .get();
      final swapData = swapSnapshot.data();

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

      if (mounted) {
        setState(() {
          ownerUserData = ownerSnapshot.data();
          borrowerUserData = borrowerSnapshot.data();
          ownerBookData = ownerBook;
          borrowerBookData = borrowerBook;
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> updateStatus(String newStatus) async {
    try {
      print('Attempting to update status to: $newStatus');
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      // First verify current status
      final currentDoc = await FirebaseFirestore.instance
          .collection('swaps')
          .doc(widget.swapId)
          .get();

      print('Current document data: ${currentDoc.data()}');

      // Update the status
      await FirebaseFirestore.instance
          .collection('swaps')
          .doc(widget.swapId)
          .update({
        'status': newStatus.toLowerCase(),
      });

      // Verify the update
      final updatedDoc = await FirebaseFirestore.instance
          .collection('swaps')
          .doc(widget.swapId)
          .get();

      print('Updated document data: ${updatedDoc.data()}');
      print('Status update completed');
    } catch (e) {
      print('Error updating status: $e');
    }
  }

  Future<void> sendNote() async {
    final message = noteController.text.trim();
    if (message.isEmpty) return;

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    print('Sending note...');
    print('Current User ID: ${currentUser.uid}');
    print('Owner ID: ${widget.ownerId}');
    print('Borrower ID: ${widget.borrowerId}');

    final timestamp = Timestamp.now();
    final swapRef =
        FirebaseFirestore.instance.collection('swaps').doc(widget.swapId);
    final notificationService = NotificationService();

    try {
      // Get the current user's data from the already loaded owner/borrower data
      final isOwner = currentUser.uid == widget.ownerId;
      final userData = isOwner ? ownerUserData : borrowerUserData;

      if (userData == null) {
        print('Error: User data not found');
        return;
      }

      print('DEBUG - Current user data:');
      print(userData);

      // Add the note
      final noteRef = await swapRef.collection('notes').add({
        'senderId': currentUser.uid,
        'message': message,
        'createdAt': timestamp,
      });

      // Create notification for the recipient
      final recipientId = isOwner ? widget.borrowerId : widget.ownerId;

      // Get the recipient's data
      final recipientData = isOwner ? borrowerUserData : ownerUserData;
      if (recipientData == null) {
        print('Error: Recipient data not found');
        return;
      }

      print('DEBUG - Recipient data:');
      print(recipientData);

      await notificationService.createNotification(
        swapId: widget.swapId,
        senderId: currentUser.uid,
        senderName: userData['displayName'] ?? 'Unknown User',
        senderAvatarUrl: userData['avatarUrl'] ?? '',
        recipientId: recipientId,
        text: message,
      );

      noteController.clear();
    } catch (noteError) {
      print('Error creating note: $noteError');
      throw noteError; // Rethrow if note creation fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('swaps')
          .doc(widget.swapId)
          .snapshots(),
      builder: (context, snapshot) {
        String? currentStatus;
        if (snapshot.hasData) {
          final swapData = snapshot.data!.data() as Map<String, dynamic>?;
          currentStatus = swapData?['status'] as String?;
          print('StreamBuilder data update:');
          print('Full swap data: $swapData');
          print('Current status: $currentStatus');
        } else if (snapshot.hasError) {
          print('StreamBuilder error: ${snapshot.error}');
        } else {
          print('StreamBuilder waiting for data');
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: AppColors.secondary,
              onPressed: () {
                Navigator.of(context).pop();
              },
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
              if (currentStatus != null)
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
                        currentStatus.toUpperCase(),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextField(
                      controller: noteController,
                      decoration: InputDecoration(
                        hintText: 'Add Note ...',
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: AppColors.secondary),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide:
                              BorderSide(color: AppColors.secondary, width: 2),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send),
                          color: AppColors.secondary,
                          onPressed: sendNote,
                        ),
                      ),
                    ),
                  ),
                  if (currentStatus?.toLowerCase() == 'pending')
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          PrimaryButton(
                            onPressed: () => updateStatus('accepted'),
                            text: 'Agree',
                            width: 170,
                            height: 50,
                          ),
                          PrimaryButton(
                            onPressed: () => updateStatus('declined'),
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
      },
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
              : const NetworkImage(
                  'https://i.pinimg.com/736x/3c/ae/07/3cae079ca0b9e55ec6bfc1b358c9b1e2.jpg'),
          radius: 30,
        ),
        const SizedBox(height: 8),
        Text(
          userData?['displayName'] ?? '',
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
              fontSize: 22),
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

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      // Load more if needed in the future
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('swaps')
          .doc(widget.swapId)
          .collection('notes')
          .orderBy('createdAt', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final notes = snapshot.data?.docs ?? [];

        if (notes.isEmpty) {
          return const Center(child: Text('No notes yet'));
        }

        // Scroll to bottom when new messages arrive
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

        return ListView.separated(
          controller: _scrollController,
          itemCount: notes.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          padding: const EdgeInsets.symmetric(vertical: 8),
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
                        : const NetworkImage('https://i.imgur.com/BoN9kdC.png'),
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
