import 'package:flutter/material.dart';

import '../../theme/app_design_tokens.dart';

class AppIconTile extends StatelessWidget {
  const AppIconTile({
    super.key,
    required this.icon,
    this.iconColor = AppColors.accent,
    this.backgroundColor = AppColors.iconSurface,
    this.size = 54,
    this.iconSize = 24,
    this.borderRadius = AppRadius.lg,
  });

  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final double size;
  final double iconSize;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Icon(icon, color: iconColor, size: iconSize),
    );
  }
}
