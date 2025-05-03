import 'package:flutter/material.dart';
import '../books/add_book_screen.dart';
import '../home/home_screen.dart';
import '../my_books/my_books_screen.dart';
import '../requests/requests_screen.dart';
import '../notifications/notifications_screen.dart';
import '../profile/profile_screen.dart';
import '../../core/theme.dart';

class ShellScaffold extends StatefulWidget {
  const ShellScaffold({super.key});
  @override
  State<ShellScaffold> createState() => _ShellScaffoldState();
}

class _ShellScaffoldState extends State<ShellScaffold> {
  int _index = 0;
  final _navKeys = List.generate(5, (_) => GlobalKey<NavigatorState>());

  final _tabs = [
    HomeScreen(),
    RequestsScreen(),
    MyBooksScreen(),
    NotificationsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
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
        // inside ShellScaffold.build  (replace only the bottomNavigationBar section)

        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
          child: SizedBox(
            // ← give it the height you want
            height: 90, // 56 (default) → any value e.g. 64, 80
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
              items: const [
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
                  activeIcon: Icon(Icons.menu_book, color: AppColors.secondary),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications_outlined),
                  activeIcon:
                      Icon(Icons.notifications, color: AppColors.secondary),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person, color: AppColors.secondary),
                  label: '',
                )
              ],
            ),
          ),
        ),

            floatingActionButton: _index == 0
    ? FloatingActionButton(
    backgroundColor: AppColors.primary,
    onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const AddBookScreen()),
    );
    },
    shape: const CircleBorder(),
    child: const Icon(Icons.add),
    )
        : null,

    ),
    );
  }
}
