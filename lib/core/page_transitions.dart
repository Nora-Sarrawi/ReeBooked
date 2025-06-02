import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppPageTransition extends CustomTransitionPage<void> {
  AppPageTransition({
    required LocalKey key,
    required Widget child,
  }) : super(
          key: key,
          child: child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Fade transition
            final fadeAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
              reverseCurve: Curves.easeOut,
            );

            // Slide transition
            final slideAnimation = Tween<Offset>(
              begin: const Offset(0.0, 0.05),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ));

            // Scale transition
            final scaleAnimation = Tween<double>(
              begin: 0.97,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ));

            return FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: ScaleTransition(
                  scale: scaleAnimation,
                  child: child,
                ),
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
        );
}
