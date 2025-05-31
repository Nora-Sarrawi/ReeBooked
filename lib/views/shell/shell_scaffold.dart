import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rebooked_app/views/swaps/swap_request_screen.dart';
import '../books/add_book_screen.dart';
import '../home/home_screen.dart';
import '../my_books/my_books_screen.dart';
import '../requests/requests_screen.dart';
import '../notifications/notifications_screen.dart';
import '../profile/profile_screen.dart';
import '../../core/theme.dart';
import '../swaps/swap_request_screen.dart';
import 'package:rebooked_app/services/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShellScaffold extends StatefulWidget {
  const ShellScaffold({super.key, required Widget child});
  @override
  State<ShellScaffold> createState() => _ShellScaffoldState();
}

class _ShellScaffoldState extends State<ShellScaffold> {
  int _index = 0;
  final _navKeys = List.generate(5, (_) => GlobalKey<NavigatorState>());

  final _tabs = [
    HomeScreen(),
    SwapRequestsScreen(),
    MyBooksScreen(),
    NotificationsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return WillPopScope(
      onWillPop: () async => !await _navKeys[_index].currentState!.maybePop(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: IndexedStack(
          index: _index,
          children: List.generate(
            _tabs.length,
            (i) => Navigator(
              key: _navKeys[i],
              onGenerateRoute: (s) => MaterialPageRoute(
                builder: (_) => _tabs[i],
                settings: s,
              ),
            ),
          ),
        ),
        bottomNavigationBar: StreamBuilder<List<dynamic>>(
          stream: currentUser != null
              ? NotificationService().streamSummaries(currentUser.uid)
              : Stream.value([]),
          builder: (context, snapshot) {
            final hasUnread = snapshot.hasData &&
                snapshot.data!.any((summary) => summary.unreadCount > 0);

            return Theme(
              data: Theme.of(context).copyWith(
                splashFactory: NoSplash.splashFactory,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
              ),
              child: SizedBox(
                height: 90,
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  currentIndex: _index,
                  selectedIconTheme: const IconThemeData(size: 30),
                  unselectedIconTheme: const IconThemeData(size: 24),
                  selectedItemColor: AppColors.secondary,
                  unselectedItemColor: AppColors.secondary.withOpacity(.5),
                  onTap: (i) => setState(() => _index = i),
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      activeIcon: Icon(Icons.home, color: AppColors.secondary),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.swap_horiz_outlined),
                      activeIcon:
                          Icon(Icons.swap_horiz, color: AppColors.secondary),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.menu_book_outlined),
                      activeIcon:
                          Icon(Icons.menu_book, color: AppColors.secondary),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Stack(
                        children: [
                          Icon(Icons.notifications_outlined),
                          if (hasUnread)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFCDA2F2),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                      activeIcon: Stack(
                        children: [
                          Icon(Icons.notifications),
                          if (hasUnread)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFCDA2F2),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_outline),
                      activeIcon:
                          Icon(Icons.person, color: AppColors.secondary),
                      label: '',
                    )
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: _index == 0
            ? FloatingActionButton(
                backgroundColor: AppColors.primary,
                onPressed: () {
                  context.go('/add-book');
                },
                shape: const CircleBorder(),
                child: const Icon(Icons.add, color: Colors.white),
              )
            : null,
      ),
    );
  }
}
