import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:rebooked_app/providers/swap_provider.dart';
import 'package:rebooked_app/views/auth/login_screen.dart';
import 'package:rebooked_app/views/auth/reset_password/password_screen1.dart';
import 'package:rebooked_app/views/auth/reset_password/password_screen1.dart';
import 'package:rebooked_app/views/auth/signup_screen.dart';

import 'package:rebooked_app/views/books/add_book_screen.dart';
import 'package:rebooked_app/views/books/book_detail_screen.dart';
import 'package:rebooked_app/views/home/home_screen.dart';
import 'package:rebooked_app/views/requests/requests_screen.dart';
import 'package:rebooked_app/views/settings/settings_screen.dart';
import 'package:rebooked_app/views/start_page/start_page.dart';
import 'package:rebooked_app/views/swaps/confirm_swap.dart';
import 'package:rebooked_app/views/swaps/swap_request_screen.dart';
import 'package:rebooked_app/views/my_books/my_books_screen.dart';
import 'package:rebooked_app/views/notifications/notifications_screen.dart';
import 'package:rebooked_app/views/profile/profile_screen.dart';
import 'package:rebooked_app/views/shell/shell_scaffold.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/Login',
  routes: [
    // This ShellRoute wraps all five "tab" routes in your bottom bar
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        // The child here will be whichever tab's page you're on.
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
              path: 'settings',
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

    // Request Details route outside shell
    GoRoute(
      path: '/requests/:swapId/details',
      builder: (context, state) {
        print('Router: Building RequestDetailsScreen');
        print('Router: Params: ${state.pathParameters}');
        print('Router: Extra: ${state.extra}');

        final swapId = state.pathParameters['swapId']!;
        final extra = state.extra as Map<String, dynamic>?;

        return RequestDetailsScreen(
          swapId: swapId,
          ownerId: extra?['ownerId'] ?? '',
          borrowerId: extra?['borrowerId'] ?? '',
          fromRoute: extra?['fromRoute'] ?? 'notifications',
        );
      },
    ),

    GoRoute(
      path: '/confirm',
      builder: (context, state) => ConfirmSwapPage(
        bookDetails: state.extra is Map<String, dynamic>
            ? state.extra as Map<String, dynamic>
            : null,
      ),
    ),

    GoRoute(
      path: '/book/:bookId',
      name: 'bookDetails',
      builder: (context, state) {
        final bookId = state.pathParameters['bookId']!;
        return BookDetailsScreen(bookId: bookId);
      },
    ),

    GoRoute(
        path: '/forgot-password', builder: (_, __) => ResetPasswordScreen1()),
    GoRoute(path: '/Login', builder: (_, __) => LoginPage()),
    GoRoute(path: '/Signup', builder: (_, __) => CreateAccountScreen()),
    GoRoute(path: '/swap-request', builder: (_, __) => SwapRequestsScreen()),
    GoRoute(
      name: 'swapDetailsById',
      path: '/swapDetails/:swapId',
      builder: (context, state) {
        final swapId = state.pathParameters['swapId']!;
        return RequestDetailsScreen(
          swapId: swapId,
          ownerId: '', // fetched inside the screen
          borrowerId: '', // fetched inside the screen
        );
      },
    ),
  ],
);
