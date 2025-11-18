import 'package:flutter/material.dart';

class AppWrapper extends StatelessWidget {
  final Widget child;

  const AppWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Simply return the child as-is
    return child;
  }
}
