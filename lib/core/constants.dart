import 'package:flutter/material.dart';

/// Common padding values
class AppPadding {
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
  static const EdgeInsets screenPadding = EdgeInsets.all(medium);
}

/// Common animation durations
class AppDurations {
  static const Duration short = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 400);
  static const Duration long = Duration(milliseconds: 600);
}

/// String keys used for things like storage or navigation
class AppKeys {
  static const String isLoggedIn = 'is_logged_in';
  static const String userToken = 'user_token';
  static const String onboardingSeen = 'onboarding_seen';
}
