import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class SwapRequest {
  final String id;
  final String borrowerId;
  final String ownerId;
  final String borrowerBookId;
  final String ownerBookId;
  final String imagePath;
  final String requestMessage;
  final String status;

  SwapRequest({
    required this.id,
    required this.borrowerId,
    required this.ownerId,
    required this.borrowerBookId,
    required this.ownerBookId,
    required this.imagePath,
    required this.requestMessage,
    required this.status,
  });

  factory SwapRequest.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SwapRequest(
      id: doc.id,
      borrowerId: data['borrowerId'],
      ownerId: data['ownerId'],
      borrowerBookId: data['borrowerBookId'],
      ownerBookId: data['ownerBookId'],
      imagePath: data['imagePath'],
      requestMessage: data['requestMessage'],
      status: data['status'],
    );
  }
}


class RequestDetailsScreen extends StatefulWidget {
  final String requestId;

  const RequestDetailsScreen({super.key, required this.requestId});

  @override
  State<RequestDetailsScreen> createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  bool _isLoading = false;
  late Future<SwapRequest> _requestFuture;

  @override
  void initState() {
    super.initState();
    _requestFuture = fetchRequest();
  }

  Future<SwapRequest> fetchRequest() async {
    final doc = await FirebaseFirestore.instance
        .collection('swaps')
        .doc(widget.requestId)
        .get();
    return SwapRequest.fromFirestore(doc);
  }

  Future<void> updateStatus(String newStatus) async {
    setState(() => _isLoading = true);
    await FirebaseFirestore.instance
        .collection('swaps')
        .doc(widget.requestId)
        .update({'status': newStatus});
    setState(() {
      _isLoading = false;
      _requestFuture = fetchRequest();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<SwapRequest>(
        future: _requestFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || _isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Request not found'));
          }

          final data = snapshot.data!;
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Color(0xFF562B56)),
                        onPressed: () => context.go('/swap-request'),
                      ),
                      const Text(
                        'Request Details',
                        style: TextStyle(
                          color: Color(0xFF562B56),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEDB9C),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          data.status,
                          style: const TextStyle(
                            color: Color(0xFFA35800),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),


                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage(data.imagePath),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          data.borrowerId,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF562B56),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    "Message:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF562B56),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data.requestMessage,
                    style: const TextStyle(fontSize: 16),
                  ),

                  const Spacer(),


                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => updateStatus("Reserved"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF562B56),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text("Agree", style: TextStyle(fontSize: 18)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => updateStatus("Available"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD1B2FF),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text("Decline", style: TextStyle(fontSize: 18)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}