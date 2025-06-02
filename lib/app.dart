import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rebooked_app/core/theme.dart';
import 'package:rebooked_app/core/router.dart';
import 'package:rebooked_app/widgets/connection_monitor.dart';

class ReBooked extends StatelessWidget {
  const ReBooked({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ReBooked',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      routerConfig: router,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: ConnectionMonitor(
            child: child ?? const SizedBox(),
          ),
        );
      },
    );
  }
}
