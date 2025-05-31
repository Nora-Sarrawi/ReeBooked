import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rebooked_app/models/notifications_summary.dart';
import 'package:rebooked_app/services/notification_service.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return const Center(child: Text('Not logged in'));

    return Container(
      width: 414,
      height: 874,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(44),
      ),
      child: DefaultTabController(
        length: 2,
        child: Stack(
          children: [
            // Top status bar background
            Positioned(
              left: 6,
              top: 0,
              child: Container(
                width: 402,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.75),
                  border: Border(
                    bottom: BorderSide(
                      width: 0.33,
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ),

            // Main content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                // Notifications title
                Padding(
                  padding: const EdgeInsets.only(left: 35),
                  child: Text(
                    'Notifications',
                    style: TextStyle(
                      color: const Color(0xFF562B56),
                      fontSize: 24,
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                // Custom tab bar
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TabBar(
                    labelStyle: TextStyle(
                      color: const Color(0xFF562B56),
                      fontSize: 20,
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w500,
                    ),
                    unselectedLabelStyle: TextStyle(
                      color: const Color(0xFF562B56).withOpacity(0.5),
                      fontSize: 20,
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w500,
                    ),
                    labelColor: const Color(0xFF562B56),
                    unselectedLabelColor:
                        const Color(0xFF562B56).withOpacity(0.5),
                    indicatorColor: const Color(0xFFCDA2F2),
                    indicatorWeight: 3,
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: const [
                      Tab(text: 'All'),
                      Tab(text: 'Unread'),
                    ],
                  ),
                ),
                const SizedBox(height: 0),
                // Notifications list
                Expanded(
                  child: TabBarView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _SummaryList(userId: currentUser.uid, onlyUnread: false),
                      _SummaryList(userId: currentUser.uid, onlyUnread: true),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryList extends StatelessWidget {
  final String userId;
  final bool onlyUnread;

  const _SummaryList({
    required this.userId,
    required this.onlyUnread,
  });

  Future<void> _navigateToRequestDetails(
      BuildContext context, String swapId) async {
    try {
      print('_navigateToRequestDetails called with swapId: $swapId');

      final swapDoc = await FirebaseFirestore.instance
          .collection('swaps')
          .doc(swapId)
          .get();

      if (!swapDoc.exists) {
        print('Error: Swap not found');
        return;
      }

      final swapData = swapDoc.data()!;
      final ownerId = swapData['ownerId'] as String;
      final borrowerId = swapData['borrowerId'] as String;

      // Mark notifications as read before navigation
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        print('Marking notifications as read for user: ${currentUser.uid}');
        await NotificationService()
            .markNotificationsAsRead(swapId, currentUser.uid);
      }

      if (context.mounted) {
        print('NotificationsScreen: Attempting navigation to requestDetails');
        print('NotificationsScreen: Swap ID: $swapId');
        print('NotificationsScreen: Owner ID: $ownerId');
        print('NotificationsScreen: Borrower ID: $borrowerId');

        context.push('/requests/$swapId/details', extra: {
          'ownerId': ownerId,
          'borrowerId': borrowerId,
          'fromRoute': 'notifications',
        });
      }
    } catch (e) {
      print('Error navigating to request details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SwapNotificationSummary>>(
      stream: NotificationService().streamSummaries(userId),
      builder: (context, snap) {
        print('DEBUG - NotificationsList build:');
        print('Connection state: ${snap.connectionState}');
        print('Has error: ${snap.hasError}');
        if (snap.hasError) print('Error: ${snap.error}');
        print('Has data: ${snap.hasData}');
        if (snap.hasData) print('Data length: ${snap.data!.length}');

        if (snap.hasError) {
          return Center(child: Text('Error: ${snap.error}'));
        }

        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final allNotifications = snap.data ?? [];
        final list = onlyUnread
            ? allNotifications.where((s) => s.unreadCount > 0).toList()
            : allNotifications;

        print('DEBUG - Filtered notifications:');
        print('All notifications: ${allNotifications.length}');
        print('Filtered list: ${list.length}');
        if (list.isNotEmpty) {
          print('First notification:');
          print('Swap ID: ${list[0].swapId}');
          print('Sender: ${list[0].senderName}');
          print('Message: ${list[0].lastMessage}');
        }

        if (list.isEmpty) {
          return Center(
            child: Text(
              onlyUnread ? 'No unread notifications' : 'No notifications',
              style: const TextStyle(
                color: Color(0xFF562B56),
                fontSize: 16,
                fontFamily: 'Outfit',
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: list.length,
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          itemBuilder: (context, i) {
            final summary = list[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: InkWell(
                onTap: () => _navigateToRequestDetails(context, summary.swapId),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar with notification count
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: ShapeDecoration(
                            image: DecorationImage(
                              image: (summary.senderAvatarUrl.isNotEmpty)
                                  ? NetworkImage(summary.senderAvatarUrl)
                                  : const NetworkImage(
                                      'https://i.imgur.com/BoN9kdC.png'),
                              fit: BoxFit.cover,
                            ),
                            shape: OvalBorder(
                              side: BorderSide(
                                width: 2,
                                color: const Color(0xFF562B56),
                              ),
                            ),
                          ),
                        ),
                        if (summary.unreadCount > 0)
                          Positioned(
                            right: -5,
                            top: -5,
                            child: Container(
                              width: 19,
                              height: 19,
                              decoration: const ShapeDecoration(
                                color: Color(0xFFCDA2F2),
                                shape: OvalBorder(),
                              ),
                              child: Center(
                                child: Text(
                                  '${summary.unreadCount}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontFamily: 'Outfit',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    // Notification content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            summary.senderName,
                            style: TextStyle(
                              color: const Color(0xFF562B56),
                              fontSize: 14,
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            summary.lastMessage,
                            style: TextStyle(
                              color: const Color(0xFF562B56),
                              fontSize: 13,
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Timestamp
                    Text(
                      timeago.format(summary.lastTimestamp),
                      style: const TextStyle(
                        color: Color(0xFFCDA2F2),
                        fontSize: 12,
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
