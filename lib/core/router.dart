import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rebooked_app/core/page_transitions.dart';

import 'package:rebooked_app/providers/swap_provider.dart';
import 'package:rebooked_app/views/auth/login_screen.dart';
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
  initialLocation: '/start',
  debugLogDiagnostics: false, // Disable debug logging in production
  routerNeglect: true, // Enable route optimization
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
          pageBuilder: (context, state) => AppPageTransition(
            key: state.pageKey,
            child: const HomeScreen(),
          ),
        ),
        GoRoute(
          path: '/requests',
          pageBuilder: (context, state) => AppPageTransition(
            key: state.pageKey,
            child: SwapRequestsScreen(),
          ),
        ),
        GoRoute(
          path: '/my-books',
          pageBuilder: (context, state) => AppPageTransition(
            key: state.pageKey,
            child: const MyBooksScreen(),
          ),
        ),
        GoRoute(
          path: '/notifications',
          pageBuilder: (context, state) => AppPageTransition(
            key: state.pageKey,
            child: const NotificationsScreen(),
          ),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => AppPageTransition(
            key: state.pageKey,
            child: ProfileScreen(),
          ),
          routes: [
            GoRoute(
              path: 'settings',
              pageBuilder: (context, state) => AppPageTransition(
                key: state.pageKey,
                child: SettingsPage(),
              ),
            ),
          ],
        ),
      ],
    ),

    // Any other full‐screen static pages come outside the shell:
    GoRoute(
      path: '/start',
      pageBuilder: (context, state) => AppPageTransition(
        key: state.pageKey,
        child: const StartScreen(),
      ),
    ),
    GoRoute(
      path: '/settings',
      pageBuilder: (context, state) => AppPageTransition(
        key: state.pageKey,
        child: SettingsPage(),
      ),
    ),
    GoRoute(
      path: '/add-book',
      pageBuilder: (context, state) => AppPageTransition(
        key: state.pageKey,
        child: AddBookScreen(),
      ),
    ),

    // Request Details route outside shell
    GoRoute(
      path: '/requests/:swapId/details',
      pageBuilder: (context, state) {
        final swapId = state.pathParameters['swapId']!;
        final extra = state.extra as Map<String, dynamic>?;

        return AppPageTransition(
          key: state.pageKey,
          child: RequestDetailsScreen(
            swapId: swapId,
            ownerId: extra?['ownerId'] ?? '',
            borrowerId: extra?['borrowerId'] ?? '',
            fromRoute: extra?['fromRoute'] ?? 'notifications',
          ),
        );
      },
    ),

    GoRoute(
      path: '/confirm',
      pageBuilder: (context, state) => AppPageTransition(
        key: state.pageKey,
        child: ConfirmSwapPage(
          bookDetails: state.extra is Map<String, dynamic>
              ? state.extra as Map<String, dynamic>
              : null,
        ),
      ),
    ),

    GoRoute(
      path: '/book/:bookId',
      name: 'bookDetails',
      pageBuilder: (context, state) => AppPageTransition(
        key: state.pageKey,
        child: BookDetailsScreen(bookId: state.pathParameters['bookId']!),
      ),
    ),

    GoRoute(
      path: '/forgot-password',
      pageBuilder: (context, state) => AppPageTransition(
        key: state.pageKey,
        child: ResetPasswordScreen1(),
      ),
    ),
    GoRoute(
      path: '/Login',
      pageBuilder: (context, state) => AppPageTransition(
        key: state.pageKey,
        child: LoginPage(),
      ),
    ),
    GoRoute(
      path: '/Signup',
      pageBuilder: (context, state) => AppPageTransition(
        key: state.pageKey,
        child: CreateAccountScreen(),
      ),
    ),
    GoRoute(
      path: '/swap-request',
      pageBuilder: (context, state) => AppPageTransition(
        key: state.pageKey,
        child: SwapRequestsScreen(),
      ),
    ),
    GoRoute(
      name: 'swapDetailsById',
      path: '/swapDetails/:swapId',
      pageBuilder: (context, state) => AppPageTransition(
        key: state.pageKey,
        child: RequestDetailsScreen(
          swapId: state.pathParameters['swapId']!,
          ownerId: '', // fetched inside the screen
          borrowerId: '', // fetched inside the screen
        ),
      ),
    ),
  ],
);
