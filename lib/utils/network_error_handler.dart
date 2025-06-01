import 'package:flutter/material.dart';
import 'package:rebooked_app/widgets/network_error_dialog.dart';

class NetworkErrorHandler {
  static bool isNetworkError(String error) {
    return error.toLowerCase().contains('network') ||
        error.toLowerCase().contains('connection') ||
        error.toLowerCase().contains('socket') ||
        error.toLowerCase().contains('timeout');
  }

  static void handleError(BuildContext context, dynamic error,
      {VoidCallback? onRetry}) {
    final errorMessage = error.toString();

    if (isNetworkError(errorMessage)) {
      NetworkErrorDialog.show(context, onRetry: onRetry);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }
}
