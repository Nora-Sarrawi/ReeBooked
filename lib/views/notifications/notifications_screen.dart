import 'package:flutter/material.dart';
import '../../core/theme.dart';

/*───────────────────────────────────────────────────────────────────────────*/
/*  MAIN SCREEN                                                             */
/*───────────────────────────────────────────────────────────────────────────*/

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

          /*── tabs (General • Read) ──*/
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
                          child: Tab(text: 'General')),
                      Align(
                          alignment: Alignment.center,
                          child: Tab(text: 'Read')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        /*── tab pages ──*/
        body: const TabBarView(
          physics: BouncingScrollPhysics(),
          children: [
            _NotifList(tab: NotifTab.general),
            _NotifList(tab: NotifTab.read),
          ],
        ),
      ),
    );
  }
}

/*───────────────────────────────────────────────────────────────────────────*/
/*  Dummy model & list                                                      */
/*───────────────────────────────────────────────────────────────────────────*/

enum NotifTab { general, read }

class Notif {
  final String title;
  final String body;
  final String avatar;
  final int badge;
  final String time;

  const Notif({
    required this.title,
    required this.body,
    required this.avatar,
    required this.badge,
    required this.time,
  });
}

const _dummy = [
  Notif(
      title: 'SALE IS LIVE',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit dolor sit amet.',
      avatar: 'assets/images/person1.webp',
      badge: 2,
      time: '1 m ago'),
  Notif(
      title: 'SALE IS LIVE',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit dolor sit amet.',
      avatar: 'assets/images/person2.jpg',
      badge: 10,
      time: '10 h ago'),
  Notif(
      title: 'SALE IS LIVE',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit dolor sit amet.',
      avatar: 'assets/images/person1.webp',
      badge: 2,
      time: '1 m ago'),
  Notif(
      title: 'SALE IS LIVE',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit dolor sit amet.',
      avatar: 'assets/images/person2.jpg',
      badge: 10,
      time: '10 h ago'),
  Notif(
      title: 'SALE IS LIVE',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit dolor sit amet.',
      avatar: 'assets/images/person1.webp',
      badge: 2,
      time: '1 m ago'),
  Notif(
      title: 'SALE IS LIVE',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit dolor sit amet.',
      avatar: 'assets/images/person2.jpg',
      badge: 10,
      time: '10 h ago'),
  Notif(
      title: 'SALE IS LIVE',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit dolor sit amet.',
      avatar: 'assets/images/person1.webp',
      badge: 2,
      time: '1 m ago'),
  Notif(
      title: 'SALE IS LIVE',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit dolor sit amet.',
      avatar: 'assets/images/person2.jpg',
      badge: 10,
      time: '10 h ago'),
  Notif(
      title: 'SALE IS LIVE',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit dolor sit amet.',
      avatar: 'assets/images/person1.webp',
      badge: 2,
      time: '1 m ago'),
  Notif(
      title: 'SALE IS LIVE',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit dolor sit amet.',
      avatar: 'assets/images/person2.jpg',
      badge: 10,
      time: '10 h ago'),
  Notif(
      title: 'SALE IS LIVE',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit dolor sit amet.',
      avatar: 'assets/images/person1.webp',
      badge: 2,
      time: '1 m ago'),
  Notif(
      title: 'SALE IS LIVE',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit dolor sit amet.',
      avatar: 'assets/images/person2.jpg',
      badge: 10,
      time: '10 h ago'),
];

/*───────────────────────────────────────────────────────────────────────────*/
/*  List wrapper                                                            */
/*───────────────────────────────────────────────────────────────────────────*/

class _NotifList extends StatelessWidget {
  const _NotifList({required this.tab});

  final NotifTab tab;

  @override
  Widget build(BuildContext context) {
    final list = _dummy; // later fetch from backend

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 20),
      itemBuilder: (context, i) => _NotifTile(
        data: list[i],
        showBadge: tab == NotifTab.general, // ★ NEW
      ),
    );
  }
}

/*───────────────────────────────────────────────────────────────────────────*/
/*  Single tile                                                             */
/*───────────────────────────────────────────────────────────────────────────*/

class _NotifTile extends StatelessWidget {
  const _NotifTile({
    required this.data,
    required this.showBadge, // ★ NEW
  });

  final Notif data;
  final bool showBadge; // ★ NEW

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AvatarWithBadge(data: data, showBadge: showBadge),
        const SizedBox(width: 12),

        /* text block */
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.title,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                data.body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 10,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        ),

        /* time stamp */
        const SizedBox(width: 8),
        Text(
          data.time,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.accent,
          ),
        ),
      ],
    );
  }
}

/*───────────────────────────────────────────────────────────────────────────*/
/*  Avatar + badge                                                          */
/*───────────────────────────────────────────────────────────────────────────*/

class _AvatarWithBadge extends StatelessWidget {
  const _AvatarWithBadge({
    required this.data,
    required this.showBadge, // ★ NEW
  });

  final Notif data;
  final bool showBadge; // ★ NEW

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: 21,
          backgroundColor: AppColors.secondary,
          child: CircleAvatar(
            radius: 19,
            backgroundImage: AssetImage(data.avatar),
          ),
        ),
        if (showBadge && data.badge > 0) // ★ NEW
          Positioned(
            right: -4,
            top: -4,
            child: CircleAvatar(
              radius: 11,
              backgroundColor: AppColors.accent,
              child: Text(
                '${data.badge}',
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
