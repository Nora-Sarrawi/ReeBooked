import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ===== MODEL =====
class SwapRequest {
  final String id;
  final String name;
  final String imagePath;
  final String requestMessage;
  final String status; // 'incoming', 'outgoing', 'archived'

  SwapRequest({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.requestMessage,
    required this.status,
  });

  factory SwapRequest.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SwapRequest(
      id: doc.id,
      name: data['name'] ?? '',
      imagePath: data['imagePath'] ?? '',
      requestMessage: data['requestMessage'] ?? '',
      status: data['status'] ?? '',
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
              onPressed: () {
                Navigator.of(context).pop();
              }),
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('swaps')
          .where('status', isEqualTo: type)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(color: Color(0xFF562B56)));
        } else if (snapshot.hasError) {
          return Center(child: Text("Error loading $type requests"));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No $type requests"));
        }

        final requests = snapshot.data!.docs
            .map((doc) => SwapRequest.fromFirestore(doc))
            .toList();

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            if (type == 'incoming') {
              return IncomingRequestWidget(request: request);
            } else if (type == 'outgoing') {
              return OutgoingRequestWidget(request: request);
            } else {
              return ArchivedRequestWidget(request: request);
            }
          },
        );
      },
    );
  }
}

// ===== INCOMING WIDGET =====
class IncomingRequestWidget extends StatelessWidget {
  final SwapRequest request;

  IncomingRequestWidget({required this.request});

  void acceptRequest(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Accepted request from ${request.name}"),
    ));
  }

  void declineRequest(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Declined request from ${request.name}"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            context.go('/request-details/${request.id}');
          },
          child: Row(
            children: [
              CircleAvatar(
                  radius: 24, backgroundImage: AssetImage(request.imagePath)),
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
                    Text(
                      request.requestMessage,
                      style: TextStyle(color: Color(0xFF562B56)),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => acceptRequest(context),
                          child: Text('Accept'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFCDA2F2),
                            foregroundColor: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => declineRequest(context),
                          child: Text('Decline'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFCDA2F2),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
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

// ===== OUTGOING WIDGET =====
class OutgoingRequestWidget extends StatelessWidget {
  final SwapRequest request;

  OutgoingRequestWidget({required this.request});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
                radius: 24, backgroundImage: AssetImage(request.imagePath)),
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
                  Text(
                    request.requestMessage,
                    style: TextStyle(color: Color(0xFF562B56)),
                  ),
                ],
              ),
            ),
          ],
        ),
        Divider(height: 32),
      ],
    );
  }
}

// ===== ARCHIVED WIDGET =====
class ArchivedRequestWidget extends StatelessWidget {
  final SwapRequest request;

  ArchivedRequestWidget({required this.request});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
                radius: 24, backgroundImage: AssetImage(request.imagePath)),
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
                  Text(
                    request.requestMessage,
                    style: TextStyle(color: Color(0xFF562B56)),
                  ),
                ],
              ),
            ),
          ],
        ),
        Divider(height: 32),
      ],
    );
  }
}
