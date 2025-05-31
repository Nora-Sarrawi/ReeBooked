import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rxdart/rxdart.dart';

// ===== MODEL =====
class SwapRequest {
  final String id;
  final String name; // اسم الكتاب (Owner Book Title)
  final String coverUrl; // مسار الصورة (Asset أو URL حسب التطبيق)
  final String requestMessage;
  final String status;
  final String borrowerId;
  final String ownerId;
  final String? borrowerAvatarUrl; // Only need borrower's avatar

  SwapRequest({
    required this.id,
    required this.name,
    required this.coverUrl,
    required this.requestMessage,
    required this.status,
    required this.borrowerId,
    required this.ownerId,
    this.borrowerAvatarUrl,
  });

  factory SwapRequest.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SwapRequest(
      id: doc.id,
      name: data['name'] ?? '',
      coverUrl: data['imagePath'] ?? '',
      requestMessage: data['requestMessage'] ?? '',
      status: data['status'] ?? '',
      borrowerId: data['borrowerId'] ?? '',
      ownerId: data['ownerId'] ?? '',
      borrowerAvatarUrl: data['borrowerAvatarUrl'],
    );
  }
}

// ===== MAIN SCREEN =====
class SwapRequestsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFF562B56)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Swap requests',
            style: TextStyle(
              color: Color(0xFF562B56),
              fontFamily: 'Outfit',
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
          ),
          bottom: TabBar(
            labelColor: Color(0xFF562B56),
            unselectedLabelColor: Colors.grey,
            labelPadding: EdgeInsets.symmetric(vertical: 4),
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(width: 3, color: Color(0xFFCDA2F2)),
              insets: EdgeInsets.symmetric(horizontal: 88.0),
            ),
            tabs: [
              Tab(child: Text('Incoming', style: TextStyle(fontSize: 17))),
              Tab(child: Text('Outgoing', style: TextStyle(fontSize: 17))),
              Tab(child: Text('Archived', style: TextStyle(fontSize: 17))),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            RequestTab(type: 'incoming'),
            RequestTab(type: 'outgoing'),
            RequestTab(type: 'archived'),
          ],
        ),
      ),
    );
  }
}

// ===== REQUEST TAB HANDLER =====
class RequestTab extends StatelessWidget {
  final String type;

  RequestTab({required this.type});

  Stream<List<SwapRequest>> getRequestStream(String userId) {
    final swaps = FirebaseFirestore.instance.collection('swaps');
    final users = FirebaseFirestore.instance.collection('users');

    Future<String> getUserAvatarUrl(String uid) async {
      try {
        final doc = await users.doc(uid).get();
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          return data['avatarUrl'] ?? 'https://i.imgur.com/BoN9kdC.png';
        }
      } catch (e) {
        print('Error fetching user avatar: $e');
      }
      return 'https://i.imgur.com/BoN9kdC.png';
    }

    if (type == 'incoming') {
      return swaps
          .where('ownerId', isEqualTo: userId)
          .where('status', isEqualTo: 'pending')
          .snapshots()
          .asyncMap((snapshot) async {
        final requests = <SwapRequest>[];
        for (var doc in snapshot.docs) {
          final data = doc.data();
          final borrowerAvatarUrl =
              await getUserAvatarUrl(data['borrowerId'] ?? '');

          requests.add(SwapRequest(
            id: doc.id,
            name: data['name'] ?? '',
            coverUrl: data['imagePath'] ?? '',
            requestMessage: data['requestMessage'] ?? '',
            status: data['status'] ?? '',
            borrowerId: data['borrowerId'] ?? '',
            ownerId: data['ownerId'] ?? '',
            borrowerAvatarUrl: borrowerAvatarUrl,
          ));
        }
        return requests;
      });
    } else if (type == 'outgoing') {
      return swaps
          .where('borrowerId', isEqualTo: userId)
          .where('status', isEqualTo: 'pending')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => SwapRequest.fromFirestore(doc))
              .toList());
    } else {
      final ownerStream = swaps
          .where('ownerId', isEqualTo: userId)
          .where('status', whereIn: ['accepted', 'declined']).snapshots();

      final borrowerStream = swaps
          .where('borrowerId', isEqualTo: userId)
          .where('status', whereIn: ['accepted', 'declined']).snapshots();

      return Rx.combineLatest2<QuerySnapshot<Map<String, dynamic>>,
          QuerySnapshot<Map<String, dynamic>>, Future<List<SwapRequest>>>(
        ownerStream,
        borrowerStream,
        (ownerSnap, borrowerSnap) async {
          final combinedDocs = [...ownerSnap.docs, ...borrowerSnap.docs];
          final uniqueDocs = {
            for (var doc in combinedDocs) doc.id: doc,
          }.values.toList();

          final requests = <SwapRequest>[];
          for (var doc in uniqueDocs) {
            final data = doc.data();
            final borrowerAvatarUrl =
                await getUserAvatarUrl(data['borrowerId'] ?? '');

            requests.add(SwapRequest(
              id: doc.id,
              name: data['name'] ?? '',
              coverUrl: data['imagePath'] ?? '',
              requestMessage: data['requestMessage'] ?? '',
              status: data['status'] ?? '',
              borrowerId: data['borrowerId'] ?? '',
              ownerId: data['ownerId'] ?? '',
              borrowerAvatarUrl: borrowerAvatarUrl,
            ));
          }
          return requests;
        },
      ).asyncMap((future) => future);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return StreamBuilder<List<SwapRequest>>(
      stream: getRequestStream(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(color: Color(0xFF562B56)));
        } else if (snapshot.hasError) {
          return Center(child: Text("Error loading $type requests"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No $type requests"));
        }

        final requests = snapshot.data!;

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            return SwapRequestWidget(request: request, type: type);
          },
        );
      },
    );
  }
}

extension CombineLatestExtension<T> on Stream<T> {
  Stream<R> combineLatest<S, R>(
    Stream<S> other,
    R Function(T, S) combiner,
  ) =>
      Rx.combineLatest2(this, other, combiner);
}

// ===== GENERAL REQUEST WIDGET (Shared by all tabs) =====
class SwapRequestWidget extends StatelessWidget {
  final SwapRequest request;
  final String type;

  SwapRequestWidget({required this.request, required this.type});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            print('SwapRequestScreen: InkWell onTap triggered');
            print('SwapRequestScreen: Attempting navigation to requestDetails');
            print('SwapRequestScreen: Request ID: ${request.id}');
            print('SwapRequestScreen: Owner ID: ${request.ownerId}');
            print('SwapRequestScreen: Borrower ID: ${request.borrowerId}');

            context.push('/requests/${request.id}/details', extra: {
              'ownerId': request.ownerId,
              'borrowerId': request.borrowerId,
              'fromRoute': 'requests',
            });
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (type == 'outgoing')
                // Show book cover for outgoing requests
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(
                        request.coverUrl.isNotEmpty
                            ? request.coverUrl
                            : 'https://i.imgur.com/BoN9kdC.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                // Show borrower avatar for incoming and archived requests
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(
                    (request.borrowerAvatarUrl?.isNotEmpty ?? false)
                        ? request.borrowerAvatarUrl!
                        : 'https://i.imgur.com/BoN9kdC.png',
                  ),
                ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF562B56),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      request.requestMessage,
                      style: TextStyle(color: Color(0xFF562B56)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(height: 32),
      ],
    );
  }
}
