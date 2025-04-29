// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';


// import '../views/home_page.dart';
// import '../views/login_page.dart';
// import '../views/signup_page.dart';
// import '../views/book_details_page.dart';


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

//       builder: (context, state) => const SignupPage(),
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
