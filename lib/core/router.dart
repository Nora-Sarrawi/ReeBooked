import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rebooked_app/providers/swap_provider.dart';
import 'package:rebooked_app/views/auth/login_screen.dart';
import 'package:rebooked_app/views/auth/reset_password/reset_password_screen1.dart';
import 'package:rebooked_app/views/auth/signup_screen.dart';
import 'package:rebooked_app/views/books/add_book_screen.dart';
import 'package:rebooked_app/views/books/book_detail_screen.dart';
import 'package:rebooked_app/views/home/home_screen.dart';
import 'package:rebooked_app/views/settings/settings_screen.dart';
import 'package:rebooked_app/views/start_page/start_page.dart';
import 'package:rebooked_app/views/swaps/swap_request_screen.dart';
import 'package:rebooked_app/views/my_books/my_books_screen.dart';
import 'package:rebooked_app/views/notifications/notifications_screen.dart';
import 'package:rebooked_app/views/profile/profile_screen.dart';
import 'package:rebooked_app/views/shell/shell_scaffold.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/start',
  routes: [
    // This ShellRoute wraps all five “tab” routes in your bottom bar
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        // The child here will be whichever tab’s page you’re on.
        return ShellScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) =>
              NoTransitionPage(child: const HomeScreen()),
        ),
        GoRoute(
          path: '/requests',
          pageBuilder: (context, state) =>
              NoTransitionPage(child: SwapRequestsScreen()),
        ),
        GoRoute(
          path: '/my-books',
          pageBuilder: (context, state) =>
              NoTransitionPage(child: const MyBooksScreen()),
        ),
        GoRoute(
          path: '/notifications',
          pageBuilder: (context, state) =>
              NoTransitionPage(child: const NotificationsScreen()),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) =>
              NoTransitionPage(child: ProfileScreen()),
          routes: [
            GoRoute(
              path:
                  'settings', // NOTE: this makes full path = /profile/settings
              builder: (context, state) => SettingsPage(),
            ),
          ],
        ),
      ],
    ),

    // Any other full‐screen static pages come outside the shell:
    GoRoute(path: '/start', builder: (_, __) => const StartScreen()),
    GoRoute(path: '/settings', builder: (_, __) => SettingsPage()),
    GoRoute(path: '/add-book', builder: (_, __) => AddBookScreen()),
    GoRoute(path: '/confirm', builder: (_, __) => ConfirmSwapPage()),
    GoRoute(path: '/bookDetails', builder: (_, __) => BookDetailsScreen()),
    GoRoute(
        path: '/forgot-password', builder: (_, __) => ResetPasswordScreen1()),
    GoRoute(path: '/Login', builder: (_, __) => LoginPage()),
    GoRoute(path: '/Signup', builder: (_, __) => CreateAccountScreen()),
    
  ],
);
