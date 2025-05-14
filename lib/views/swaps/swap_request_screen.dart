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

  factory SwapRequest.fromJson(Map<String, dynamic> json) {
    return SwapRequest(
      id: json['id'],
      name: json['name'],
      imagePath: json['imagePath'],
      requestMessage: json['requestMessage'],
      status: json['status'],
    );
  }
}

// ===== MOCK BACKEND SERVICE =====
class SwapRequestService {
  Future<List<SwapRequest>> fetchRequests(String type) async {
    await Future.delayed(Duration(seconds: 1)); // simulate network delay

    final List<Map<String, dynamic>> mockData = [
      {
        "id": "1",
        "name": "Masa Jaara",
        "imagePath": "assets/images/profilePic2.png",
        "requestMessage":
            'Request to exchange your book "Things we never got over" with "This summer will be different."',
        "status": "incoming"
      },
      {
        "id": "2",
        "name": "Nora Sarrawi",
        "imagePath": "assets/images/profilePic1.png",
        "requestMessage":
            'Request to exchange your book "Atomic Habits" with "The Psychology of Money."',
        "status": "incoming"
      },
      {
        "id": "3",
        "name": "Alaa Qaqa",
        "imagePath": "assets/images/profilePic3.png",
        "requestMessage":
            'You sent a swap request for "Verity" in exchange for "The Midnight Library."',
        "status": "outgoing"
      },
      {
        "id": "4",
        "name": "Kareem Abukharma",
        "imagePath": "assets/images/profilePic4.png",
        "requestMessage":
            'You sent a swap request for "It Ends With Us" in exchange for "The Alchemist."',
        "status": "outgoing"
      },
      {
        "id": "5",
        "name": "Dana Khaled",
        "imagePath": "assets/images/profilePic1.png",
        "requestMessage":
            'Swap request completed for "The Seven Husbands of Evelyn Hugo" and "Ugly Love".',
        "status": "archived"
      },
      {
        "id": "6",
        "name": "Layla Hamdan",
        "imagePath": "assets/images/profilePic2.png",
        "requestMessage":
            'Swap declined: "Where the Crawdads Sing" for "A Good Girl’s Guide to Murder".',
        "status": "archived"
      },
    ];

    return mockData
        .where((item) => item['status'] == type)
        .map((json) => SwapRequest.fromJson(json))
        .toList();
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
              onPressed: () {}),
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
  final service = SwapRequestService();

  RequestTab({required this.type});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SwapRequest>>(
      future: service.fetchRequests(type),
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
            context.go('/request-details');
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