import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionMonitor extends StatefulWidget {
  final Widget child;

  const ConnectionMonitor({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<ConnectionMonitor> createState() => _ConnectionMonitorState();
}

class _ConnectionMonitorState extends State<ConnectionMonitor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Timer? _hideTimer;
  late StreamSubscription<ConnectivityResult> _subscription;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;

  @override
  void initState() {
    super.initState();
    debugPrint('ConnectionMonitor: Initializing...');

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    // Initial check
    _initConnectivity();

    // Listen for changes
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      debugPrint('ConnectionMonitor: Connectivity changed to $result');
      _updateConnectionStatus(result);
    });
  }

  Future<void> _initConnectivity() async {
    debugPrint('ConnectionMonitor: Checking initial connectivity...');
    try {
      final result = await Connectivity().checkConnectivity();
      debugPrint('ConnectionMonitor: Initial connectivity status: $result');
      if (mounted) {
        setState(() => _connectionStatus = result);
        _updateConnectionStatus(result);
      }
    } catch (e) {
      debugPrint('ConnectionMonitor: Error checking connectivity: $e');
    }
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    debugPrint('ConnectionMonitor: Updating status to $result');
    if (!mounted) return;

    setState(() {
      _connectionStatus = result;
    });

    if (result == ConnectivityResult.none) {
      debugPrint('ConnectionMonitor: No connection, showing message');
      _controller.forward();
      _hideTimer?.cancel();
    } else {
      debugPrint('ConnectionMonitor: Connection restored, hiding message');
      _hideTimer?.cancel();
      _hideTimer = Timer(const Duration(seconds: 2), () {
        if (mounted) {
          _controller.reverse();
        }
      });
    }
  }

  Future<void> _retryConnection() async {
    debugPrint('ConnectionMonitor: Retrying connection check...');
    final result = await Connectivity().checkConnectivity();
    _updateConnectionStatus(result);
  }

  @override
  void dispose() {
    debugPrint('ConnectionMonitor: Disposing...');
    _controller.dispose();
    _hideTimer?.cancel();
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool showMessage = _connectionStatus == ConnectivityResult.none;
    debugPrint('ConnectionMonitor: Building widget, showMessage: $showMessage');

    return Material(
      type: MaterialType.transparency,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          children: [
            widget.child,
            if (showMessage)
              FadeTransition(
                opacity: _animation,
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.8, end: 1.0),
                      duration: const Duration(milliseconds: 200),
                      builder: (context, scale, child) {
                        return Transform.scale(
                          scale: scale,
                          child: child!,
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        width: 380,
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFFC76767).withOpacity(0.98),
                              const Color(0xFF562B56).withOpacity(0.98),
                            ],
                            stops: const [0.2, 0.8],
                          ),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFC76767).withOpacity(0.3),
                              blurRadius: 30,
                              offset: const Offset(-10, -10),
                            ),
                            BoxShadow(
                              color: const Color(0xFF562B56).withOpacity(0.3),
                              blurRadius: 30,
                              offset: const Offset(10, 10),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.wifi_off_rounded,
                                color: Colors.white,
                                size: 48,
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'No Internet Connection',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Please check your connection\nand try again',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 32),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: _retryConnection,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.white.withOpacity(0.2),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.refresh_rounded,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'Try Again',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
