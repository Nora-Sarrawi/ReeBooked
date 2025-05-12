import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(MaterialApp(home: SwapRequestsScreen()));
}

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
          leading: Icon(Icons.arrow_back, color: Color(0xFF562B56)),
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
            IncomingTabContent(),
            OutgoingTabContent(),
            ArchivedTabContent(),
          ],
        ),
      ),
    );
  }
}

class IncomingTabContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        IncomingRequest(name: 'Masa Jaara', imagePath: 'assets/images/profilePic2.png'),
        IncomingRequest(name: 'Nora Sarrawi', imagePath: 'assets/images/profilePic1.png'),
        IncomingRequest(name: 'Alaa Qaqa', imagePath: 'assets/images/profilePic3.png'),
        IncomingRequest(name: 'Kareem Abukharma', imagePath: 'assets/images/profilePic4.png'),
      ],
    );
  }
}

class IncomingRequest extends StatelessWidget {
  final String name;
  final String imagePath;

  const IncomingRequest({required this.name, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            context.go('/Request-details');
          },
          borderRadius: BorderRadius.circular(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(radius: 24, backgroundImage: AssetImage(imagePath)),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF562B56),
                      ),
                    ),
                    Text(
                      'Request to exchange your book "Things we never got over" with "This summer will be different."',
                      style: TextStyle(color: Color(0xFF562B56)),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            print("Accepted request from $name");
                          },
                          child: Text('Accept'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFCDA2F2),
                            foregroundColor: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            print("Declined request from $name");
                          },
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

class OutgoingTabContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        OutgoingItem(
          title: 'SALE IS LIVE',
          subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit dolor sit amet, consectetur adipiscing elit.',
          imagePath: 'assets/images/profile1.png',
        ),
        OutgoingItem(
          title: 'SALE IS LIVE',
          subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit dolor sit amet, consectetur adipiscing elit.',
          imagePath: 'assets/images/profile4.png',
        ),
        OutgoingItem(
          title: 'SALE IS LIVE',
          subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit dolor sit amet, consectetur adipiscing elit.',
          imagePath: 'assets/images/profile2.png',
        ),
        OutgoingItem(
          title: 'SALE IS LIVE',
          subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit dolor sit amet, consectetur adipiscing elit.',
          imagePath: 'assets/images/profile3.png',
        ),
      ],
    );
  }
}

class OutgoingItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;

  const OutgoingItem({
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(radius: 24, backgroundImage: AssetImage(imagePath)),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF562B56),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: Color(0xFF562B56)),
                  ),
                  SizedBox(height: 4),
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

class ArchivedTabContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        ArchivedItem(name: 'Masa Jaara', imagePath: 'assets/images/profilePic2.png'),
        ArchivedItem(name: 'Nora Sarrawi', imagePath: 'assets/images/profilePic1.png'),
        ArchivedItem(name: 'Alaa Qaqa', imagePath: 'assets/images/profilePic3.png'),
        ArchivedItem(name: 'Kareem Abukharma', imagePath: 'assets/images/profilePic4.png'),
      ],
    );
  }
}

class ArchivedItem extends StatelessWidget {
  final String name;
  final String imagePath;

  const ArchivedItem({
    required this.name,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(radius: 24, backgroundImage: AssetImage(imagePath)),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF562B56),
                    ),
                  ),
                  Text(
                    'Request to exchange your book "Things we never got over" with "This summer will be different."',
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