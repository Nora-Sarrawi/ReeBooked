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

          /*────────────  Tab row  (General ——— Read)  ────────────*/
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(55),
            child: Row(
              children: [
                Expanded(
                  child: TabBar(
                    isScrollable: false, // full-width bar
                    labelPadding: EdgeInsets.zero,
                    labelStyle: txtStyleTab,
                    unselectedLabelStyle: txtStyleTab,
                    indicator: UnderlineTabIndicator(
                      borderSide:
                          const BorderSide(width: 3, color: AppColors.accent),
                      // make the purple line 24 px longer on both ends
                      insets: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    indicatorColor: AppColors.primary,
                    tabs: const [
                      Align(
                        alignment: Alignment.center,
                        child: Tab(text: 'General'),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Tab(text: 'Read'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        /*────────────  Pages for each tab  ────────────*/
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
/*  Dummy model & data                         */
/*───────────────────────────────────────────────────────────────────────────*/

enum NotifTab { general, read }

class Notif {
  final String title;
  final String body;
  final String avatar; // asset path or URL
  final int badge; // red-dot number
  final String time; // “1 m ago”

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
/*  ListView wrapper for each tab                                           */
/*───────────────────────────────────────────────────────────────────────────*/

class _NotifList extends StatelessWidget {
  const _NotifList({required this.tab});

  final NotifTab tab;

  @override
  Widget build(BuildContext context) {
    // In a real app you’d fetch the filtered list according to `tab`
    final list = _dummy;

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 20),
      itemBuilder: (context, i) => _NotifTile(data: list[i]),
    );
  }
}

/*───────────────────────────────────────────────────────────────────────────*/
/*  Single notification tile                                                */
/*───────────────────────────────────────────────────────────────────────────*/

class _NotifTile extends StatelessWidget {
  const _NotifTile({required this.data});

  final Notif data;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AvatarWithBadge(data: data),
        const SizedBox(width: 12),

        /*── text block ──*/
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

        /*── time stamp on the far right ──*/
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
/*  Avatar with numeric badge                                               */
/*───────────────────────────────────────────────────────────────────────────*/

class _AvatarWithBadge extends StatelessWidget {
  const _AvatarWithBadge({required this.data});

  final Notif data;

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
        if (data.badge > 0)
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
