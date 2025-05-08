import 'package:flutter/material.dart';

class InitialsIcon extends StatelessWidget {
  final String initials;
  final double radius;
  final Color? backgroundColor;

  const InitialsIcon({
    required this.initials,
    this.radius = 15,
    this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor:
          backgroundColor ?? Theme.of(context).colorScheme.surfaceDim,
      child: Text(
        initials.padRight(2).substring(0, 2).trimRight().toUpperCase(),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: radius * 0.8),
      ),
    );
  }
}
