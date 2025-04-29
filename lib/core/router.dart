// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// import '../views/home/home_screen.dart';
// import '../views/auth/login_screen.dart';
// import '../views/auth/signup_screen.dart';
// import '../views/books/book_detail_screen.dart';

// final GoRouter appRouter = GoRouter(
//   routes: [
//     GoRoute(
//       path: '/',
//       name: 'home',
//       builder: (context, state) => const HomePage(),
//     ),
//     GoRoute(
//       path: '/login',
//       name: 'login',
//       builder: (context, state) => const LoginPage(),
//     ),
//     GoRoute(
//       path: '/signup',
//       name: 'signup',
//       builder: (context, state) => const CreateAccountScreen(),
//     ),
//     GoRoute(
//       path: '/book/:id',
//       name: 'bookDetails',
//       builder: (context, state) {
//         final id = state.pathParameters['id'];
//         return BookDetailsPage(bookId: id ?? 'unknown');
//       },
//     ),
//   ],
// );
