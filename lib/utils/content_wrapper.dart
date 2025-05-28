/* utils/responsive.dart */
import 'package:flutter/material.dart';

/// Centers its child and clamps the max width so things don’t stretch edge-to-edge
class MaxWidthBox extends StatelessWidget {
  const MaxWidthBox({required this.child, this.max = 800, super.key});
  final Widget child;
  final double max;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: max),
        child: child,
      ),
    );
  }
}
