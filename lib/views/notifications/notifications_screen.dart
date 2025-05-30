import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rebooked_app/models/notifications_summary.dart';
import 'package:rebooked_app/services/notification_service.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../core/theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final txtStyleTab = TextStyle(
      fontSize: (MediaQuery.of(context).size.width * .05).clamp(16, 20),
      fontWeight: FontWeight.w500,
      color: AppColors.secondary,
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: const Padding(
            padding: EdgeInsets.only(left: 30, top: 8),
            child: Text(
              'Notifications',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: AppColors.secondary,
              ),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(55),
            child: Row(
              children: [
                Expanded(
                  child: TabBar(
                    isScrollable: false,
                    labelPadding: EdgeInsets.zero,
                    labelStyle: txtStyleTab,
                    unselectedLabelStyle: txtStyleTab,
                    indicator: const UnderlineTabIndicator(
                      borderSide: BorderSide(width: 3, color: AppColors.accent),
                      insets: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    tabs: const [
                      Align(
                        alignment: Alignment.center,
                        child: Tab(text: 'All'),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Tab(text: 'Unread'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: const TabBarView(
          physics: BouncingScrollPhysics(),
          children: [
            _SummaryList(onlyUnread: false),
            _SummaryList(onlyUnread: true),
          ],
        ),
      ),
    );
  }
}

class _SummaryList extends StatelessWidget {
  final bool onlyUnread;


  const _SummaryList({super.key, required this.onlyUnread});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SwapNotificationSummary>>(
      stream: NotificationService().streamSummaries(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final list = snap.data
                ?.where((s) => !onlyUnread || s.unreadCount > 0)
                .toList() ??
            [];
        if (list.isEmpty) {
          return const Center(
            child: Text(
              'No notifications.',
              style: TextStyle(color: AppColors.secondary),
            ),
          );
        }
        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
          itemCount: list.length,
          separatorBuilder: (_, __) => const SizedBox(height: 20),
          itemBuilder: (context, i) {
            final s = list[i];
            return ListTile(
              onTap: () => context.go('/swapDetails/${s.swapId}'),
              leading: Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 21,
                    backgroundImage: NetworkImage(s.senderAvatarUrl),
                  ),
                  if (s.unreadCount > 1)
                    Positioned(
                      right: -4,
                      top: -4,
                      child: CircleAvatar(
                        radius: 11,
                        backgroundColor: AppColors.accent,
                        child: Text(
                          '${s.unreadCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              title: Text(
                s.senderName,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(
                s.lastMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(
                timeago.format(s.lastTimestamp),
                style: const TextStyle(color: AppColors.accent),
              ),
            );
          },
        );
      },
    );
  }
}
